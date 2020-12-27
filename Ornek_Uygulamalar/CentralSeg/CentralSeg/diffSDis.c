#include "math.h"
#include "mex.h"
/* Hongzhi Wang	09/07/2008  */

void diffSDis_c(const double *im, const double *S, double *dS, double *Err, int r, int c,int R, double alpha, 
		const double *Mim, double wEN)
  {
  	int i,j,i1,j1,C,tL,ind,ind1,d,L,dr,dc;
	double ts1,ts2,ts3,ts4,ts5,t,tS,at,f,sg;
	double ENS=0,ENSI=0,ENSI2=0,ENI=0,MI=0,VI=0,SE=0;
  	double *dEnS;
  	double *dEnSI;
  	double *M1;
  	double *M2;
  	double *SMs;
  	double *SMMs;

	d=(2*R+1);
	if (d>r){dr=r;}else{dr=d;}
	if (d>c){dc=c;}else{dc=d;}
	d=dr*dc;
	L=r*c;
	dEnS=malloc(L*sizeof(double));
	dEnSI=malloc(L*sizeof(double));
	SMs=malloc(L*sizeof(double));
	SMMs=malloc(L*sizeof(double));
	M1=malloc(L*d*sizeof(double));
	M2=malloc(L*d*sizeof(double));
		
	for (j=0;j<r;j++){
		for (i=0;i<c;i++){
			C=i*r+j;
			tL=0; 
			tS=S[i*r+j];
			ts1=0;ts2=0;ts3=0;ts4=0;ts5=0;
			for (i1=i-R;i1<=i+R;i1++){
				for (j1=j-R;j1<=j+R;j1++){
					if ((j1<0) || (j1>=r) || (i1<0) || (i1>=c)){continue;}
					ind=C*d+tL;
					tL++;
					t=tS-S[i1*r+j1];
					at=t;
					if (at<0){at=0-at;}
					if (at<=1){f=1;} else {f=0;}
					ts1=ts1+f;
					ts2=ts2+f*Mim[ind];
					ts3=ts3+Mim[ind];
					if (at>0.25){
						sg=0;
						if (t>0){sg=1;}
						if (t<0){sg=-1;}
						M1[ind]=sg*pow(at,-alpha);
						M2[ind]=M1[ind]*Mim[ind];
						ts4=ts4+M1[ind];
						ts5=ts5+M2[ind];			
					}	
				}
			}
			ENS=ENS-log(ts1/tL);
			ENSI=ENSI-log(ts2/tL);
			ENI=ENI-log(ts3/tL);
			SMs[C]=ts1;
			SMMs[C]=ts2;
			dEnS[C]=ts4/ts1;
			dEnSI[C]=ts5/ts2;
		}


	}
	ENI=ENI/L;
	ENS=ENS/L;
	ENSI=ENSI/L;
	ENSI2=ENSI*ENSI;
	SE=ENS+ENI;
	MI=ENS+ENI-ENSI;
	VI=ENSI-MI;
	Err[0]=VI/ENSI;
	Err[1]=ENS;
	Err[2]=ENI;
	Err[3]=ENSI;
	Err[4]=MI;
	Err[5]=VI;
	for (j=0;j<r;j++){
		for (i=0;i<c;i++){
			C=i*r+j;
			ts4=0;ts5=0;tL=0;
			for (i1=i-R;i1<=i+R;i1++){
				for (j1=j-R;j1<=j+R;j1++){
					if ((j1<0) || (j1>=r) || (i1<0) || (i1>=c)){ continue;}
					ind=C*d+tL;
					tL++;
					ind1=i1*r+j1;
					ts4=ts4+M1[ind]/SMs[ind1];
					ts5=ts5+M2[ind]/SMMs[ind1];
				}
			}
			dEnS[C]=dEnS[C]+ts4;						
			dEnSI[C]=dEnSI[C]+ts5;
			dS[C]=-(dEnS[C]*ENSI-dEnSI[C]*SE)/ENSI2+wEN*dEnSI[C];						
		}
	}	
	free(dEnS);
	free(dEnSI);
	free(M1);
	free(M2);
	free(SMs);
	free(SMMs);
	
	return;
  }


/******************************************************************************
 * mex part
 *****************************************************************************/


void mexFunction(int nargout, mxArray *out[], int nargin, const mxArray	*in[])
  {
  int r=mxGetM(in[0]),c=mxGetN(in[0]),R;
  double alpha,wEN;
  mxArray *D;
  mxArray *Err;
  D = mxCreateDoubleMatrix(r,c,mxREAL);
  Err = mxCreateDoubleMatrix(6,1,mxREAL);

  if ((nargin!=6) || nargout>2) mexErrMsgTxt("Error in diffSDis");
  R=mxGetScalar(in[2]);  
  alpha=mxGetScalar(in[3]);
  wEN=mxGetScalar(in[5]);
  diffSDis_c(mxGetPr(in[0]), mxGetPr(in[1]), mxGetPr(D), mxGetPr(Err), r, c, R, alpha, mxGetPr(in[4]), wEN);
  out[0]=D;
  out[1]=Err;
  }

