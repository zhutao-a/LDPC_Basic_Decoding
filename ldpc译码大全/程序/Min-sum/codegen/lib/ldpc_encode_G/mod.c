/*
 * File: mod.c
 *
 * MATLAB Coder version            : 2.7
 * C/C++ source code generated on  : 29-Jan-2015 22:06:04
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "ldpc_encode_G.h"
#include "mod.h"

/* Function Declarations */
static double rt_roundd_snf(double u);

/* Function Definitions */

/*
 * Arguments    : double u
 * Return Type  : double
 */
static double rt_roundd_snf(double u)
{
  double y;
  if (fabs(u) < 4.503599627370496E+15) {
    if (u >= 0.5) {
      y = floor(u + 0.5);
    } else if (u > -0.5) {
      y = u * 0.0;
    } else {
      y = ceil(u - 0.5);
    }
  } else {
    y = u;
  }

  return y;
}

/*
 * Arguments    : const double x[440]
 *                double y
 *                double r[440]
 * Return Type  : void
 */
void b_mod(const double x[440], double y, double r[440])
{
  int k;
  double b_r;
  for (k = 0; k < 440; k++) {
    if (y == 0.0) {
      b_r = x[k];
    } else if (y == floor(y)) {
      b_r = x[k] - floor(x[k] / y) * y;
    } else {
      b_r = x[k] / y;
      if (fabs(b_r - rt_roundd_snf(b_r)) <= 2.2204460492503131E-16 * fabs(b_r))
      {
        b_r = 0.0;
      } else {
        b_r = (b_r - floor(b_r)) * y;
      }
    }

    r[k] = b_r;
  }
}

/*
 * File trailer for mod.c
 *
 * [EOF]
 */
