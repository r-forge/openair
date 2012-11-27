#include <Rcpp.h>
using namespace Rcpp;

// This function calculates rolling means taking acount of the window size and a
// data capture threshold. Means are calculated only when the data capture is >
// than 'cap' else NA is returned.

// The bulk of the calculations are run using the main function
// The ends are then dpecfically dealt with depending how the window is aligned

// Declarations
NumericVector ends(NumericVector A, LogicalVector NA, NumericVector res, std::string align,
		   int start, int end, int lenr, double capr);

RcppExport SEXP rollingMean(SEXP x, SEXP len, SEXP cap, SEXP align) {
  NumericVector A(x); // the data
  NumericVector res(x); // for results
  LogicalVector NA(x); // for missings

  double capr = as<int>(cap); // data capture %
  int lenr = as<int>(len); // window size %
  std::string alignr = as<std::string>(align); // window (left, center, right)

  int n = A.size(); // length of data
  double sum = 0.0; // sum of values over window
  double sumNA = 0; // number of missings
  int start = 0; //use this to set offset to get alignment
  int end = 0; //use this to set offset to get alignment

  NA = is_na(A) ; // logical vector of missings

  // make sure window width is less than data length
  if (lenr > n) {
    //  std::cout << "Window width more than length of data, use a smaller window width." ;
    lenr = 1;
  }

  // determine where to index and update
  if (alignr == "left") start = (lenr - 1);
  if ((alignr == "center") || (alignr == "centre")) {
    start = floor(lenr / 2);
    alignr = "centre"; // force single spelling!
  }

  // main loop
  for (int i = 0; i <= (n - lenr); i++) {
    sum = 0; // initialise
    sumNA = 0;

    // now go through each window
    for (int j = i; j < (i + lenr); j++) {

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
      res(i + lenr - 1 - start) = NA_REAL;
    }
    else
      {
        res(i + lenr - 1 - start) = sum / (lenr - sumNA);
      }
  }

  if (alignr == "right") start = 0, end = lenr - 2;
  if (alignr == "left") start = n - lenr, end = n - 1;

  res = ends(A, NA, res, alignr, start, end, lenr, capr);

  // For align = 'centre' need to deal with both ends
  if (alignr == "centre") {
    start = 0, end = floor(lenr / 2);
    alignr = "right";
    res = ends(A, NA, res, alignr, start, end, lenr, capr);

    alignr = "left";
    start = n - floor(lenr / 2), end = n - 1;
    res = ends(A, NA, res, alignr, start, end, lenr, capr);
  }

  return res;
}

// function to deal with ends where there is < len records
// This makes sure data capture threshold is still taken into account
NumericVector ends(NumericVector A, LogicalVector NA, NumericVector result, std::string
		   align, int start, int end, int lenr, double capr) {

  double sum = 0.0; // sum of values over window
  double sumNA = 0; // number of missings
  int nd = 0; //count of data points

  if (align == "right") {

    for (int i = start; i <= end; i++) {

      sumNA = end - start - i + 1; //missing because < len
      sum = 0.0;
      nd = 0;

      for (int j = start; j <= i; j++) {

	if (NA(j)) {
	  sumNA += 1; // count missings
	}
	else
	  {
	    nd +=1;
	    sum += A(j); // sum values that are not missing
	  }
      }

      if (1 - sumNA / lenr < capr / 100) {
	result(i) = NA_REAL;
      }
      else
	{
	  result(i) = sum / nd;
	}
    }
  }

  // left align deals with the end of the data
  if (align == "left") {

    for (int i = end; i >= start; i--) {

      sumNA = i - start + 1; //missing because < len
      sum = 0.0;
      nd = 0;

      for (int j = end; j >= i; j--) {

	if (NA(j)) {
	  sumNA += 1; // count missings
	}
	else
	  {
	    nd +=1;
	    sum += A(j); // sum values that are not missing
	  }
      }

      if (1 - sumNA / lenr < capr / 100) {
	result(i) = NA_REAL;
      }
      else
	{
	  result(i) = sum / nd;
	}
    }
  }
  return(result);
}
