function seg=Nseg(im,T)
% function seg=Nseg(im,T)
% Discretize continuous segment labels using threshold T s.t.
% neighboring pixels with absolute label differences no larger 
% than T are grouped together. 
% Hongzhi Wang 02/29/2008

[r,c]=size(im);
L=r*c;
LT=zeros(L,2);
seg=zeros(r,c);
C=0;

for j=1:c
    for i=1:r
        if ~seg(i,j)
            C=C+1;
            LT(1,1)=i;
            LT(1,2)=j;
            seg(i,j)=C;
            l=1;
            while l
                y=LT(l,1);
                x=LT(l,2);
                l=l-1;
                inten=im(y,x);
                
                for i1=max(1,y-1):min(r,y+1)
                    for j1=max(1,x-1):min(c,x+1)
                        if ~seg(i1,j1) && abs(im(i1,j1)-inten)<=T
                            l=l+1;
                            LT(l,1)=i1;
                            LT(l,2)=j1;
                            seg(i1,j1)=C;
                        end;
                    end;
                end;
            end;
            
        end;
    end;
end;
