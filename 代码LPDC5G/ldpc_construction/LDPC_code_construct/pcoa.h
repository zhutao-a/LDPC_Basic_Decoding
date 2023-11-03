#include "common.h"

void cons_qc_random(const int pg[][BASE_COL],int mat[][BASE_COL]) // ���� protograph ���������λֵ
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

void elem_count_cycle4(const int mat[][BASE_COL],int r[][BASE_COL]) // ͳ�ƾ���ÿ��Ԫ�صĻ� 4 ���������浽 r ��
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

typedef pair<int,int> coord; // Ԫ������
typedef vector<coord> coord_list;
typedef pair<int,int> cycle_count; // ��4��6����
typedef pair<cycle_count,coord> ccc; // ��������
typedef set<ccc> ccc_set;

void argsort_elem_cycle_count(const int mat[][BASE_COL],coord_list &r) // ���ݾ����Ļ������������б�������û�л�������Ԫ��
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
			ts.insert(t); // ���ᰴ�ջ�������
		}
	}
	ccc_set::const_reverse_iterator it;
	for (it=ts.rbegin();it!=ts.rend();it++)
	{
		r.push_back(it->second); // �����������
	}
}

void eval_c4n(const int mat[][BASE_COL],int i1,int i2,int r[]) // ���㵱 mat[i1][i2]=v ʱ������(i1,i2)�Ļ�4����Ϊ r[v]
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

int elem_choice(const int mat[][BASE_COL],int i1,int i2) // �������Ԫ��
{
	int elem_old=mat[i1][i2];
	int c4n[BLK_SIZE];
	int c6n[BLK_SIZE];
	eval_c4n(mat,i1,i2,c4n);
	eval_c6n(mat,i1,i2,c6n);
	// �������ٻ���
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
	// �ҵ��������ٻ�����Ԫ���б�
	int_list choices;
	for (int i=0;i<BLK_SIZE;i++)
	{
		if (c4n[i]!=c4n_best || c6n[i]!=c6n_best) continue;
		if (c4n_best==0 && c6n_best==0) return i; // ����޻�ֱ��ѡ��С���Ǹ�
		if (i==elem_old) return elem_old; // ��ǰ���Ѿ����ţ����޸�
		choices.push_back(i);
	}
	int n=choices.size();
	if (n==1) return choices[0];
	int i=rand()%n; // ���ѡ��
	return choices[i];
}

void opt_main(int mat[][BASE_COL],int tmax=0) // �����Ż��������� tmax �� elem_choice��tmaxΪ0��ʾ����
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
			changed=true; // ������һ����Ч�Ż�
			break;
		}
		if (!changed) return; // �Ѿ�����
	}
}
void cons_qc_pcoa(const int pg[][BASE_COL],int mat[][BASE_COL],int tmax=0)
{
	cons_qc_random(pg,mat); // ������ľ�����������Ż������Ҫ��ָ�����������ֱ���� opt_main ����
	//cons_qc_all0(pg,mat); // ��ȫ 0 ������������Ż�
	opt_main(mat,tmax);
}

bool mask_one_main(int mat[][BASE_COL]) // ��ģһ���� 6 ����Ԫ�أ������Ƿ��������Ч��ģ
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
		if (BASE_ROW-i1==BASE_COL-i2) continue; // ����ģ H2 �Խ���
		if (vdegs[i2]<=3) continue; // ���ز��ܵ��� 3
		if (cdegs[i1]<=3) continue; // ���ز��ܵ��� 3
		mat[i1][i2]=-1;
		return true;
	}
	return false;
}

// IO ���
void read_matrix(int mat[][BASE_COL],const char *filename) // ���ļ���ȡ����
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
void save_matrix(const int mat[][BASE_COL],const char *filename) // ��������ļ�
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

