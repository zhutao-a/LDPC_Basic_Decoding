/*
 * File: min_sum_decode_emxutil.h
 *
 * MATLAB Coder version            : 2.7
 * C/C++ source code generated on  : 29-Jan-2015 22:12:58
 */

#ifndef __MIN_SUM_DECODE_EMXUTIL_H__
#define __MIN_SUM_DECODE_EMXUTIL_H__

/* Include Files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "rt_nonfinite.h"
#include "rtwtypes.h"
#include "min_sum_decode_types.h"

/* Function Declarations */
extern void emxEnsureCapacity(emxArray__common *emxArray, int oldNumel, int
  elementSize);
extern void emxFree_real_T(emxArray_real_T **pEmxArray);
extern void emxInit_real_T(emxArray_real_T **pEmxArray, int numDimensions);

#endif

/*
 * File trailer for min_sum_decode_emxutil.h
 *
 * [EOF]
 */
