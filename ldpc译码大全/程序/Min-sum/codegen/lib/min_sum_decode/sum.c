/*
 * File: sum.c
 *
 * MATLAB Coder version            : 2.7
 * C/C++ source code generated on  : 29-Jan-2015 22:12:58
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "min_sum_decode.h"
#include "sum.h"

/* Function Definitions */

/*
 * Arguments    : const double x[440]
 * Return Type  : double
 */
double sum(const double x[440])
{
  double y;
  int k;
  y = x[0];
  for (k = 0; k < 439; k++) {
    y += x[k + 1];
  }

  return y;
}

/*
 * File trailer for sum.c
 *
 * [EOF]
 */
