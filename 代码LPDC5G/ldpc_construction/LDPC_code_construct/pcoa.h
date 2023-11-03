#include "common.h"

void cons_qc_random(const int pg[][BASE_COL],int mat[][BASE_COL]) // 根据 protograph 随机构造移位值
{
	for (int i1=0;i1<BASE_ROW;i1++)
	{
		for (int i2=0;i2<BASE_COL;i2++)
		{
			if (pg[i1][i2])
			{
				mat[i1][i2]=rand()%BLK_SIZE;
			}
			else
			{
				mat[i1][i2]=-1;
			}
		}
	}
}
void cons_qc_all0(const int pg[][BASE_COL],int mat[][BASE_COL]) // for test
{
	for (int i1=0;i1<BASE_ROW;i1++)
	{
		for (int i2=0;i2<BASE_COL;i2++)
		{
			if (pg[i1][i2])
			{
				mat[i1][i2]=0;
			}
			else
			{
				mat[i1][i2]=-1;
			}
		}
	}
}

typedef vector<int> int_list;

void elem_count_cycle4(const int mat[][BASE_COL],int r[][BASE_COL]) // 统计经过每个元素的环 4 个数，保存到 r 中
{
	for (int i1=0;i1<BASE_ROW;i1++)
	{
		for (int i2=0;i2<BASE_COL;i2++)
		{
			r[i1][i2]=0;
		}
	}
	for (int i1=0;i1<BASE_ROW-1;i1++)
	{
		for (int i2=0;i2<BASE_COL-1;i2++)
		{
			int e1=mat[i1][i2];
			if (e1<0) continue;
			for (int j1=i1+1;j1<BASE_ROW;j1++)
			{
				int e3=mat[j1][i2];
				if (e3<0) continue;
				for (int j2=i2+1;j2<BASE_COL;j2++)
				{
					int e2=mat[i1][j2];
					if (e2<0) continue;
					int e4=mat[j1][j2];
					if (e4<0) continue;
					if ((e1+e4)%BLK_SIZE == (e2+e3)%BLK_SIZE)
					{
						r[i1][i2]++;
						r[i1][j2]++;
						r[j1][i2]++;
						r[j1][j2]++;
					}
				}
			}
		}
	}
}
void elem_count_cycle6(const int mat[][BASE_COL],int r[][BASE_COL])
{
	for (int i1=0;i1<BASE_ROW;i1++)
	{
		for (int i2=0;i2<BASE_COL;i2++)
		{
			r[i1][i2]=0;
		}
	}
	for (int i1=0;i1<BASE_ROW-1;i1++)
	{
		for (int i2=0;i2<BASE_COL-1;i2++)
		{
			int e1=mat[i1][i2];
			if (e1<0) continue;
			for (int j2=i2+1;j2<BASE_COL;j2++)
			{
				int e2=mat[i1][j2];
				if (e2<0) continue;
				for (int j1=i1+1;j1<BASE_ROW;j1++)
				{
					int e3=mat[j1][j2];
					if (e3<0) continue;
					for (int k1=i1+1;k1<BASE_ROW;k1++)
					{
						if (j1==k1) continue;
						int e6=mat[k1][i2];
						if (e6<0) continue;
						for (int k2=0;k2<BASE_COL;k2++)
						{
							if (i2==k2) continue;
							if (j2==k2) continue;
							int e4=mat[j1][k2];
							if (e4<0) continue;
							int e5=mat[k1][k2];
							if (e5<0) continue;
							if ((e1+e3+e5)%BLK_SIZE == (e2+e4+e6)%BLK_SIZE)
							{
								r[i1][i2]++;
								r[i1][j2]++;
								r[j1][j2]++;
								r[j1][k2]++;
								r[k1][k2]++;
								r[k1][i2]++;
							}
						}
					}
				}
			}
		}
	}
}

typedef pair<int,int> coord; // 元素坐标
typedef vector<coord> coord_list;
typedef pair<int,int> cycle_count; // 环4环6个数
typedef pair<cycle_count,coord> ccc; // 用于排序
typedef set<ccc> ccc_set;

void argsort_elem_cycle_count(const int mat[][BASE_COL],coord_list &r) // 根据经过的环数降序坐标列表，不包括没有环经过的元素
{
	int r4[BASE_ROW][BASE_COL];
	int r6[BASE_ROW][BASE_COL];
	elem_count_cycle4(mat,r4);
	elem_count_cycle6(mat,r6);
	ccc_set ts;
	for (int i1=0;i1<BASE_ROW;i1++)
	{
		for (int i2=0;i2<BASE_COL;i2++)
		{
			int cc4=r4[i1][i2];
			int cc6=r6[i1][i2];
			if (cc4==0 && cc6==0) continue;
			coord cd(i1,i2);
			cycle_count cc(cc4,cc6);
			ccc t(cc,cd);
			ts.insert(t); // 将会按照环数升序
		}
	}
	ccc_set::const_reverse_iterator it;
	for (it=ts.rbegin();it!=ts.rend();it++)
	{
		r.push_back(it->second); // 逆序插入坐标
	}
}

void eval_c4n(const int mat[][BASE_COL],int i1,int i2,int r[]) // 计算当 mat[i1][i2]=v 时，经过(i1,i2)的环4个数为 r[v]
{
	for (int i=0;i<BLK_SIZE;i++)
	{
		r[i]=0;
	}
	for (int j1=0;j1<BASE_ROW;j1++)
	{
		if (i1==j1) continue;
		int e3=mat[j1][i2];
		if (e3<0) continue;
		for (int j2=0;j2<BASE_COL;j2++)
		{
			if (i2==j2) continue;
			int e2=mat[i1][j2];
			if (e2<0) continue;
			int e4=mat[j1][j2];
			if (e4<0) continue;
			int e1=(e2+e3-e4+BLK_SIZE)%BLK_SIZE;
			r[e1]++;
		}
	}
}
void eval_c6n(const int mat[][BASE_COL],int i1,int i2,int r[])
{
	for (int i=0;i<BLK_SIZE;i++)
	{
		r[i]=0;
	}
	for (int j2=0;j2<BASE_COL;j2++)
	{
		if (i2==j2) continue;
		int e2=mat[i1][j2];
		if (e2<0) continue;
		for (int j1=0;j1<BASE_ROW;j1++)
		{
			if (i1==j1) continue;
			int e3=mat[j1][j2];
			if (e3<0) continue;
			for (int k2=0;k2<BASE_COL;k2++)
			{
				if (i2==k2) continue;
				if (j2==k2) continue;
				int e4=mat[j1][k2];
				if (e4<0) continue;
				for (int k1=0;k1<BASE_ROW;k1++)
				{
					if (i1==k1) continue;
					if (j1==k1) continue;
					int e5=mat[k1][k2];
					if (e5<0) continue;
					int e6=mat[k1][i2];
					if (e6<0) continue;
					int e1=(e2+e4+e6-e3-e5+BLK_SIZE*2)%BLK_SIZE;
					r[e1]++;
				}
			}
		}
	}
}

int elem_choice(const int mat[][BASE_COL],int i1,int i2) // 返回最佳元素
{
	int elem_old=mat[i1][i2];
	int c4n[BLK_SIZE];
	int c6n[BLK_SIZE];
	eval_c4n(mat,i1,i2,c4n);
	eval_c6n(mat,i1,i2,c6n);
	// 计算最少环数
	int c4n_best=c4n[0];
	int c6n_best=c6n[0];
	for (int i=1;i<BLK_SIZE;i++)
	{
		int c4n_d=c4n[i];
		int c6n_d=c6n[i];
		if (c4n_d<c4n_best || (c4n_d==c4n_best && c6n_d<c6n_best))
		{
			c4n_best=c4n_d;
			c6n_best=c6n_d;
		}
	}
	// 找到具有最少环数的元素列表
	int_list choices;
	for (int i=0;i<BLK_SIZE;i++)
	{
		if (c4n[i]!=c4n_best || c6n[i]!=c6n_best) continue;
		if (c4n_best==0 && c6n_best==0) return i; // 如果无环直接选最小的那个
		if (i==elem_old) return elem_old; // 当前解已经最优，不修改
		choices.push_back(i);
	}
	int n=choices.size();
	if (n==1) return choices[0];
	int i=rand()%n; // 随机选择
	return choices[i];
}

void opt_main(int mat[][BASE_COL],int tmax=0) // 进行优化，最多调用 tmax 次 elem_choice，tmax为0表示不限
{
	int tcount=0;
	while (1)
	{
		if (tmax>0 && tcount>=tmax) break;
		coord_list cs;
		argsort_elem_cycle_count(mat,cs);
		coord_list::const_iterator it;
		bool changed=false;
		for (it=cs.begin();it!=cs.end();it++)
		{
			if (tmax>0 && tcount>=tmax) break;
			int i1=it->first;
			int i2=it->second;
			int elem_old=mat[i1][i2];
			tcount++;
			int elem=elem_choice(mat,i1,i2);
			if (elem_old==elem) continue;
			mat[i1][i2]=elem;
			changed=true; // 进行了一次有效优化
			break;
		}
		if (!changed) return; // 已经最优
	}
}
void cons_qc_pcoa(const int pg[][BASE_COL],int mat[][BASE_COL],int tmax=0)
{
	cons_qc_random(pg,mat); // 从随机的矩阵出发进行优化。如果要从指定矩阵出发，直接用 opt_main 即可
	//cons_qc_all0(pg,mat); // 从全 0 矩阵出发进行优化
	opt_main(mat,tmax);
}

bool mask_one_main(int mat[][BASE_COL]) // 掩模一个环 6 最多的元素，返回是否产生了有效掩模
{
	int vdegs[BASE_COL];
	int cdegs[BASE_ROW];
	for (int i=0;i<BASE_COL;i++) vdegs[i]=0;
	for (int i=0;i<BASE_ROW;i++) cdegs[i]=0;
	for (int i=0;i<BASE_ROW;i++)
	{
		for (int j=0;j<BASE_COL;j++)
		{
			int elem=mat[i][j];
			if (elem==-1) continue;
			vdegs[j]++;
			cdegs[i]++;
		}
	}
	coord_list cs;
	argsort_elem_cycle_count(mat,cs);
	coord_list::const_iterator it;
	for (it=cs.begin();it!=cs.end();it++)
	{
		int i1=it->first;
		int i2=it->second;
		if (BASE_ROW-i1==BASE_COL-i2) continue; // 不掩模 H2 对角线
		if (vdegs[i2]<=3) continue; // 列重不能低于 3
		if (cdegs[i1]<=3) continue; // 行重不能低于 3
		mat[i1][i2]=-1;
		return true;
	}
	return false;
}

// IO 相关
void read_matrix(int mat[][BASE_COL],const char *filename) // 从文件读取矩阵
{
	FILE *f = fopen(filename, "r");
	for (int i1=0;i1<BASE_ROW;i1++)
	{
		for (int i2=0;i2<BASE_COL;i2++)
		{
			fscanf(f, "%d", mat[i1]+i2);
		}
	}
	fclose(f);
}
void save_matrix(const int mat[][BASE_COL],const char *filename) // 保存矩阵到文件
{
	FILE *f = fopen(filename, "w");
	for (int i1=0;i1<BASE_ROW;i1++)
	{
		for (int i2=0;i2<BASE_COL;i2++)
		{
			if (i2>0) fputc('\t',f);
			fprintf(f, "%d", mat[i1][i2]);
		}
		fputc('\n',f);
	}
	fclose(f);
}

