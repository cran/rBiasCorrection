## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)
plotdir <- paste0(tempdir(), "/png/")
csvdir <- paste0(tempdir(), "/csv/")
dir.create(plotdir)
dir.create(csvdir)

# benchmarking times
times <- 10

## -----------------------------------------------------------------------------
#  library(rBiasCorrection)
#  
#  samplelocusname <- "CDH1"
#  seed <- 1234
#  
#  
#  data.table::fwrite(
#    rBiasCorrection::example.data_experimental$dat,
#    paste0(tempdir(), "/experimental_data.csv")
#  )
#  data.table::fwrite(
#    rBiasCorrection::example.data_calibration$dat,
#    paste0(tempdir(), "/calibration_data.csv")
#  )
#  
#  experimental <- paste0(tempdir(), "/experimental_data.csv")
#  calibration <- paste0(tempdir(), "/calibration_data.csv")

## ----warning=FALSE------------------------------------------------------------
#  future::availableCores()

## ----results='hide', message=FALSE, warning=FALSE, error=FALSE----------------
#  results_multi <- microbenchmark::microbenchmark({
#    rBiasCorrection::biascorrection(
#      experimental = experimental,
#      calibration = calibration,
#      samplelocusname = samplelocusname,
#      plotdir = plotdir,
#      csvdir = csvdir,
#      seed = seed
#    )},
#    times = times
#  )

## -----------------------------------------------------------------------------
#  results_multi

