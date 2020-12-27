    clear all; close all; clc;
    %% Select an image
    I = double(imread('images/siyah_kedi.jpg')); 
    %% Preliminary
    [x y z] = size(I);
    if(z>1)
        clear all, close all, clc
        error('Please select a gray scale image...');
    end
    % Show the orginal image
    disp(sprintf('Resolution :  %dx%dpx', y, x));
    figure(1);
    imshow(I,[]);
    set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
    title('Image Segmentation','FontSize',30);
    
    %% USER INTERACTIVE  
    ft = abs(int16([ 191    354
    163    263
    145    179
    142    106
    160    121
    185     94
    207    129
    214    228
    266    271
    262    342]));
    fg = FindCoordinateValue(I,ft);
    hold on
    line(ft(:,1),ft(:,2),'color','b','LineWidth',5);
         
    bt = abs(int16([83    347
     49    230
     43     90
     52     22
    108     14
    169     44
    216     25
    274     76
    309    162
    331    233]));
    bg = FindCoordinateValue(I,bt);
    hold on
    line(bt(:,1),bt(:,2),'color','g','LineWidth',5);
    
    %% GAUSS FILTER 
    % Gauss1 filter for ForeGround
    mf = mean(fg);
    sf = std(fg);
    
    % Gauss filter for BackGround
    mb = mean(bg);
    sb = std(bg);

    fy = (1/sqrt(2*pi*sf))*exp(0.5 * (I-mf).^2/(sf^2));
    by = (1/sqrt(2*pi*sb))*exp(0.5 * (I-mb).^2/(sb^2));
    fg_mask = fy<by;  
    
       
    %% Show the Mask
    figure(2); 
    subplot(1,2,1);
    imshow(fg_mask,[]);
    set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
    title('The Mask','FontSize',30);
    
    %% Geodesic distance
    bw = fg_mask;
    D1 = bwdist(bw,'euclidean');
    %D2 = bwdist(bw,'cityblock');
    %D3 = bwdist(bw,'chessboard');
    %D4 = bwdist(bw,'quasi-euclidean');
       
    subplot(1,2,2),
    subimage(mat2gray(D1)),
    title('Euclidean'),
    hold on,
    imcontour(D1)
    title('The Geodesic Distance','FontSize',30);
    %subplot(2,2,2), subimage(mat2gray(D2)), title('City block')
    %hold on, imcontour(D2)
    %subplot(2,2,3), subimage(mat2gray(D3)), title('Chessboard')
    %hold on, imcontour(D3)
    %subplot(2,2,4), subimage(mat2gray(D4)), title('Quasi-Euclidean')
    %hold on, imcontour(D4)
    
     %% Show Mask Before Geodesic Distance and After Geodesic Distance
    message = sprintf('Pleasgrae click OK to see Mask Befor/After Geodesic Distance');
    uiwait(msgbox(message));
    figure(5); 
    set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
   
    imshow(fg_mask);
    title('The Mask Before Geodesic Distance','FontSize',30);
    
    %mask_mean = mean(D1(:));
    %mask_std = std(D1(:));
    
    
    figure(6),
    g = im2bw(I,graythresh(I));
    gc = ~g;
    D = bwdist(gc);
    L = watershed(-D);
    w = L == 0;
    g2 = g & ~w;      
    imshow(g2,[]);
    
        
    h = fspecial('sobel');
    fd = tofloat(I);
    g = sqrt(imfilter(fd,h,'replicate').^2 + imfilter(fd,h,'replicate').^2);
    L = watershed(g);
    wr = L == 0;
    rm = imregionalmin(g);
    figure(7),
    imshow(rm,[]);
    
    im = imextendedmin(I,2);
    fim = I;
    fim(im)=175;
    Lim = watershed(bwdist(im));
    em = Lim == 0;
    figure(8),
    imshow(Lim,[]);
    
    disp('Program end');
    pause();
    close all;
    