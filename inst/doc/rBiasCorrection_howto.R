## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(rBiasCorrection)

## -----------------------------------------------------------------------------
plotdir <- paste0(tempdir(), "/png/")
csvdir <- paste0(tempdir(), "/csv/")
dir.create(plotdir)
dir.create(csvdir)

samplelocusname <- "CDH1"
seed <- 1234

## -----------------------------------------------------------------------------
# First of all, the example-data have to be saved as CSV-files as
# `rBiasCorrection` expects CSV-files as input data.

cols <- c("sample_id", "CpG#1")
temp_file <- rBiasCorrection::example.data_experimental$dat[
  , cols, with = FALSE
]
data.table::fwrite(temp_file, paste0(tempdir(), "/experimental_data.csv"))
cols <- c("true_methylation", "CpG#1")
temp_file <- rBiasCorrection::example.data_calibration$dat[
  , cols, with = FALSE
]
data.table::fwrite(temp_file, paste0(tempdir(), "/calibration_data.csv"))

## -----------------------------------------------------------------------------
experimental <- paste0(tempdir(), "/experimental_data.csv")
calibration <- paste0(tempdir(), "/calibration_data.csv")

## ----results='hide', message=FALSE, warning=FALSE, error=FALSE----------------
rBiasCorrection::biascorrection(
  experimental = experimental,
  calibration = calibration,
  samplelocusname = samplelocusname,
  plotdir = plotdir,
  csvdir = csvdir,
  seed = seed,
  parallel = FALSE
)

## -----------------------------------------------------------------------------
filename <- list.files(csvdir)[
  grepl("regression_stats_[[:digit:]]", list.files(csvdir))
]
reg_stats <- data.table::fread(paste0(csvdir, filename))
knitr::kable(reg_stats[, 1:9])
knitr::kable(reg_stats[, 11:16])

## ----out.width='80%'----------------------------------------------------------
knitr::include_graphics(paste0(plotdir, "CDH1_CpG1.png"))

