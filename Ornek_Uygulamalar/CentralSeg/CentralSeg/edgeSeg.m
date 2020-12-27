function eseg=edgeSeg(seg,t)
% function eseg=edgeSeg(seg,t)
% Compute boundaries, eseg, of a segmentation, seg, with threshold t.
% Hongzhi Wang 02/29/2008

[r,c]=size(seg);
eseg=zeros(r,c);
eseg(1:r-1,:)=abs(seg(2:r,:)-seg(1:r-1,:));
eseg(:,1:c-1)=max(eseg(:,1:c-1),abs(seg(:,2:c)-seg(:,1:c-1)));
eseg(1:r-1,1:c-1)=max(eseg(1:r-1,1:c-1),abs(seg(2:r,2:c)-seg(1:r-1,1:c-1)));
eseg=eseg>t;

