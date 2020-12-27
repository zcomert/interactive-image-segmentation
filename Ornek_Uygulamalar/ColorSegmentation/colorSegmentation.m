Im = imread('bonibon.jpg');
imshow(Im);
pause();
%% Thresholding the image on each color plane
Im = im2double(Im);
[r c p] = size(Im);
imR = squeeze(Im(:,:,1));
imG = squeeze(Im(:,:,2));
imB = squeeze(Im(:,:,3));
%% Thresholding individual planes
imBinaryR = im2bw(imR,graythresh(imR));
imBinaryG = im2bw(imG,graythresh(imG));
imBinaryB = im2bw(imB,graythresh(imB));
imBinary = imcomplement(imBinaryR&imBinaryG&imBinaryB);
imshow(imBinary);
pause();
%% Morphological Opening
se = strel('disk',7);
imClean = imopen(imBinary,se);
%% Fill holes and clear border
imClean = imfill(imClean,'holes');
imClean = imclearborder(imClean);
imshow(imClean);
pause();

%% Segmented gray-level image
[labels, numLabels] = bwlabel(imClean);
disp(['Number of objects detected : ' num2str(numLabels)]);
%% Initalize matrices
rLabel = zeros(r,c);
gLabel = zeros(r,c);
bLabel = zeros(r,c);

%% Get average color vector for each labeled region
for i=1:numLabels
    rLabel(labels==i) = median(imR(labels==i));
    gLabel(labels==i) = median(imG(labels==i));
    bLabel(labels==i) = median(imB(labels==i));
end
imLabel = cat(3,rLabel,gLabel,bLabel);
imshow(imLabel);
impixelinfo(gcf);
pause();

%% Get desired color to segment
[x y] = ginput(1);
selColor = imLabel(floor(y),floor(x),:);
%% Convert to LAB color space
C = makecform('srgb2lab');
imLAB = applycform(imLabel,C);
imSelLAB = applycform(selColor,C);

%% Extract a* and b* values
imA = imLAB(:,:,2);
imB = imLAB(:,:,3);

imSelA = imSelLAB(1,2); % extract a*
imSelB = imSelLAB(1,3); % extract b*

%% Compute distance from selected color
distThresh = 24;
imMask = zeros(r,c);
imDist = hypot(imA-imSelA, imB-imSelB);
imMask(imDist<distThresh)=1;
[cLabel,cNum] = bwlabel(imMask);
imSeg = repmat(selColor,[r,c,1]).*repmat(imMask,[1,1,3]);
imshow(imSeg);
pause();

%% Plot the color segmented image
figure, subplot(2,1,1); imshow(Im);
title(['Total number of objects detected = ' num2str(numLabels)]);
subplot(2,1,2); imshow(imSeg);
title(['Number of objects selected color = ' num2str(cNum)]);
pause();
close all


