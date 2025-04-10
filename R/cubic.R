# rBiasCorrection: Correct Bias in Quantitative DNA Methylation Analyses.
# Copyright (C) 2019-2025 Lorenz Kapsner
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


# implementation of cubic equation
cubic_eq <- function(x, a, b, c, d) {
  return(
    (a * x^3 + b * x^2 + c * x + d)
  )
}

cubic_eq_minmax <- function(x, a, b, y0, y1, m0, m1) {
  return(
    (a * (x - m0)^3 +
       b * (x - m0)^2 +
       (x - m0) * (((y1 - y0) /
                      (m1 - m0)) - a * (m1 - m0)^2 - b * (m1 - m0))
     + y0)
  )
}

cubic_fitter <- function(target_levels, true_levels) {
  pol_reg <- stats::lm(
    target_levels ~ true_levels +
      I(true_levels^2) +
      I(true_levels^3)
  )
  return(pol_reg)
}

# find best parameters for cubic regression
cubic_regression <- function(df_agg,
                             vec,
                             logfilename,
                             minmax,
                             seed) {
  write_log(message = "Entered 'cubic_regression'-Function",
            logfilename = logfilename)

  dat <- data.table::copy(df_agg)

  # true y-values
  true_levels <- dat[, get("true_methylation")]
  target_levels <- dat[, get("CpG")]

  if (isFALSE(minmax)) {
    write_log(message = "'cubic_regression': minmax = FALSE",
              logfilename = logfilename)

    pol_reg <- cubic_fitter(target_levels = target_levels,
                            true_levels = true_levels)
    cof <- stats::coefficients(pol_reg)

    # correct values
    fitted_values <- cubic_eq(
      x = true_levels,
      a = cof[4],
      b  = cof[3],
      c = cof[2],
      d = cof[1]
    )

  } else if (isTRUE(minmax)) {
    write_log(
      message = paste0("'cubic_regression': minmax = TRUE --> WARNING: ",
                       "this is experimental"),
      logfilename = logfilename)

    # extract parameters of equation
    y0 <- dat[
      get("true_methylation") == dat[
        , min(get("true_methylation"))
        ], get("CpG")
      ]
    y1 <- dat[
      get("true_methylation") == dat[
        , max(get("true_methylation"))
        ], get("CpG")
      ]
    m0 <- dat[, min(get("true_methylation"))]
    m1 <- dat[, max(get("true_methylation"))]

    c <- nls_solver(
      true_levels = true_levels,
      target_levels = target_levels,
      type = "cubic_eq_minmax",
      logfilename = logfilename,
      seed = seed,
      y0 = y0,
      y1 = y1,
      m0 = m0,
      m1 = m1
    )

    # get coefficients
    coe <- stats::coef(c)
    a <- coe[["a"]]
    b <- coe[["b"]]

    fitted_values <- cubic_eq_minmax(
      x = true_levels,
      a = a,
      b = b,
      y0 = y0,
      y1 = y1,
      m0 = m0,
      m1 = m1
    )

  }

  sse_tss_list <- sse_tss(datatable = dat, fitted_values = fitted_values)

  # sum of squared errors
  outlist <- list("SSE_cubic" = sse_tss_list$sse)

  if (isFALSE(minmax)) {
    outlist[["Coef_cubic"]] <- list("a" = unname(cof[4]),
                                    "b" = unname(cof[3]),
                                    "c" = unname(cof[2]),
                                    "d" = unname(cof[1]),
                                    "R2" = 1 - (sse_tss_list$sse /
                                                  sse_tss_list$tss))
  } else if (isTRUE(minmax)) {

    outlist[["Coef_cubic"]] <- list("y0" = y0,
                                    "y1" = y1,
                                    "a" = a,
                                    "b" = b,
                                    "m0" = m0,
                                    "m1" = m1,
                                    "R2" = 1 - (sse_tss_list$sse /
                                                  sse_tss_list$tss))
  }
  return(outlist)
}
