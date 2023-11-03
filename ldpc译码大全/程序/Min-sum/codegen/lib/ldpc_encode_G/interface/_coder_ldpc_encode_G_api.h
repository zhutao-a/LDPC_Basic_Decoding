/* 
 * File: _coder_ldpc_encode_G_api.h 
 *  
 * MATLAB Coder version            : 2.7 
 * C/C++ source code generated on  : 29-Jan-2015 22:06:04 
 */

#ifndef ___CODER_LDPC_ENCODE_G_API_H__
#define ___CODER_LDPC_ENCODE_G_API_H__
/* Include Files */ 
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"

/* Function Declarations */ 
extern void ldpc_encode_G_initialize(emlrtContext *aContext);
extern void ldpc_encode_G_terminate(void);
extern void ldpc_encode_G_atexit(void);
extern void ldpc_encode_G_api(const mxArray *prhs[3], const mxArray *plhs[1]);
extern void ldpc_encode_G(real_T s[8192], boolean_T P[3604480], real_T rearranged_cols[440], real_T u[8632]);
extern void ldpc_encode_G_xil_terminate(void);

#endif
/* 
 * File trailer for _coder_ldpc_encode_G_api.h 
 *  
 * [EOF] 
 */
