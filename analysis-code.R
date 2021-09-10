# Libraries
library(readr) # reading and writing delimited text files
library(dplyr) # SQL-style data processing
library(tidytext) # text analysis in R
library(stringr) # working with text strings
library(lubridate) # working with times and dates
library(tidyr) # data reshaping
library(janitor) # cleaning
library(sylcount) # counting syllables
library(tidyr)
library(quanteda) # counting words and sentences

# Set working directory
setwd("~/Desktop")

############################################################
######################## IMPORT ############################
############################################################

# Import tweets
library(readr)
cox <- read_csv("report_beastjohncox/tweets.csv")

newsom <- read_csv("report_gavinnewsom/tweets.csv")

faulc <- read_csv("report_kevin_faulconer/tweets.csv")

elder <- read_csv("report_larryelder/tweets.csv")

############################################################
######################## CLEAN #############################
############################################################

# Clean all column names
library(janitor)
cox <- cox %>% 
  clean_names()

newsom <- newsom %>% 
  clean_names()

faulc <- faulc %>% 
  clean_names()

elder <- elder %>% 
  clean_names()

# Fix time and dates for dfs
## Convert date into date format
cox$date <- as.Date(cox$tweet_posted_time, "%m/%d/%Y")
newsom$date <- as.Date(newsom$tweet_posted_time, "%m/%d/%Y")
faulc$date <- as.Date(faulc$tweet_posted_time, "%m/%d/%Y")
elder$date <- as.Date(elder$tweet_posted_time, "%m/%d/%Y")

## Convert time into time format
cox$time <- format(cox$tweet_posted_time, format = "%H:%M:%S")
newsom$time <- format(newsom$tweet_posted_time, format = "%H:%M:%S")
faulc$time <- format(faulc$tweet_posted_time, format = "%H:%M:%S")
elder$time <- format(elder$tweet_posted_time, format = "%H:%M:%S")

min(cox$date) # "2017-07-01"
min(newsom$date) # "2019-11-07"
min(faulc$date) # "2015-11-10"
min(elder$date) # "2021-02-28"

# Add final account name to be able to count total tweets,
## in addition to retweets coming from other accounts
cox$name_all <- "cox"
newsom$name_all <- "newsom"
faulc$name_all <- "faulc"
elder$name_all <- "elder"

# Merge together
tweets <- rbind(cox, newsom, faulc, elder)

# Filter to March 4, 2021, to present
## One year after state of emergency was declared
tweets <- tweets %>% 
  filter(date >= "2021-03-04")

remove(cox, newsom, faulc, elder)

############################################################
#################### COUNT ANALYSIS ########################
############################################################

# Determine frequency of tweets by month
## First create month column
tweets$month <- month(tweets$date, label = TRUE, abbr = TRUE)

# Create weekday column
tweets$day <- wday(tweets$date, label = TRUE, abbr = TRUE)

# Create count column to make things easier
tweets$count <- "1"
tweets$count <- as.numeric(tweets$count)

# Calculate total among all candidates
tweets %>% 
  group_by(tweet_type) %>% 
  count()

# tweet_type     n
# Reply        218 # 4.1 percent
# Retweet     1133 # 21.2 percent
# Tweet       3995 # 74.7 percent

# Calculate total tweets by candidate
totals <- tweets %>% 
  group_by(name_all, tweet_type) %>% 
  count()

# Spread
totals <- totals %>%
  spread(key = tweet_type, value = n, fill = 0)

# Create total column
totals <- totals %>% 
  mutate(total = Reply + Retweet + Tweet)

# Calculate percents of each
totals <- totals %>% 
  mutate(reply_per = round(Reply / total * 100, 1),
         retweet_per = round(Retweet / total * 100, 1),
         tweet_per = round(Tweet / total * 100, 1))

write.csv(totals, "totals-by-tweet-type.csv")

############################################################
#################### MONTHS ANALYSIS #######################
############################################################

# Calculate frequency of original tweets by month this year
tweet_months <- tweets %>% 
  filter(tweet_type == "Tweet") %>% 
  group_by(name, month) %>% 
  summarise(tot_tweets = n())

# Spread
tweet_months <- tweet_months %>%
  spread(key = name, value = tot_tweets, fill = 0)

# Rename
tweet_months <- tweet_months %>% 
  clean_names()

# Calculate percents
tweet_months <- tweet_months %>% 
  mutate(newsom_per = round(gavin_newsom / sum(gavin_newsom) * 100, 1),
         cox_per = round(john_cox / sum(john_cox) * 100, 1),
         faulc_per = round(kevin_faulconer / sum(kevin_faulconer) * 100, 1),
         elder_per = round(larry_elder / sum(larry_elder) * 100, 1))

write.csv(tweet_months, "tweets-by-month.csv")

# Do the same for all tweets, not just original ones
## Calculate frequency of all tweets by month this year
months <- tweets %>% 
  group_by(name_all, month) %>% 
  summarise(tot_tweets = n())

# Spread
months <- months %>%
  spread(key = name_all, value = tot_tweets, fill = 0)

# Rename
months <- months %>% 
  clean_names()

# Calculate percents
months <- months %>% 
  mutate(newsom_per = round(newsom / sum(newsom) * 100, 1),
         cox_per = round(cox / sum(cox) * 100, 1),
         faulc_per = round(faulc / sum(faulc) * 100, 1),
         elder_per = round(elder / sum(elder) * 100, 1))

############################################################
###################### DAYS ANALYSIS #######################
############################################################

# Calculate frequency of original tweets by day of the week this year
tweet_days <- tweets %>% 
  filter(tweet_type == "Tweet") %>% 
  group_by(name, day) %>% 
  summarise(tot_tweets = n())

# Spread
tweet_days <- tweet_days %>%
  spread(key = name, value = tot_tweets, fill = 0)

# Rename
tweet_days <- tweet_days %>% 
  clean_names()

# Calculate percents
tweet_days <- tweet_days %>% 
  mutate(newsom_per = round(gavin_newsom / sum(gavin_newsom) * 100, 1),
         cox_per = round(john_cox / sum(john_cox) * 100, 1),
         faulc_per = round(kevin_faulconer / sum(kevin_faulconer) * 100, 1),
         elder_per = round(larry_elder / sum(larry_elder) * 100, 1))

write.csv(tweet_days, "tweets-by-day.csv")

# Do the same for all tweets, not just original ones
## Calculate frequency of all tweets by day of the week this year
days <- tweets %>%
  group_by(name_all, day) %>% 
  summarise(tot_tweets = n())

# Spread
days <- days %>%
  spread(key = name_all, value = tot_tweets, fill = 0)

# Rename
days <- days %>% 
  clean_names()

# Calculate percents
days <- days %>% 
  mutate(newsom_per = round(newsom / sum(newsom) * 100, 1),
         cox_per = round(cox / sum(cox) * 100, 1),
         faulc_per = round(faulc / sum(faulc) * 100, 1),
         elder_per = round(elder / sum(elder) * 100, 1))

############################################################
################# POPULAR TWEETS ANALYSIS ##################
############################################################
# Calculate range of retweet counts for each candidate
## Original tweets only
cox_retweets <- tweets %>% 
  filter(tweet_type == "Tweet", name == '"John Cox"')
mean(cox_retweets$retweets_received)
# 12.17578
max(cox_retweets$retweets_received)
# 89
mean(cox_retweets$likes_received)
# 45.91992
max(cox_retweets$likes_received)
# 340

newsom_retweets <- tweets %>% 
  filter(tweet_type == "Tweet", name == '"Gavin Newsom"')
mean(newsom_retweets$retweets_received)
# 1173.841
max(newsom_retweets$retweets_received)
# 9206
mean(newsom_retweets$likes_received)
# 7048.685
max(newsom_retweets$likes_received)
# 45544

elder_retweets <- tweets %>% 
  filter(tweet_type == "Tweet", name == '"Larry Elder"')
mean(elder_retweets$retweets_received)
# 273.2965
max(elder_retweets$retweets_received)
# 12687
mean(elder_retweets$likes_received)
# 1240.66
max(elder_retweets$likes_received)
# 62068

faulc_retweets <- tweets %>% 
  filter(tweet_type == "Tweet", name == '"Kevin Faulconer"')
mean(faulc_retweets$retweets_received)
# 22.61835
max(faulc_retweets$retweets_received)
# 324
mean(faulc_retweets$likes_received)
# 117.6807
max(faulc_retweets$likes_received)
# 1030

# Count total retweets among original tweets
retweet_count <- tweets %>% 
  filter(tweet_type == "Tweet") %>% 
  group_by(name) %>% 
  summarise(retweets = sum(retweets_received),
            total_tweets = sum(count))

write.csv(retweet_count, "retweets-by-candidate.csv")

# Count total likes among original tweets
likes_count <- tweets %>% 
  filter(tweet_type == "Tweet") %>% 
  group_by(name) %>% 
  summarise(likes = sum(likes_received),
            total_tweets = sum(count))

write.csv(likes_count, "likes-by-candidate.csv")

############################################################
###################### WORDS ANALYSIS ######################
############################################################

# Regex for parsing tweets
replace_reg <- "https?://[^\\s]+|&amp;|&lt;|&gt;|\bRT\\b"

library(tidytext)
library(dplyr)
# Filter out retweets
## Remove URLs and unwanted character expressions
words <- tweets %>%
  filter(tweet_type == "Tweet") %>%
  mutate(text = str_replace_all(tweet_content, replace_reg, "")) %>%
  unnest_tokens(word, text, token = "tweets")

# Remove stop words / aka common words like the and this
words <- words %>%
  anti_join(stop_words, by = "word")

# Frequency of words
words_count <- words %>%
  group_by(name, word) %>%
  count()

# Spread
words_count <- words_count %>%
  spread(key = name, value = n, fill = 0)

write.csv(words_count, "common-words-by-candidate.csv")

############################################################
##################### BIGRAM ANALYSIS ######################
############################################################

# Split tweets into word pairs
bigrams <- tweets %>% 
  filter(tweet_type == "Tweet") %>%
  mutate(text = str_replace_all(tweet_content, replace_reg, "")) %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2)

# Remove stop words from bigrams
## Separate them into two, then antijoin with stop words
### Remove bigrams containing "words" without any alphabetic characters
bigrams <- bigrams %>%
  separate(bigram, into = c("first","second"), sep = " ", remove = FALSE) %>%
  anti_join(stop_words, by = c("first" = "word")) %>%
  anti_join(stop_words, by = c("second" = "word")) %>%
  filter(str_detect(first, "[a-z]") &
           str_detect(second, "[a-z]"))

# Frequency of bigrams
bigrams_count <- bigrams %>%
  group_by(name, bigram) %>%
  count()

# Spread
bigrams_count <- bigrams_count %>%
  spread(key = name, value = n, fill = 0)

write.csv(bigrams_count, "common-phrases-by-candidate.csv")

############################################################
################## SENTIMENT ANALYSIS ######################
############################################################

# Load lexicon from https://www.cs.uic.edu/~liub/FBS/sentiment-analysis.html
bing <- get_sentiments("bing")
library(textdata)
# Other sentiment datasets include:
# loughran <- get_sentiments("loughran")
# nrc <- get_sentiments("nrc")

# Custom stop words, to be removed from analysis
custom_stop_words <- tibble(word = c("ca","california","amp", "trump",
                                     "californians", "issues",
                                     "issue"))

# Join sentiments
sentiments <- words %>%
  inner_join(bing, by = "word") %>%
  anti_join(custom_stop_words, by = "word")

# Count sentiments
sentiments_counts <- sentiments %>%
  group_by(name) %>%
  count(sentiment) %>%
  arrange(-n)

# Percentages for negative sentiments
neg_freqs <- sentiments_counts %>%
  left_join(sentiments_counts %>% 
              group_by(name) %>% 
              summarise(total_words = sum(n))) %>%
  mutate(percent = round(n/total_words*100,2)) %>%
  filter(sentiment == "negative")

names(neg_freqs) <- c("name", "sentiment", "total_neg_words", "total_words", "percent")

write.csv(neg_freqs, "negative-word-count-by-candidate.csv")

# Percentages for positive sentiments
pos_freqs <- sentiments_counts %>%
  left_join(sentiments_counts %>% 
              group_by(name) %>% 
              summarise(total_words = sum(n))) %>%
  mutate(percent = round(n/total_words*100,2)) %>%
  filter(sentiment == "positive")

names(pos_freqs) <- c("name", "sentiment", "total_pos_words", "total_words", "percent")

write.csv(pos_freqs, "positive-word-count-by-candidate.csv")

############################################################
################### ACCOUNTS ANALYSIS ######################
############################################################

# Which handles do they mention the most?
handles <- words %>%
  filter(grepl("@", word) & word != "@") %>% 
  filter(tweet_type == "Tweet") %>% 
  group_by(name) %>% 
  # clean possessives
  mutate(word = gsub("'s","", word)) %>%
  count(word) %>%
  arrange(-n)

# Spread
handles <- handles %>%
  spread(key = name, value = n, fill = 0)

write.csv(handles, "handles-count-by-candidates.csv")

############################################################
################ SYLLABLE / WORD ANALYSIS ##################
############################################################

# Count syllables and words in each tweet
library(sylcount)
library(quanteda)
syls <- tweets %>%
  filter(tweet_type == "Tweet") %>% 
  mutate(syllables = sylcount(tweet_content, counts.only = TRUE),
         sentences = nsentence(tweet_content),
         words = ntoken(tweet_content, remove_punct = TRUE))

# Select out syllable and tweet ID column
test <- syls %>% 
  select(tweet_id, syllables)

# Separate syllables into columns
## This takes a while for dfs with high row count
library(tidyr)
test <- unnest_wider(test, syllables)

# Calculate sum of syllables
test <- test %>%
  rowwise() %>%
  mutate(syllables1 = sum(c_across(2:63), na.rm = TRUE))

# Select tweet ID and sum to join back into original df
test <- test %>% 
  select(tweet_id, syllables1)

# Left join back together
syls <- left_join(syls, test, by = "tweet_id")

remove(test)
