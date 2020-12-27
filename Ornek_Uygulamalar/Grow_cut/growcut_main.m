% growcut.m
clear all;close all;clc;
%-- Load image and seeds
img = imread('brain_color.jpg');
labels=zeros(size(img,1), size(img,2));
imshow(img);
disp('Select foreground');
[x,y]=ginput(10);

for i = 1: 10
    labels(y(i),x(i))=1;
end
disp('Select background');
[x1,y1]=ginput(10);

for i = 1: 10
    labels(y1(i),x1(i))=-1;
end


    
subplot(2,2,1), imshow(img);
subplot(2,2,2), imshow(labels,[]);
subplot(2,2,3), imshow(img);

%-- For segmentation
[labels_out, strengths] = growcut(img,labels);

%-- For Smoothing
labels_out = medfilt2(labels_out,[3,3]);

hold on;
contour(labels_out,[0 0],'g','linewidth',4);
contour(labels_out,[0 0],'k','linewidth',2);
hold off;

subplot(2,2,4), imshow(labels_out);
