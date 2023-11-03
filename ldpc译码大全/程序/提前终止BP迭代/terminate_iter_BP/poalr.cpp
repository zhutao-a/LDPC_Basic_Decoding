#include "polar.h"
#define MAX 1e20
polar::polar(UINT iN,UINT iM,UINT im,UINT *fro,UINT *froB)
{
	this->N=iN;
	this->M=iM;
	this->K=N-M;
	this->m=im;
	this->R=double(K)/N;
	alloc();
	//initial frozen bits position and frozen bits valve
	for(UINT i=0;i<M;++i)
	{
		froPos[i]=fro[i];
		froValue[i]=froB[i];
	}
	//initial information bits position(inforPos array)
	int cn=0,cn1=0;
	for(UINT i=0;i<N;++i)
	{
		if(i==froPos[cn])
		{
			++cn;
			continue;
		}
		else
		{
			inforPos[cn1]=i;
			++cn1;
		}
	}
	//initial reversal
	for(UINT i=0;i<N;++i)
		reversal[i]=i;
	bitReversal(reversal,N,m);
}
void polar::alloc()
{
	froPos=new UINT [M];
	froValue=new UINT [M];
	inforPos=new UINT [K];
	bitB=new UINT [N];  //译u
	bitE=new UINT [N];  //译x
	u=new UINT [N];
	x=new UINT [N];
	x0=new UINT [N];  //判决bitE=bitB*G是否成立，x0是bitB翻转后的值
	y=new double [N];
	reversal=new UINT [N];
	
	LLRm=new double [N];

	unsigned int count1=2*N-1;
	unsigned int count2=N*m/2;
	E=new double [count1];LLR=new double [count1];
	O=new double [count2];
}
polar::~polar()
{
	free();
}
void polar::free()
{
	delete [] froPos;froPos=NULL;
	delete [] froValue;froValue=NULL;
	delete [] inforPos;inforPos=NULL;
	delete [] bitB;bitB=NULL;
	delete [] bitE;bitE=NULL;
	delete [] u;u=NULL;
	delete [] x;x=NULL;
	delete [] x0;x0=NULL;
	delete [] y;y=NULL;
	delete [] reversal;reversal=NULL;
	delete [] LLR;LLR=NULL;
	delete [] LLRm;LLRm=NULL;
	delete [] O;O=NULL;
	delete [] E;E=NULL;
}
void polar::randvec()
{
	for(UINT i=0;i<M;++i)
		u[froPos[i]]=0;
	for(UINT i=0;i<K;++i)
		u[inforPos[i]]=rand()%2;
	/*//unsigned int ind=0;
	//VECDUMP(u,N);
	//CRC
	UINT *infor=new UINT [K];
	for(UINT i=0;i<K-16;++i)
		infor[i]=u[inforPos[i]];
	for(UINT i=K-16;i<K;++i)
		infor[i]=0;
	//VECDUMP(infor,K);
	UINT rdeg;
	UINT *r=new UINT [16];
	crc.CRC(infor,K-1,r,rdeg);
	//VECDUMP(r,16);
	UINT index=0;
	for(UINT j=0;j<16;++j)
	{
		index=inforPos[K-16+j];
		u[index]=r[j];
	}
	delete [] infor;
	delete [] r;
	//VECDUMP(u,N);*/
}
void polar::encode()
{
	bool *isCalc=new bool [N];
	//VECDUMP(reversal,N);
	for(UINT j=0;j<N;++j)   //比特反转
		x[j]=u[reversal[j]];              
	//VECDUMP(x,N);
	for(UINT i=0;i<m;++i)  //encode 
	{
		UINT step=N/(1<<(i+1));
		for(UINT j=0;j<N;++j) 
			isCalc[j]=false;
		for(UINT k=0;k<N;++k)
		{
			if(isCalc[k]) continue;
			UINT Pos=k+step;
			isCalc[k]=true;isCalc[Pos]=true;
			x[k]=x[k]^x[Pos];
		}
	}
	//unsigned int *xx=new unsigned int [N];
	//unsigned int *xxx=new unsigned int [N];
	//inverEncode(x,m,xx);
	//for(unsigned int i=0;i<N;++i) xxx[i]=xx[reversal[i]];
	//VECDUMP(u,N);
	//VECDUMP(x,N);
	delete [] isCalc;
}
//get channel output y and initialize LLR,O
void polar::channelout(double sigma,double Lc)
{
	randVec(x,y,N,sigma);            
	initial(Lc);
}
//get y
void polar::randVec(UINT *x,double *y,UINT N,double sigma)
{
	for(UINT i=0;i<N;++i)
	{
		if(x[i])
			y[i]=1+sigma*gran();
		else
			y[i]=-1+sigma*gran();
	}
}
//initial LLR,O for the SCANdecoder
void polar::initial(double Lc)
{
	for(UINT i=0;i<N;++i)
	{
		bitB[i]=0;
		bitE[i]=0;
	}
	UINT index;
	UINT index0=(m-1)*(1<<(m-1));
	for(UINT i=0;i<N;++i)	
	{
		LLR[i]=-Lc*y[i];                //初始化LLR0
		if(i%2)                         //初始化奇数索引O
		{                 
			index=index0+(i-1)/2;
			if(isfrozen(i))
				O[index]=MAX;
			else
				O[index]=0;
		}
	}
}
//decide frozen bit position
bool polar::isfrozen(UINT i)
{
	for(UINT j=0;j<M;++j)
		if(i==froPos[j])
			return true;
	return false;
}
void polar::call_SCANdecoding(UINT BP_Itermax,UINT &final_iter)
{
	SCANdecoder(BP_Itermax,final_iter);
}
void polar::SCANdecoder(UINT BP_Itermax,UINT &final_iter)
{
	bool flag;
	for(UINT i=0;i<BP_Itermax;++i)
	{
		for(UINT phi=0;phi<N;++phi)
		{
			updatellrmap(m,phi);
			LLRm[phi]=LLR[2*N-2];
			if(phi%2==0)
			{
				if(isfrozen(phi))				
					E[2*N-2]=MAX;				
				else
					E[2*N-2]=0;
			}
			else
				updatebitmap(m,phi);			
		}
		if(i>5)
		{
			for(UINT omiga=0;omiga<N;++omiga)
			{
				if(isfrozen(omiga)==false)
					if(LLRm[omiga]<0)
						bitB[omiga]=1;
			}
			for(UINT omiga=0;omiga<N;++omiga)
				if(isfrozen(omiga)==false)
					if(E[omiga]<0)
						bitE[omiga]=1;
			bool sign=detect_encoding(bitB,bitE);
			if(sign)
			{
				final_iter=i;
				return;
			}
		}
	}	
	final_iter=BP_Itermax;
}
void polar::updatellrmap(UINT lamda,UINT phi)
{
	if(lamda==0)
		return;

	UINT pus=phi/2;
	if(phi%2==0)
		updatellrmap(lamda-1,pus);
	UINT count=1<<(m-lamda);
	UINT index0,index1,index2,index3;
	for(UINT omiga=0;omiga<count;++omiga)
	{
		index0=f(lamda,omiga);
		index1=f(lamda-1,2*omiga);
		index2=f(lamda-1,2*omiga+1);
		if(phi%2==0)
		{
			index3=g(lamda,1+phi,omiga);
			LLR[index0]=TianOperation(LLR[index1],LLR[index2]+O[index3]);
		}
		else
		{
			LLR[index0]=LLR[index2]+TianOperation(LLR[index1],E[index0]);
		}
	}
}
void polar::updatebitmap(UINT lamda,UINT phi)
{
	UINT pus=phi/2;
	UINT count=1<<(m-lamda);
	UINT index0,index1,index2,index3;
	UINT index4,index5;
	if(phi%2==1)
	{
		for(UINT omiga=0;omiga<count;++omiga)
		{
			index0=f(lamda-1,2*omiga);
		    index1=index0+1;
			index4=f(lamda,omiga);
			index5=g(lamda,phi,omiga);
			if(pus%2==0)
			{

				E[index0]=TianOperation(E[index4],O[index5]+LLR[index1]);
				E[index1]=O[index5]+TianOperation(E[index4],LLR[index0]);
			}
			else
			{
				index2=g(lamda-1,pus,2*omiga);
			    index3=index2+1;
				O[index2]=TianOperation(E[index4],O[index5]+LLR[index1]);
				O[index3]=O[index5]+TianOperation(E[index4],LLR[index0]);
			}
		}
		if(pus%2==1)
			updatebitmap(lamda-1,pus);
	}
}
UINT polar::f(UINT lamda,UINT omiga)
{
	return omiga+(1<<(m+1))-(1<<(m+1-lamda));
}
UINT polar::g(UINT lamda,UINT phi,UINT omiga)
{
	return omiga+(phi-1)*(1<<(m-lamda))/2+(lamda-1)*(1<<(m-1));
}
double polar::TianOperation(double a,double b)
{
	double data1=tanh(0.5*a);
	double data2=tanh(0.5*b);
	return 2*arctanh(data1*data2);
}
double polar::arctanh(double x)	
{
	/*if(abs(x-1)<1e-15)
		return 20;
	if(abs(x+1)<1e-15)
		return -20;
	double t; 
	t=0.5*log((1+x)/(1-x));
	return t;*/
	if(x > 0.197428)
	{
		if(x > 0.997606)
		{
			if(x > 0.999918)
			{
				if(x > 0.999991)
				{
					if(x > 0.999997)
					{
						if(x > 0.999998)
							return 7.017199;
						else 
							return (x-0.99997)/0.000004;
					}
					else
					{
						if(x > 0.999995)
							return (x-0.99995)/0.000007;
						else
							return (x-0.9999)/0.000014;
					}
				}
				else
				{
					if(x > 0.999973)
					{
						if(x > 0.999985)
							return (x-0.99986)/0.000021;
						else 
							return (x-0.99973)/0.000043;
					}
					else
					{
						if(x > 0.999953)
							return (x-0.99958)/0.00007;
						else
							return (x-0.9993)/0.00012;
					}
				}
			}
			else
			{
				if(x > 0.999747)
				{
					if(x > 0.999856)
						return (x-0.9989)/0.0002;
					else
						return (x-0.99795)/0.0004;
				}
				else
				{
					if(x > 0.999221)
					{
						if(x > 0.999556)
							return (x-0.9966)/0.0007;
						else
							return (x-0.9945)/0.0012;
					}
					else
					{
						if(x > 0.998635)
							return (x-0.991)/0.0021;
						else
							return (x-0.9852)/0.0037;
					}
				}
			}
		}
		else
		{
			if(x > 0.932737)
			{
				if(x > 0.98714)
				{
					if(x > 0.995803)
						return (x-0.9761)/0.0064;
					else
					{
						if(x > 0.992649)
							return (x-0.9613)/0.0112;
						else
							return (x-0.9377)/0.0196;
					}
				}
				else
				{
					if(x > 0.977555)
						return (x-0.9012)/0.0341;
					else
					{
						if(x > 0.960989)
							return (x-0.8454)/0.059;
						else
							return (x-0.7632)/0.101;
					}
				}
			}
			else
			{
				if(x > 0.7023)
				{
					if(x > 0.885766)
						return (x-0.6481)/0.1695;
					else
					{
						if(x > 0.811323)
							return (x-0.5007)/0.2747;
						else
							return (x-0.3354)/0.4208;
					}
				}
				else
				{
					if(x > 0.558342)
						return (x-0.1824)/0.5963;
					else
					{
						if(x > 0.386666)
							return (x-0.072)/0.7714;
						else
							return (x-0.0153)/0.9106;
					}
				}
			}
		}
	}
	else
	{
		if(x > -0.197428)
			return x/0.9869;
		else
		{
			if(x < -0.997606)
			{
				if(x < -0.999918)
				{
					if(x < -0.999991)
					{
						if(x < -0.999997)
						{
							if(x < -0.999998)
								return -7.017199;
							else 
								return (x+0.99997)/0.000004;
						}
						else
						{
							if(x < -0.999995)
								return (x+0.99995)/0.000007;
							else
								return (x+0.9999)/0.000014;
						}
					}
					else
					{
						if(x < -0.999973)
						{
							if(x < -0.999985)
								return (x+0.99986)/0.000021;
							else 
								return (x+0.99973)/0.000043;
						}
						else
						{
							if(x < -0.999953)
								return (x+0.99958)/0.00007;
							else
								return (x+0.9993)/0.00012;
						}
					}
				}
				else
				{
					if(x < -0.999747)
					{
						if(x < -0.999856)
							return (x+0.9989)/0.0002;
						else
							return (x+0.99795)/0.0004;
					}
					else
					{
						if(x < -0.999221)
						{
							if(x < -0.999556)
								return (x+0.9966)/0.0007;
							else
								return (x+0.9945)/0.0012;
						}
						else
						{
							if(x < -0.998635)
								return (x+0.991)/0.0021;
							else
								return (x+0.9852)/0.0037;
						}
					}
				}
			}
			else
			{
				if(x < -0.932737)
				{
					if(x < -0.98714)
					{
						if(x < -0.995803)
							return (x+0.9761)/0.0064;
						else
						{
							if(x < -0.992649)
								return (x+0.9613)/0.0112;
							else
								return (x+0.9377)/0.0196;
						}
					}
					else
					{
						if(x < -0.977555)
							return (x+0.9012)/0.0341;
						else
						{
							if(x < -0.960989)
								return (x+0.8454)/0.059;
							else
								return (x+0.7632)/0.101;
						}
					}
				}
				else
				{
					if(x < -0.7023)
					{
						if(x < -0.885766)
							return (x+0.6481)/0.1695;
						else
						{
							if(x < -0.811323)
								return (x+0.5007)/0.2747;
							else
								return (x+0.3354)/0.4208;
						}
					}
					else
					{
						if(x < -0.558342)
							return (x+0.1824)/0.5963;
						else
						{
							if(x < -0.386666)
								return (x+0.072)/0.7714;
							else
								return (x+0.0153)/0.9106;
						}
					}
				}
			}
		}
    }
}
double polar::tanh(double x)	
{
	/*if(x<-8) return -1;
	if(x>8) return 1;
	double t;
	t=(exp(x)-exp(-x))/(exp(x)+exp(-x));
	return t;*/
	if(x > 0.200055)
	{
		if(x > 3.363301)
		{
			if(x > 5.049716)
			{
				if(x > 6.173992)
				{
					if(x > 6.73613)
					{
						if(x > 7.017199)
							return 0.999998;
						else 
							return 0.000004*x+0.99997;
					}
					else
					{
						if(x > 6.455061)
							return 0.000007*x+0.99995;
						else
							return 0.000014*x+0.9999;
					}
				}
				else
				{
					if(x > 5.611854)
					{
						if(x > 5.892923)
							return 0.000021*x+0.99986;
						else 
							return 0.000043*x+0.99973;
					}
					else
					{
						if(x > 5.330785)
							return 0.00007*x+0.99958;
						else
							return 0.00012*x+0.9993;
					}
				}
			}
			else
			{
				if(x > 4.487578)
				{
					if(x > 4.768647)
						return 0.0002*x+0.9989;
					else
						return 0.0004*x+0.99795;
				}
				else
				{
					if(x > 3.92544)
					{
						if(x > 4.206509)
							return 0.0007*x+0.9966;
						else
							return 0.0012*x+0.9945;
					}
					else
					{
						if(x > 3.644369)
							return 0.0021*x+0.991;
						else
							return 0.0037*x+0.9852;
					}
				}
			}
		}
		else
		{
			if(x > 1.67904)
			{
				if(x > 2.52017)
				{
					if(x > 3.082237)
						return 0.0064*x+0.9761;
					else
					{
						if(x > 2.801185)
							return 0.0112*x+0.9613;
						else
							return 0.0196*x+0.9377;
					}
				}
				else
				{
					if(x > 2.239267)
						return 0.0341*x+0.9012;
					else
					{
						if(x > 1.958686)
							return 0.059*x+0.8454;
						else
							return 0.101*x+0.7632;
					}
				}
			}
			else
			{
				if(x > 0.871825)
				{
					if(x > 1.401921)
						return 0.1695*x+0.6481;
					else
					{
						if(x > 1.130889)
							return 0.2747*x+0.5007;
						else
							return 0.4208*x+0.3354;
					}
				}
				else
				{
					if(x > 0.630421)
						return 0.5963*x+0.1824;
					else
					{
						if(x > 0.407874)
							return 0.7714*x+0.072;
						else
							return 0.9106*x+0.0153;
					}
				}
			}
		}
	}
	else
	{
		if(x > -0.200055)
			return 0.9869*x;
		else
		{
			if(x < -3.363301)
		    {
				if(x < -5.049716)
				{
					if(x < -6.173992)
					{
						if(x < -6.73613)
						{
							if(x < -7.017199)
								return -0.999998;
							else 
								return 0.000004*x-0.99997;
						}
						else
						{
							if(x < -6.455061)
								return 0.000007*x-0.99995;
							else
								return 0.000014*x-0.9999;
						}
					}
					else
					{
						if(x < -5.611854)
						{
							if(x < -5.892923)
								return 0.000021*x-0.99986;
							else 
								return 0.000043*x-0.99973;
						}
						else
						{
							if(x < -5.330785)
								return 0.00007*x-0.99958;
							else
								return 0.00012*x-0.9993;
						}
					}
				}
				else
				{
					if(x < -4.487578)
					{
						if(x < -4.768647)
							return 0.0002*x-0.9989;
						else
							return 0.0004*x-0.99795;
					}
					else
					{
						if(x < -3.92544)
						{
							if(x < -4.206509)
								return 0.0007*x-0.9966;
							else
								return 0.0012*x-0.9945;
						}
						else
						{
							if(x < -3.644369)
								return 0.0021*x-0.991;
							else
								return 0.0037*x-0.9852;
						}
					}
				}
			}
			else
			{
				if(x < -1.67904)
				{
					if(x < -2.52017)
					{
						if(x < -3.082237)
							return 0.0064*x-0.9761;
						else
						{
							if(x < -2.801185)
								return 0.0112*x-0.9613;
							else
								return 0.0196*x-0.9377;
						}
					}
					else
					{
						if(x < -2.239267)
							return 0.0341*x-0.9012;
						else
						{
							if(x < -1.958686)
								return 0.059*x-0.8454;
							else
								return 0.101*x-0.7632;
						}
					}
				}
				else
				{
					if(x < -0.871825)
					{
						if(x < -1.401921)
							return 0.1695*x-0.6481;
						else
						{
							if(x < -1.130889)
								return 0.2747*x-0.5007;
							else
								return 0.4208*x-0.3354;
						}
					}
					else
					{
						if(x < -0.630421)
							return 0.5963*x-0.1824;
						else
						{
							if(x < -0.407874)
								return 0.7714*x-0.072;
							else
								return 0.9106*x-0.0153;
						}
					}
				}
			}
	    }
    }
}
/*bool polar::crcVector(UINT *bitB)
{
	UINT *infor=new UINT [K];
	for(UINT i=0;i<K;++i)
		infor[i]=bitB[inforPos[i]];
	bool sign=crc.checkCRC(infor,K-1);
	delete [] infor;
	return sign;
}*/
UINT polar::errbitcount()
{
	UINT count=0;
	for(UINT i=0;i<N;++i)
		if(isfrozen(i)||bitB[i]==u[i])
			continue;
		else 
			++count;
	return count;
}
bool polar::detect_encoding(UINT *u0,UINT *E0)
{
	bool *isCalc=new bool [N];
	
	for(UINT j=0;j<N;++j)   //比特反转
		x0[j]=u0[reversal[j]];              
	for(UINT i=0;i<m;++i)  //encode 
	{
		UINT step=N/(1<<(i+1));
		for(UINT j=0;j<N;++j) 
			isCalc[j]=false;
		for(UINT k=0;k<N;++k)
		{
			if(isCalc[k]) continue;
			UINT Pos=k+step;
			isCalc[k]=true;isCalc[Pos]=true;
			x0[k]=x0[k]^x0[Pos];
		}
	}
	delete [] isCalc;
	for(UINT i=0;i<N;++i)
		if(x0[i]!=E0[i])
			return false;
	return true;	
}