MORNING_STAR_RATIOS_URL <- "http://financials.morningstar.com/finan/ajax/exportKR2CSV.html?t="

extract.ratios <- function() {
  extract.ratiosRaw()
  extract.cleanRatios()
  extract.ratiosAll()
}

extract.ratiosAll <- function() {
  biz        <- read.csv('data/businesses.csv')
  ratio_list <- lapply(biz$ticker, load.ratio)
  Reduce(function(x, y) { rbind(x, y) }, ratio_list) %>%
    write.csv(paste0('data/ratios.csv'))
}

extract.ratiosRaw <- function() {
  biz <- read.csv('data/businesses.csv')
  mapply(extract.ratioRaw, biz$mstar_code, biz$ticker)
}

extract.ratioRaw <- function(mstar_code, ticker) {
  download.file(paste0(MORNING_STAR_RATIOS_URL, mstar_code),
    paste0('data/raw/', ticker, '.csv'))
}

extract.cleanRatios <- function() {
  biz <- read.csv('data/businesses.csv')
  mapply(extract.cleanRatio, biz$ticker)
}

extract.cleanRatio <- function(ticker) {
  extract.filterRatio(ticker)
  write.csv(extract.transformFilteredRatio(ticker), paste0('data/mstar/', ticker, '.csv'))
}

extract.filterRatio <- function(ticker) {
  text <- readLines(paste0('data/raw/', ticker, '.csv'))
  csv  <- text[grepl(',', text)]
  csv  <- csv[c(TRUE, !grepl('TTM|Latest Qtr', csv[2:length(csv)]))] # keep first line as header
  str  <- paste0('metric',paste(csv, collapse = '\n'))
  write(str, paste0('data/raw/filtered/', ticker, '.csv'))
}

extract.transformFilteredRatio <- function(ticker) {
  read.csv(paste0('data/raw/filtered/', ticker, '.csv')) %>%
    melt(id = 'metric') %>%
    mutate(year          = str_extract(as.character(variable), '[[:digit:]]{4}'),
           month         = str_extract(as.character(variable), '[[:digit:]]{2}$'),
           raw_value     = value,
           untrans_value = as.numeric(gsub(',', '', value)),
           value         = ifelse(grepl('Mil', metric), 1000000 * untrans_value, untrans_value),
           value         = ifelse(grepl('%', metric), untrans_value / 100, value))
}
