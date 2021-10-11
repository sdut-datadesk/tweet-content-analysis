# Twitter content analysis of California gubernatorial candidates’ accounts
By: [Lauryn Schroeder](https://www.sandiegouniontribune.com/sdut-lauryn-schroeder-staff.html)

This repository contains data and code for the analysis [reported and published](https://www.sandiegouniontribune.com/news/watchdog/story/2021-09-11/candidate-tweets-tell-their-tales-in-run-up-to-recall-election) by *The San Diego Union-Tribune* on Sept. 10, 2021.

### About

Twitter has become a crucial tool for politicians to appeal to their electorate. The San Diego Union-Tribune sought to analyze the content of the messages sent to California voters in the months leading up to the recall election on Sept. 14, 2021.

The analysis reviews the content and trends seen in the Twitter accounts of California Gov. Gavin Newsom, and the top Republican challengers, Kevin Faulconer, Larry Elder and John Cox from March 4, 2021, through Sept. 7, 2021.

The analyses - in part - follows the code presented by [Peter Aldous](http://paldhous.github.io/NICAR/2019/r-text-analysis.html), who analyzed the tweets of former President Donald Trump.

### Methodology / Notes

The data includes the last 3,200 tweets for each candidate. Tweets were filtered to include only those published on or after March 4, 2021, one year after Gov. Newsom declared a state of emergency due to the coronavirus pandemic.

In analyzing the candidates' messages, the Union-Tribune relied on a University of Illinois Chicago database of nearly 6,800 opinion words. The [Opinion Lexicon](https://www.cs.uic.edu/~liub/FBS/sentiment-analysis.html#lexicon) describes each word as either "negative" or "positive."

### The SDUT repository contains the following:

- `report_beastjohncox/tweets.csv` - The past 3,200 tweets from the Twitter account of John Cox.
- `report_gavinnewsom/tweets.csv` - The past 3,200 tweets from the Twitter account of Gavin Newsom.
- `report_kevin_faulconer/tweets.csv` - The past 3,200 tweets from the Twitter account of Kevin Faulconer.
- `report_larryelder/tweets.csv` - The past 3,200 tweets from the Twitter account of Larry Elder.
- `analysis-code.R` - Import and analysis R script documenting findings published by the Union-Tribune.

### Sourcing
Please link and source [*The San Diego Union-Tribune*](https://www.sandiegouniontribune.com/) when referencing any analysis or findings in published work.

### Questions / Feedback

Email Lauryn Schroeder at [lauryn.schroeder@sduniontribune.com](mailto:lauryn.schroeder@sduniontribune.com)
