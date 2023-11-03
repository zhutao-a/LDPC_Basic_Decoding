#include "BECconstruct.h"

class polar
{
public:
	polar(UINT iN,UINT iM,UINT im,UINT *fro,UINT *froB);
	~polar();
	void free();
	void alloc();
	void initial(double Lc);       //initial LLR,O,E
public:
	void randvec();       //random information u  
	void encode();        //encode vector u,and get x 
	bool detect_encoding(UINT *u0,UINT *x0);
	void randVec(UINT *x,double *y,UINT N,double sigma);
	void channelout(double sigma,double Lc); //through the channel and get vector y
	void call_SCANdecoding(UINT BP_Itermax,UINT &final_iter);   //调用SCANdecoding algorithm	
private:
	//vector 'u','x','y'
	UINT *u;
	UINT *x,*x0;
	double *y;
	//for bitReversal operation
	unsigned int *reversal;
	//the soft information of the channel output LLR,odd index soft information O,even index soft information E;
	double *LLR,*E,*O;
	//a pointer to the result of decode
	//unsigned int *u_;
private:
	void updatellrmap(UINT lamda,UINT phi);
	void updatebitmap(UINT lamda,UINT phi);
	void SCANdecoder(UINT BP_Itermax,UINT &final_iter);
private:
	UINT f(UINT lamda,UINT omiga);
	UINT g(UINT lamda,UINT phi,UINT omiga);
	double TianOperation(double a,double b);
	double arctanh(double x);
	double tanh(double x);
private:
	bool isfrozen(UINT phi);
	//bool crcVector(UINT *b);
private:
	UINT N,M,K,m;
	double R;
	UINT *froPos;
	UINT *froValue;
	UINT *inforPos;
	UINT *bitB,*bitE;   //译码判决后的u向量的值
	//CRC16 crc;
	double *LLRm;
public:
	UINT errbitcount();

};