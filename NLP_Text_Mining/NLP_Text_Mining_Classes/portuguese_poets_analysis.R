# Activating the libraries

### First part: some exercises with portuguese-poems dataset
library("dplyr")
library("tidytext")
library("wordcloud")
library("stringr")
library("SnowballC")
library('treemapify')
library('ggplot2')

### First part: some exercises with portuguese-poems dataset
poems = read.csv('./files/portuguese-poems.csv')
poems = as_tibble(poems)

# Data cleaning
# 1. Changing the encodign (using functions iconv + SApply) and switch to lowercase
en <- function(x) iconv(x, to = "ASCII//TRANSLIT")
poems = sapply(poems, FUN = en)
poems = tolower(poems)
poems = as_tibble(poems)

# Spliting the data in 5 subsets
poets_views = tibble::as_tibble(poems[, c(1, 4)])
poets_contents = tibble::as_tibble(poems[, c(1, 3)])

# 2. Remove punctuation and numbers remove numbers

# Adding views by poet and creating a percentile column
poets_views$Author = stringr::str_replace_all(poets_views$Author, "[[:punct:]]", "")
poets_views = poets_views %>% group_by(Author) %>%
  summarize(Views = sum(as.numeric(Views))) %>% 
  arrange(desc(Views)) %>% mutate(quarts = ntile(Views, 100))

# Ploting a treemap regarding percentile's above or equal to 95 in viridis pallete and save the image
poets_views_plot = poets_views %>% dplyr::filter(quarts >= 95) %>% 
  ggplot2::ggplot(aes(area = Views, fill = quarts, label = Author)) + geom_treemap() +
  geom_treemap_text() +
  scale_fill_viridis_b()

ggplot2::ggsave("./files/poets_views_plot.png", poets_views_plot, width = 1300, height = 800, units = "px")

# Aggregating all the contents by author and remove repeated rows
poets_contents = poets_contents %>% group_by(Author) %>% mutate(texts = paste(unlist(Content), collapse = ' ')) %>%
  select(-Content) %>% distinct()

# 3. Unnesting text and remove stopwords
poets_contents_2 = poets_contents %>% unnest_tokens(word, texts) %>% filter(word != 'nao') %>%
  anti_join(get_stopwords(language = 'pt')) %>% anti_join(get_stopwords(language = 'en'))

# Which the word most cited by author
poets_count = poets_contents_2 %>% group_by(Author) %>% count(word, sort = TRUE)
poets_count$word_author = paste(poets_count$word, "_", poets_count$Author)
max = poets_count %>% group_by(Author) %>% slice(which.max(n)) %>% arrange(desc(n))

# wordcloud
pal = brewer.pal(8, "Dark2")
max_words = max %>% with(wordcloud(word_author, n, min.freq = 10, 
                                   random.order = FALSE, max.words = 50, colors = pal,
                                   random.color = TRUE))







