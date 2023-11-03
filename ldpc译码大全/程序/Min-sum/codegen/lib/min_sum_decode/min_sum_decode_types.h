/* 
 * File: min_sum_decode_types.h 
 *  
 * MATLAB Coder version            : 2.7 
 * C/C++ source code generated on  : 29-Jan-2015 22:12:58 
 */

#ifndef __MIN_SUM_DECODE_TYPES_H__
#define __MIN_SUM_DECODE_TYPES_H__

/* Include Files */ 
#include "rtwtypes.h"

/* Type Definitions */ 
#ifndef struct_emxArray__common
#define struct_emxArray__common
struct emxArray__common
{
    void *data;
    int *size;
    int allocatedSize;
    int numDimensions;
    boolean_T canFreeData;
};
#endif /*struct_emxArray__common*/
#ifndef typedef_emxArray__common
#define typedef_emxArray__common
typedef struct emxArray__common emxArray__common;
#endif /*typedef_emxArray__common*/
#ifndef struct_emxArray_int32_T_1x8632
#define struct_emxArray_int32_T_1x8632
struct emxArray_int32_T_1x8632
{
    int data[8632];
    int size[2];
};
#endif /*struct_emxArray_int32_T_1x8632*/
#ifndef typedef_emxArray_int32_T_1x8632
#define typedef_emxArray_int32_T_1x8632
typedef struct emxArray_int32_T_1x8632 emxArray_int32_T_1x8632;
#endif /*typedef_emxArray_int32_T_1x8632*/
#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T
struct emxArray_real_T
{
    double *data;
    int *size;
    int allocatedSize;
    int numDimensions;
    boolean_T canFreeData;
};
#endif /*struct_emxArray_real_T*/
#ifndef typedef_emxArray_real_T
#define typedef_emxArray_real_T
typedef struct emxArray_real_T emxArray_real_T;
#endif /*typedef_emxArray_real_T*/

#endif
/* 
 * File trailer for min_sum_decode_types.h 
 *  
 * [EOF] 
 */
