/*******************************************************************
 * GrowCut algorithm
 * from "GrowCut" - Interactive Multi-Label N-D Image Segmentation
 *      By Cellular Autonoma
 * by Vladimir Vezhnevets and Vadim Konouchine
 *
 * coded by: Shawn Lankton (www.shawnlankton.com)
 *
 * usage: [labels, strengths] = growcutmex(image, labels)
 *        image must be a double matrix (RGB or grayscale)
 *        labels must be a double matrix with values:
 *         -1 (background), 1 (foreground), or 0 (undefined)
 * 
 *        resulting labels will be either 0 (bg) or 1 (fg)
 *        resulting strengths will be between 0 and 1
 ******************************************************************/

#include <math.h>
#include <matrix.h>
#include <mex.h>   

/* Definitions to keep compatibility with earlier versions of ML */
#ifndef MWSIZE_MAX
typedef int mwSize;
typedef int mwIndex;
typedef int mwSignedIndex;

#if (defined(_LP64) || defined(_WIN64)) && !defined(MX_COMPAT_32)
/* Currently 2^48 based on hardware limitations */
# define MWSIZE_MAX    281474976710655UL
# define MWINDEX_MAX   281474976710655UL
# define MWSINDEX_MAX  281474976710655L
# define MWSINDEX_MIN -281474976710655L
#else
# define MWSIZE_MAX    2147483647UL
# define MWINDEX_MAX   2147483647UL
# define MWSINDEX_MAX  2147483647L
# define MWSINDEX_MIN -2147483647L
#endif
#define MWSIZE_MIN    0UL
#define MWINDEX_MIN   0UL
#endif

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    //declare variables
    mxArray *strens_m, *labels_m, *labelsn_m, *I_m;
    mwSize numdims;
    const mwSize *dims;
    double  *strens, *strensn, *labels, *labelsn, *I;
    int i,j,k,l,m;
    int Nx[] = {-1, 1, 0, 0, -1, -1, 1,  1}; //8-neighbors
    int Ny[] = {0, 0, -1, 1,  1, -1, 1, -1};
    int dimx,dimy,dimxy,colors;
    double C,g;
    int idxq, idxp, idxp1, idxp2, idxq1, idxq2;
    double maxC = 441.673;
    int converged;
    int MAX_ITS = 100; //uncomment below if you want to use this
    int its = 0;
    
    //gets image dimensions
    numdims = mxGetNumberOfDimensions(prhs[0]);
    dims = mxGetDimensions(prhs[0]);

    dimy = (int)dims[0];
    dimx = (int)dims[1];
    dimxy = dimx*dimy;
    if(numdims>2) colors = (int)dims[2];
    else colors = 1;
    
    //sets up pointers
    I_m = mxDuplicateArray(prhs[0]);
    labels_m = mxDuplicateArray(prhs[1]);
    labelsn_m = plhs[0] = mxDuplicateArray(prhs[1]);
    strens_m = plhs[1] = mxCreateDoubleMatrix(dimy,dimx,mxREAL);

    I = mxGetPr(I_m);
    labels = mxGetPr(labels_m);
    labelsn = mxGetPr(labelsn_m);
    strens = mxGetPr(strens_m);
    strensn = (double*)malloc(dimx*dimy*sizeof(double));

    //initilize seeds
    for(i=0;i<dimxy;i++) if(labels[i]!=0) strens[i] = 1;; 

    //start main loop
    converged = 0;
    while(!converged){
        its++;
        converged = 1; //unless we make a change

        //copy prev result
        for(i=0;i<dimxy;i++)
        {
            strensn[i] = strens[i];
            labelsn[i] = labels[i];
        }
        
        //for every pixel p
        for(i=1;i<dimx-1;i++)
        {
            for(j=1;j<dimy-1;j++)
            {
                idxp = j+i*dimy;
                idxp1 = idxp+dimxy; idxp2 = idxp+dimxy*2;

                //for every neighbor q
                for(m=0;m<8;m++)
                {
                    idxq = idxp + Nx[m]*dimy + Ny[m];
                    idxq1 = idxq+dimxy; idxq2 = idxq+dimxy*2;

                    if(labels[idxq] == 0) continue; //wimps don't attack
                    
                    if(colors>1)
                        C = sqrt( (I[idxp ] - I[idxq ])*(I[idxp ] - I[idxq ]) +
                                  (I[idxp1] - I[idxq1])*(I[idxp1] - I[idxq1]) +
                                  (I[idxp2] - I[idxq2])*(I[idxp2] - I[idxq2]) );
                    else
                        C = sqrt((I[idxp ] - I[idxq ])*(I[idxp ] - I[idxq ])); 
                    
                    g = 1-(C/maxC); //attack force
                    
                    if(g*strens[idxq]>strensn[idxp]) //attack succeeds
                    {
                        strens[idxp] = g*strensn[idxq];
                        labelsn[idxp] = labels[idxq];
                        converged = 0; // keep iterating
                    }

                }
                
            }
        }

        //copy prev result
        for(i=0;i<dimxy;i++) labels[i] = labelsn[i];;

        //lets not go crazy...
        //if(its == MAX_ITS) break;
    }

    //condition final result
    for(i=0;i<dimxy;i++) if(labelsn[i]==-1) labelsn[i]=0;;
        
    //mexPrintf("total iterations=%d\n",its);
    free(strensn);
    mxDestroyArray(I_m);
    mxDestroyArray(labels_m);

    return;
}
