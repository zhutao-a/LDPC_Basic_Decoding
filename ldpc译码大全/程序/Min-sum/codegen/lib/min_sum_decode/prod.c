/*
 * File: prod.c
 *
 * MATLAB Coder version            : 2.7
 * C/C++ source code generated on  : 29-Jan-2015 22:12:58
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "min_sum_decode.h"
#include "prod.h"

/* Function Definitions */

/*
 * Arguments    : const emxArray_real_T *x
 * Return Type  : double
 */
double prod(const emxArray_real_T *x)
{
  double y;
  int k;
  if (x->size[1] == 0) {
    y = 1.0;
  } else {
    y = x->data[0];
    for (k = 2; k <= x->size[1]; k++) {
      y *= x->data[k - 1];
    }
  }

  return y;
}

/*
 * File trailer for prod.c
 *
 * [EOF]
 */
