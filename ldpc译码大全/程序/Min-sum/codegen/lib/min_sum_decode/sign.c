/*
 * File: sign.c
 *
 * MATLAB Coder version            : 2.7
 * C/C++ source code generated on  : 29-Jan-2015 22:12:58
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "min_sum_decode.h"
#include "sign.h"

/* Function Definitions */

/*
 * Arguments    : emxArray_real_T *x
 * Return Type  : void
 */
void b_sign(emxArray_real_T *x)
{
  int i0;
  int k;
  double b_x;
  i0 = x->size[1];
  for (k = 0; k < i0; k++) {
    if (x->data[k] < 0.0) {
      b_x = -1.0;
    } else if (x->data[k] > 0.0) {
      b_x = 1.0;
    } else if (x->data[k] == 0.0) {
      b_x = 0.0;
    } else {
      b_x = x->data[k];
    }

    x->data[k] = b_x;
  }
}

/*
 * Arguments    : double *x
 * Return Type  : void
 */
void c_sign(double *x)
{
  if (*x < 0.0) {
    *x = -1.0;
  } else if (*x > 0.0) {
    *x = 1.0;
  } else {
    if (*x == 0.0) {
      *x = 0.0;
    }
  }
}

/*
 * File trailer for sign.c
 *
 * [EOF]
 */
