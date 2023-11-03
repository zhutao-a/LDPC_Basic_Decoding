#include "pcoa.h"

void main_mask(int cnu_count)
{
	int mat[BASE_ROW][BASE_COL];
	char fn[100];
	sprintf(fn,"qc_pcoa_%d_%d_%d.txt",BASE_ROW,BASE_COL,cnu_count);
	read_matrix(mat,fn);
	int mcount=ceil((cnu_count-4.85)*BASE_COL);
	for (int i=1;i<=mcount;i++)
	{
		if (!mask_one_main(mat)) break;
		sprintf(fn,"qc_m6_%d_%d_%d_%d.txt",BASE_ROW,BASE_COL,cnu_count,i);
		save_matrix(mat,fn);
	}
}

int main()
{
	srand(time(0));
	main_mask(5);
	return 0;
}

