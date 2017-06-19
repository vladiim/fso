load.ratio <- function(ticker) {
  read.csv(paste0('data/mstar/', ticker, '.csv')) %>%
    select(metric, year, month, value) %>%
    filter(!is.na(value)) %>%
    mutate(ticker = ticker)
}

load.ratio <- function() {
  read.csv('data/ratios.csv')
}
