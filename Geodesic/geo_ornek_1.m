bw = zeros(5,5); 
bw(2,2) = 1; 
bw(4,4) = 1

figure(1)
subplot(1,2,1);
imshow(bw,[]);
subplot(1,2,2);
[D,IDX] = bwdist(bw);
imshow(D,[]);
