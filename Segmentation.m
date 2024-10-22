    clear all; close all; clc;
    %% Select an image
    [FileName,PathName] = uigetfile('*.jpg','Select an image for Segmentation (Please select an gray scale image)');
    FullPath = strcat(PathName,FileName);
    I = double(imread(FullPath)); 
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
    title('Please Select Foreground and Background','FontSize',30);
    
    %% USER INTERACTIVE
    message = sprintf('Please click 10 point for ForeGround');
    uiwait(msgbox(message));
    disp('Click ForeGround (10 point)');
    [xpf ypf] = ginput(10); 
    ft = abs(int16([xpf ypf]));
    fg = FindCoordinateValue(I,ft);
    hold on
    line(xpf,ypf,'color','b','LineWidth',5);
        
    message = sprintf('Please click 10 point for BackGround');
    uiwait(msgbox(message));
    
    disp('Click BackGround (10 point)');
    [xpb ypb] = ginput(10); 
    bt = abs(int16([xpb ypb]));
    bg = FindCoordinateValue(I,bt);
    hold on
    line(xpb,ypb,'color','g','LineWidth',5);
    
    %% GAUSS FILTER 
    k = graythresh(I);
    % Gauss1 filter for ForeGround
    mf = mean(fg);
    sf = std(fg);
    
    % Gauss filter for BackGround
    mb = mean(bg);
    sb = std(bg);

    fy = (1/sqrt(2*pi*sf))*exp(0.5 * (I-mf).^2/(sf^2));
    by = (1/sqrt(2*pi*sb))*exp(0.5 * (I-mb).^2/(sb^2));
    fg_mask = fy<by;  
    
    %% Plot Fore/BackGround Graphics
    message = sprintf('Click OK to see Foreground and Background Graphic');
    uiwait(msgbox(message));
      
    t=0:255;
    yf = exp(-0.5*(t-mf)/sf);  
    yb = exp(-0.5*(t-mb)/sb);
    
    figure(2)
    subplot(1,2,1);
    set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
    plot(fg,'b','LineWidth',5);
    hold on
    plot(bg,'g','LineWidth',5);
    xlim([1 10]); 
    ylim([1 255]);
    grid on
    title('Foreground and Background','FontSize',30);
    % Add a legend
    legend('Foreground', 'Background');
    
    subplot(1,2,2);    
    plot(t,yf,'b','LineWidth',5);
    hold on
    plot(t,yb,'g','LineWidth',5);
    title('Foreground and Background (Gauss Function)','FontSize',30);
    grid on
    % Add a legend
    legend('Foreground', 'Background');
    
    %% Show the Mask
    message = sprintf('Please click OK to see Mask');
    uiwait(msgbox(message));
    figure(3); 
    imshow(fg_mask,[]);
    set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
    title('The Mask','FontSize',30);
    
    %% Geodesic distance
    message = sprintf('Please click OK to see Geodesic Distance');
    uiwait(msgbox(message));
    figure(4)
    set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
    bw = fg_mask;
   
    D1 = bwdist(bw,'euclidean');
    D2 = bwdist(bw,'cityblock');
    D3 = bwdist(bw,'chessboard');
    D4 = bwdist(bw,'quasi-euclidean');
       
    subplot(2,2,1), subimage(mat2gray(D1)), title('Euclidean')
    hold on, imcontour(D1)
    subplot(2,2,2), subimage(mat2gray(D2)), title('City block')
    hold on, imcontour(D2)
    subplot(2,2,3), subimage(mat2gray(D3)), title('Chessboard')
    hold on, imcontour(D3)
    subplot(2,2,4), subimage(mat2gray(D4)), title('Quasi-Euclidean')
    hold on, imcontour(D4)
   
    %% Show Mask Before Geodesic Distance and After Geodesic Distance
    message = sprintf('Pleasgrae click OK to see Mask Befor/After Geodesic Distance');
    uiwait(msgbox(message));
    figure(5); 
    set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
    subplot(1,2,1); 
    imshow(fg_mask);
    title('The Mask Before Geodesic Distance','FontSize',30);
    
    %mask_mean = mean(D1(:));
    %mask_std = std(D1(:));
    
    subplot(1,2,2);
    yeni_maske = (D1<mean(k*mean(D1)));
    
    imshow(yeni_maske,[]);
    title('The Mask After Geodesic Distance (Euclidean)','FontSize',30);
    
    disp('Program end');
    pause();
    close all;
    