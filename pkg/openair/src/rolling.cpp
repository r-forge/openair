#include <Rcpp.h>
using namespace Rcpp;

// This function calculates rolling means taking acount of the window size and a
// data capture threshold. Means are calculated only when the data capture is >
// than 'cap' else NA is returned.

// The rolling mean gives the mean of the *previous* len hours

RcppExport SEXP rollingMean(SEXP x, SEXP len, SEXP cap) {
  NumericVector A(x); // the data
  NumericVector res(x); // for results
  LogicalVector NA(x); // for missings

  double capr = as<int>(cap); // data capture %
  int lenr = as<int>(len); // window size %

  NumericVector missing(1);
  int n = A.size(); // length of data
  double sum = 0.0; // sum of values over window
  double sumNA = 0; // number of missings

  NA = is_na(A) ; // logical vector of missings
  missing[0] = NA_REAL;

  // main loop
  for (int i = 0; i <= (n - lenr); i++) {
    sum = 0; // initialise
    sumNA = 0;

    // now go through each window
    for (int j = i; j < i + lenr; j++) {

      if (NA(j)) {
        sumNA += 1; // count missings
      }
      else
        {
          sum += A(j); // sum values that are not missing
        }
    }

    // calculate mean if within data capture threshold, if not set to missing

    if (1 - sumNA / lenr < capr / 100) {
      res(i + lenr - 1) = missing[0];
    }
    else
      {
        res(i + lenr - 1) = sum / (lenr - sumNA);
      }
  }

  // pad out missing data at start where there are < lenr values

  for (int i = 0; i < lenr - 1; i++) {

    sumNA = lenr - i - 1; //missing because not there
    sum = 0;

    for (int j = 0; j <= i; j++) {

      if (NA(j)) {
        sumNA += 1; // count missings
      }
      else
        {
          sum += A(j); // sum values that are not missing
        }
    }

    if (1 - sumNA / lenr < capr / 100) {
      res(i) = missing[0];
    }
    else
      {
	res(i) = sum / (lenr - sumNA);
      }

  }

  return res;
}
