prefix <- tempdir()

# the writeLog-function needs the logfilename
logfilename <- paste0(prefix, "/log.txt")

library(data.table)

test_that(
  desc = "test normal function of file import of type 1",
  code = {

    local_edition(3)
    local_reproducible_output(rstudio = TRUE)

    # experimental data
    exp_type_1 <- fread("./testdata/exp_type_1.csv")
    exp_type_1 <- clean_dt(exp_type_1, "experimental", 1, logfilename)
    expect_type(exp_type_1, "list")
    expect_snapshot(
      x = round(table_prep(exp_type_1[["dat"]]), 1),
      cran = FALSE,
      error = FALSE
    )

    exp_type_1 <- fread("./testdata/exp_type_1_empty_col.csv", header = TRUE)
    exp_type_1 <- clean_dt(exp_type_1, "experimental", 1, logfilename)[["dat"]]
    expect_snapshot(
      x = round(table_prep(exp_type_1), 1),
      cran = FALSE,
      error = FALSE
    )

    exp_type_1 <- fread("./testdata/exp_type_1_empty_row.csv")
    exp_type_1 <- clean_dt(exp_type_1, "experimental", 1, logfilename)[["dat"]]
    expect_snapshot(
      x = round(table_prep(exp_type_1), 1),
      cran = FALSE,
      error = FALSE
    )

    # calibration data
    cal_type_1 <- fread("./testdata/cal_type_1.csv")
    cal_type_1 <- clean_dt(cal_type_1, "calibration", 1, logfilename)[["dat"]]
    expect_snapshot(
      x = round(table_prep(cal_type_1), 1),
      cran = FALSE,
      error = FALSE
    )
  })

test_that(
  desc = "test normal function of file import of type 2",
  code = {

    local_edition(3)
    local_reproducible_output(rstudio = TRUE)

    # experimental data
    exp_type_2 <- fread("./testdata/exp_type_2.csv")
    exp_type_2 <- clean_dt(exp_type_2, "experimental", 2, logfilename)[["dat"]]
    expect_snapshot(
      x = round(table_prep(exp_type_2), 1),
      cran = FALSE,
      error = FALSE
    )

    exp_type_2 <- fread("./testdata/exp_type_2_empty_col.csv", header = TRUE)
    exp_type_2 <- clean_dt(exp_type_2, "experimental", 2, logfilename)[["dat"]]
    expect_snapshot(
      x = round(table_prep(exp_type_2), 1),
      cran = FALSE,
      error = FALSE
    )

    exp_type_2 <- fread("./testdata/exp_type_2_empty_row.csv")
    exp_type_2 <- clean_dt(exp_type_2, "experimental", 2, logfilename)[["dat"]]
    expect_snapshot(
      x = round(table_prep(exp_type_2), 1),
      cran = FALSE,
      error = FALSE
    )

    # calibration data
    cal_type_2 <- fread("./testdata/cal_type_2.csv")
    cal_type_2 <- clean_dt(cal_type_2, "calibration", 2, logfilename)[["dat"]]
    expect_snapshot(
      x = round(table_prep(cal_type_2), 1),
      cran = FALSE,
      error = FALSE
    )
  })

test_that(
  desc = "wrong description",
  code = {

    local_edition(3)
    local_reproducible_output(rstudio = TRUE)

    # type 1 data
    cal_type_1 <- fread("./testdata/cal_type_1.csv")
    expect_error(clean_dt(cal_type_1, "calibraRAtion", 1, logfilename))

    exp_type_1 <- fread("./testdata/exp_type_1.csv")
    expect_error(clean_dt(exp_type_1, "experiRINKLmental", 1, logfilename))

    # type 2 data
    cal_type_2 <- fread("./testdata/cal_type_2.csv")
    expect_error(clean_dt(cal_type_2, "calibraRAtion", 2, logfilename))

    exp_type_2 <- fread("./testdata/exp_type_2.csv")
    expect_error(clean_dt(exp_type_2, "experiRINKLmental", 2, logfilename))
  })

# wrong type
test_that(
  desc = "wrong type",
  code = {

    local_edition(3)
    local_reproducible_output(rstudio = TRUE)

    # type 1 data
    cal_type_1 <- fread("./testdata/cal_type_1.csv")
    expect_error(clean_dt(cal_type_1, "calibration", 3L, logfilename))
    expect_error(clean_dt(cal_type_1, "calibration", "a", logfilename))

    exp_type_1 <- fread("./testdata/exp_type_1.csv")
    expect_error(clean_dt(exp_type_1, "experimental", 65L, logfilename))
    expect_error(clean_dt(exp_type_1, "experimental", "tre", logfilename))

    # type 2 data
    cal_type_2 <- fread("./testdata/cal_type_2.csv")
    expect_error(clean_dt(cal_type_2, "calibration", 3L, logfilename))
    expect_error(clean_dt(cal_type_2, "calibration", "a", logfilename))

    exp_type_2 <- fread("./testdata/exp_type_2.csv")
    expect_error(clean_dt(exp_type_2, "experimental", 65L, logfilename))
    expect_error(clean_dt(exp_type_2, "experimental", "tre", logfilename))
  })

# wrong first col
test_that(
  desc = "wrong first column in calibration data type 1",
  code = {

    local_edition(3)
    local_reproducible_output(rstudio = TRUE)

    # type 1 data
    cal_type_1 <- fread("./testdata/cal_type_1_wrong_col_1.csv")
    expect_null(clean_dt(cal_type_1, "calibration", 1, logfilename))

    cal_type_1 <- fread("./testdata/cal_type_1_wrong_col_1_2.csv")
    expect_null(clean_dt(cal_type_1, "calibration", 1, logfilename))

    cal_type_1 <- fread("./testdata/cal_type_1_less4.csv")
    expect_null(clean_dt(cal_type_1, "calibration", 1, logfilename))
  })

# heterogenous cpg-sites per locus
test_that(
  desc = "heterogenous cpg-sites per locus in type 2 data",
  code = {

    local_edition(3)
    local_reproducible_output(rstudio = TRUE)

    cal_type_2 <- fread("./testdata/cal_type_2_heterogenous.csv")
    expect_null(clean_dt(cal_type_2, "calibration", 2, logfilename))

    exp_type_2 <- fread("./testdata/exp_type_2_heterogenous.csv")
    expect_null(clean_dt(exp_type_2, "experimental", 2, logfilename))

    expect_true(file.remove(paste0(prefix, "/log.txt")))
  })
