// 基础矩阵大小
const int BASE_ROW = 80;
const int BASE_COL = 368;
// 子矩阵大小
const int BLK_SIZE = 90;

#define BASE_SIZE (BASE_ROW*BASE_COL)
#define H_ROW (BASE_ROW*BLK_SIZE)
#define H_COL (BASE_COL*BLK_SIZE)
#define grith 6
//base_matrix_14.dat
//qc_c6d75Q7YF_28_286_128_5_86_E-14.dat
//qc_c6d75Q7YF_28_286_128_5_86_E-14.dat_4.664336_mask.txt
//base_matrix_14.dat_4.909091_mask.txt
//qc_m6_38_296_5.txt
//qc_m6_38_296_5_5to4.8.txt
//qc_pcoa_38_296_5.txt
//qc_pcoa_28_286_4.txt
//qc_pcoa_38_296_4.txt
//"base_matrix_2.dat_4.216783_mask.txt";
//base_matrix_2.dat_4.041958_mask.txt
//base_matrix_2.dat_4.125874_mask.txt
//qc_m6_38_296_5_final.txt
//qc_pcoa_38_296_5_1.dat
//qc_pcoa_28_286_128_5_0_mask1_E-15.dat
//qc_pcoa_30_288_128_5_3840_E-14.dat
//qc_pcoa_28_286_5_1.dat
const char BASE_MATRIX_FILENAME[] = "qc_pcoa_30_288_128_5_3840_E-14.dat";
const int BLK_LEN = BLK_SIZE ;
const int BASE_ROW_NUM = BASE_ROW;
const int BASE_COL_NUM = BASE_COL;
const int CN_NUM = BASE_ROW_NUM * BLK_LEN;
const int VN_NUM = BASE_COL_NUM * BLK_LEN;
typedef int GF;
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>


#include <set>
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <ctime>
#include <cstdio>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>
#include <string>
#include <sstream>
#include <numeric>
#include <random>
using namespace std;
