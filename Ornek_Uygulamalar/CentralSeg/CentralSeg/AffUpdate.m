function [uM,RM]=AffUpdfate(M,seg,R,T,rate);
% function [uM,RM]=AffUpdfate(M,seg,R,T,rate);
% increase affinities for small segements to encourage large segements.
% 
% Input:
% M: current image affinity matrix;
% seg: current segmentation;
% R: radius;
% T: threshold of the small segment size;
% rate: controls the updating rate (increase as rate increases);
% 
% Hongzhi Wang 02/29/2008


e=unique(seg(:));
L=length(e);
[r,c]=size(seg);
LL=r*c;
CC=histc(seg(:),1:L);
step=exp(-CC/T);

micR=(1:c)-R;micR(1:R)=1;
macR=(1:c)+R;macR((c-R):c)=c;
mirR=(1:r)-R;mirR(1:R)=1;
marR=(1:r)+R;marR((r-R):r)=r;

uM=zeros(size(M));
C=0;
for j=1:c
        for i=1:r
                C=C+1;
                f1=seg(i,j);
                f2=seg(mirR(i):marR(i),micR(j):macR(j));
                ss=(1+step(f1))*(1+step(f2(:)));
                uM(1:length(ss),C)=ss;
        end;
end;
RM=uM.^(-rate);
uM=M.^RM;
