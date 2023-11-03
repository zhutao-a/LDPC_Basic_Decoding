/* 
 * File: _coder_min_sum_decode_api.h 
 *  
 * MATLAB Coder version            : 2.7 
 * C/C++ source code generated on  : 29-Jan-2015 22:12:58 
 */

#ifndef ___CODER_MIN_SUM_DECODE_API_H__
#define ___CODER_MIN_SUM_DECODE_API_H__
/* Include Files */ 
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"

/* Function Declarations */ 
extern void min_sum_decode_initialize(emlrtContext *aContext);
extern void min_sum_decode_terminate(void);
extern void min_sum_decode_atexit(void);
extern void min_sum_decode_api(const mxArray *prhs[3], const mxArray *plhs[2]);
extern void min_sum_decode(boolean_T H[3798080], real_T y[8632], real_T p, real_T MM[8632], real_T *cycle);
extern void min_sum_decode_xil_terminate(void);

#endif
/* 
 * File trailer for _coder_min_sum_decode_api.h 
 *  
 * [EOF] 
 */
