# Activating the libraries

### First part: some exercises with lib's methods
library('dplyr')
library('tidytext')
library('ggplot2')
library('tibble')

### Second part: some exercises with financial sentiment file
library('wordcloud')
library('stringr')
library('SnowballC')



### Fist part: some short exercises with lib's methods

# Edgar Allan Poe's - The black cat
text <- c("From my infancy I was noted for the docility and humanity of my disposition.",
          "My tenderness of heart was even so conspicuous as to make me the jest of my companions.",
          "There is something in the unselfish and self-sacrificing love of a brute, which goes directly to the heart of him who has had frequent occasion to test the paltry friendship and gossamer fidelity of mere Man.")

# Transform to tibble format
#?tibble
text_tibble = tibble(line = 1:3, text = text)

# Tokenization
#?unnest_tokens: split a column into tokens from tidytext, transforming the text into lowercase and without punctuation
text_tokens = text_tibble %>% unnest_tokens(word, text)

# Cleaning stopwords and sorting by the most cited word
text_tokens_stopwords = text_tokens %>% anti_join(stop_words) %>% count(word, sort = TRUE)

# A bar chart to visualize the results
text_tokens_stopwords %>%
  #count(word, sort = TRUE) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col()

### Second part: some exercises with financial sentiment file
financial_file = read.csv('./files/Financial Sentiment.csv')
tibble = as_tibble(financial_file)

# Preparing the Sentence column 
sentences = tibble[,1]

# Tokenization, Filtering off the numbers, Applying stopwords, Counting and sorting
sentences = sentences %>% unnest_tokens(word, Sentence) %>% filter (!grepl('[0-9]', word)) %>% 
  anti_join(stop_words) %>% count(word, sort = TRUE)

# Stemming and sorting by count
# the result isn't good and we can see this in the wordcloud below
sentences_stem = sentences %>% mutate(stem = wordStem(word)) %>% count(stem, sort = TRUE)

# Wordcloud
pal = brewer.pal(10, "Dark2") # define the color pallete

# without stemming
sentences %>% with(wordcloud(word, n, random.order = FALSE, max.words = 50, colors = pal))

# with stemming
sentences_stem %>% with(wordcloud(stem, n, random.order = FALSE, max.words = 50, colors = pal))

