# Libraries checklist

packages <- c('tidytext', 
             'ggplot2',
             'dplyr',
             'tibble',
             'wordcloud',
             'stringr',
             'SnowballC',
             'widyr',
             'janeaustenr',
             'treemapify')



# At ESALQ/USP classes it is normal to use a function to check if we have all the libraries installed
if ( sum (as.numeric ( !packages %in% installed.packages() )) != 0){
  installer = packages [!packages %in% installed.packages()]
  for ( i in 1:length(installer) ){
    install.packages(installer, dependencies = TRUE)
    break()
  }
  sapply ( packages, require, character = TRUE)
} else {
  sapply ( packages, require, character = TRUE)
}
