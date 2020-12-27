center1 = -10; 
center2 = -center1; 
dist = sqrt(2*(2*center1)^2); 
radius = dist/2 * 1.4; 
lims = [floor(center1-1.2*radius) ceil(center2+1.2*radius)]; 
[x,y] = meshgrid(lims(1):lims(2)); 
bw1 = sqrt((x-center1).^2 + (y-center1).^2) <= radius; 
bw2 = sqrt((x-center2).^2 + (y-center2).^2) <= radius; 
bw = bw1 | bw2; 
figure, 
subplot(1,2,1);
imshow(bw), title('bw')
subplot(1,2,2);
D = bwdist(~bw); 
imshow(D,[]), title('Distance transform of ~bw')