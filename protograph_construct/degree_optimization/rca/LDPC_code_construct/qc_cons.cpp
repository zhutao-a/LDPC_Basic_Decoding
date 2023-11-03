#include "pcoa.h"

void main_cons(int cnu_count)
{
	int pg[BASE_ROW][BASE_COL];
	char fn[100];
	sprintf(fn,"part_random4.txt");
	read_matrix(pg,fn);
	int mat[BASE_ROW][BASE_COL];
	cons_qc_pcoa(pg,mat,10000);
	sprintf(fn,"qc_pcoa_%d_%d_%d.txt",BASE_ROW,BASE_COL,cnu_count);
	save_matrix(mat,fn);
}

int main()
{
	srand(time(0));
	for (int i=5;i<=5;i++)
	{
		main_cons(i);
	}
	return 0;
}

