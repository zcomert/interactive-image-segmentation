function M=GaussianAff(im,R,V)
% function M=GaussianAff(im,R,V)
% Compute affinity matrix using Gaussian and intensity.
% Input:
% im: input gray image. value range:[0,255];
% R: radius
% V: Gaussian standard deviation.
% 
% Output:
% M: the affinity matrix;
% 
% Hongzhi Wang 02/29/2008

im=double(im);
[r,c]=size(im);
L=r*c;
tl=min((R+1),r)*min(c,(R+1));
M=zeros(tl,L);
mic=(1:c)-R;mic(1:R)=1;
mac=(1:c)+R;mac((c-R):c)=c;
mir=(1:r)-R;mir(1:R)=1;
mar=(1:r)+R;mar((r-R):r)=r;
C=0;

wc=exp(-(0:300).^2*0.5/V^2)';
for j=1:c
    for i=1:r
        C=C+1;    
        tim=im(mir(i):mar(i),mic(j):mac(j));
        t=wc(round(abs(im(i,j)-tim(:)))+1);
        M(1:length(t),C)=t; 
    end;
end;



