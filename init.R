# source('init.r')

# ----------- # # ----------- # # ----------- #
# DEPENDENCIES
dependencies <- c('reshape', 'knitr', 'markdown', 'ggplot2', 'scales', 'dplyr', 'RColorBrewer')
lapply(dependencies, require, character.only = TRUE)

# ----------- # # ----------- # # ----------- #
# SET UP

# helper functions

loadDir <- function(dir) {
  if (file.exists(dir)) {
    files <- dir(dir , pattern = '[.][rR]$')
    lapply(files, function(file) loadFile(file, dir))
  }
}

loadFile <- function(file, dir) {
  filename <- paste0(dir, '/', file)
  source(filename)
}

setReportingWd <- function() {
  if(basename(getwd()) == 'templates') {
    setwd('../../')
  }
}

knitrGlobalConfig <- function() {
  opts_chunk$set(fig.width = 14, fig.height = 6,
    fig.path = paste0(getwd(), '/reports/output/figures/',
    set_comment = NA))
}

setEnvVars <- function() {
  source('env.R')
}

# Config env
setReportingWd()
knitrGlobalConfig()
# setEnvVars() if you have env vars

# Load code
dirs <- c('extract', 'load', 'transform', 'plots', 'lib', 'models')
lapply(dirs, loadDir)
source('./reports/run.R')

# No scientific notation
options(scipen = 999)
