/*
 * File: min_sum_decode.c
 *
 * MATLAB Coder version            : 2.7
 * C/C++ source code generated on  : 29-Jan-2015 22:12:58
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "min_sum_decode.h"
#include "sign.h"
#include "abs.h"
#include "prod.h"
#include "min_sum_decode_emxutil.h"
#include "sum.h"
#include "mod.h"

/* Function Definitions */

/*
 * Arguments    : const boolean_T H[3798080]
 *                const double y[8632]
 *                double p
 *                double MM[8632]
 *                double *cycle
 * Return Type  : void
 */
void min_sum_decode(const boolean_T H[3798080], const double y[8632], double p,
                    double MM[8632], double *cycle)
{
  static double M[3798080];
  double r[8632];
  int ii;
  int jj;
  int n;
  emxArray_real_T *position1;
  emxArray_real_T *Mtemp;
  int32_T exitg1;
  static double E[3798080];
  int idx;
  short ii_data[8632];
  short ii_size[2];
  boolean_T exitg4;
  boolean_T guard1 = false;
  double L;
  double mtmp;
  int ix;
  boolean_T exitg3;
  double d0;
  double b_H[440];
  double c_H[440];
  double dv0[440];
  signed char b_ii_size[2];
  boolean_T exitg2;

  /* 软判决译码 */
  *cycle = 1.0;

  /* 迭代次数计数器 */
  /* 规定最大迭代次数 */
  /* n=H矩阵列数/信息节点数 */
  /* m=H矩阵行数/校验节点数 */
  memset(&M[0], 0, 3798080U * sizeof(double));

  /* r=y; */
  /* 计算对数似然比 */
  for (ii = 0; ii < 8632; ii++) {
    if (y[ii] == 1.0) {
      r[ii] = log(p / (1.0 - p));
    } else {
      r[ii] = log((1.0 - p) / p);
    }

    /* 初始化M矩阵 */
    for (jj = 0; jj < 440; jj++) {
      M[jj + 440 * ii] = r[ii];
    }
  }

  for (n = 0; n < 3798080; n++) {
    M[n] *= (double)H[n];
  }

  /* 迭代 */
  emxInit_real_T(&position1, 2);
  emxInit_real_T(&Mtemp, 2);
  do {
    exitg1 = 0;
    for (jj = 0; jj < 440; jj++) {
      idx = 0;
      for (n = 0; n < 2; n++) {
        ii_size[n] = (short)(1 + 8631 * n);
      }

      ii = 1;
      exitg4 = false;
      while ((!exitg4) && (ii < 8633)) {
        guard1 = false;
        if (M[jj + 440 * (ii - 1)] != 0.0) {
          idx++;
          ii_data[idx - 1] = (short)ii;
          if (idx >= 8632) {
            exitg4 = true;
          } else {
            guard1 = true;
          }
        } else {
          guard1 = true;
        }

        if (guard1) {
          ii++;
        }
      }

      if (1 > idx) {
        n = 0;
      } else {
        n = idx;
      }

      idx = position1->size[0] * position1->size[1];
      position1->size[0] = 1;
      position1->size[1] = n;
      emxEnsureCapacity((emxArray__common *)position1, idx, (int)sizeof(double));
      idx = ii_size[0] * n;
      for (n = 0; n < idx; n++) {
        position1->data[n] = ii_data[n];
      }

      n = Mtemp->size[0] * Mtemp->size[1];
      Mtemp->size[0] = 1;
      emxEnsureCapacity((emxArray__common *)Mtemp, n, (int)sizeof(double));
      idx = position1->size[1];
      n = Mtemp->size[0] * Mtemp->size[1];
      Mtemp->size[1] = idx;
      emxEnsureCapacity((emxArray__common *)Mtemp, n, (int)sizeof(double));
      idx = position1->size[1];
      for (n = 0; n < idx; n++) {
        Mtemp->data[n] = 0.0;
      }

      for (idx = 0; idx < position1->size[1]; idx++) {
        Mtemp->data[idx] = M[jj + 440 * ((int)position1->data[idx] - 1)];
      }

      for (ii = 0; ii < 8632; ii++) {
        if (H[jj + 440 * ii] == 0) {
          E[jj + 440 * ii] = 0.0;
        } else {
          n = position1->size[0] * position1->size[1];
          position1->size[0] = 1;
          position1->size[1] = Mtemp->size[1];
          emxEnsureCapacity((emxArray__common *)position1, n, (int)sizeof(double));
          idx = Mtemp->size[0] * Mtemp->size[1];
          for (n = 0; n < idx; n++) {
            position1->data[n] = Mtemp->data[n];
          }

          b_sign(position1);
          L = prod(position1);
          b_abs(Mtemp, position1);
          idx = 1;
          n = position1->size[1];
          mtmp = position1->data[0];
          if (position1->size[1] > 1) {
            if (rtIsNaN(position1->data[0])) {
              ix = 2;
              exitg3 = false;
              while ((!exitg3) && (ix <= n)) {
                idx = ix;
                if (!rtIsNaN(position1->data[ix - 1])) {
                  mtmp = position1->data[ix - 1];
                  exitg3 = true;
                } else {
                  ix++;
                }
              }
            }

            if (idx < position1->size[1]) {
              while (idx + 1 <= n) {
                if (position1->data[idx] < mtmp) {
                  mtmp = position1->data[idx];
                }

                idx++;
              }
            }
          }

          d0 = M[jj + 440 * ii];
          c_sign(&d0);
          E[jj + 440 * ii] = L / d0 * mtmp;
        }
      }
    }

    /* 更新信息节点,Test */
    for (ii = 0; ii < 8632; ii++) {
      L = r[ii] + sum(*(double (*)[440])&E[440 * ii]);
      if (L <= 0.0) {
        MM[ii] = 1.0;
      } else {
        MM[ii] = 0.0;
      }
    }

    if (*cycle == 20.0) {
      exitg1 = 1;
    } else {
      for (n = 0; n < 440; n++) {
        c_H[n] = 0.0;
        for (idx = 0; idx < 8632; idx++) {
          c_H[n] += (double)H[n + 440 * idx] * MM[idx];
        }

        b_H[n] = c_H[n];
      }

      b_mod(b_H, dv0);
      b_mod(dv0, c_H);
      idx = 0;
      for (n = 0; n < 2; n++) {
        b_ii_size[n] = 1;
      }

      ii = 1;
      exitg2 = false;
      while ((!exitg2) && (ii < 441)) {
        if (c_H[ii - 1] != 0.0) {
          idx = 1;
          exitg2 = true;
        } else {
          ii++;
        }
      }

      if (idx == 0) {
        b_ii_size[1] = 0;
      }

      if (b_ii_size[1] == 0) {
        exitg1 = 1;
      } else {
        (*cycle)++;
        for (ii = 0; ii < 8632; ii++) {
          for (jj = 0; jj < 440; jj++) {
            if (E[jj + 440 * ii] != 0.0) {
              M[jj + 440 * ii] = (r[ii] + sum(*(double (*)[440])&E[440 * ii])) -
                E[jj + 440 * ii];
            } else {
              M[jj + 440 * ii] = 0.0;
            }
          }
        }
      }
    }
  } while (exitg1 == 0);

  emxFree_real_T(&Mtemp);
  emxFree_real_T(&position1);

  /* fprintf('finish at iteration %d\n',I); */
}

/*
 * File trailer for min_sum_decode.c
 *
 * [EOF]
 */
