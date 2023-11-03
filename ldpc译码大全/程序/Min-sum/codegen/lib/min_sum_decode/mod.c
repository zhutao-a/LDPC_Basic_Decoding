/*
 * File: mod.c
 *
 * MATLAB Coder version            : 2.7
 * C/C++ source code generated on  : 29-Jan-2015 22:12:58
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "min_sum_decode.h"
#include "mod.h"

/* Function Definitions */

/*
 * Arguments    : const double x[440]
 *                double r[440]
 * Return Type  : void
 */
void b_mod(const double x[440], double r[440])
{
  int k;
  for (k = 0; k < 440; k++) {
    r[k] = x[k] - floor(x[k] / 2.0) * 2.0;
  }
}

/*
 * File trailer for mod.c
 *
 * [EOF]
 */
