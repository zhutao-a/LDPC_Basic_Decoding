/*
 * File: ldpc_encode_G.c
 *
 * MATLAB Coder version            : 2.7
 * C/C++ source code generated on  : 29-Jan-2015 22:06:04
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "ldpc_encode_G.h"
#include "mod.h"

/* Function Definitions */

/*
 * Arguments    : const double s[8192]
 *                const boolean_T P[3604480]
 *                const double rearranged_cols[440]
 *                double u[8632]
 * Return Type  : void
 */
void ldpc_encode_G(const double s[8192], const boolean_T P[3604480], const
                   double rearranged_cols[440], double u[8632])
{
  double b_P[440];
  int i;
  int i0;
  double c[440];
  double temp;
  for (i = 0; i < 440; i++) {
    b_P[i] = 0.0;
    for (i0 = 0; i0 < 8192; i0++) {
      b_P[i] += (double)P[i + 440 * i0] * s[i0];
    }
  }

  b_mod(b_P, 2.0, c);
  memcpy(&u[0], &c[0], 440U * sizeof(double));
  memcpy(&u[440], &s[0], sizeof(double) << 13);

  /* rarranged_colsÎª1ÐÐrowsÁÐÁã¾ØÕó */
  for (i = 0; i < 440; i++) {
    if (rearranged_cols[439 - i] != 0.0) {
      temp = u[439 - i];
      u[439 - i] = u[(int)rearranged_cols[439 - i] - 1];
      u[(int)rearranged_cols[439 - i] - 1] = temp;
    }
  }
}

/*
 * File trailer for ldpc_encode_G.c
 *
 * [EOF]
 */
