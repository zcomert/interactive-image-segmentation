function [seg]=CentralSeg(im,R,V,alpha,TN,iter,visualFlag,fn)
% function [seg]=CentralSeg(im,R,V,alpha,TN,iter,visualFlag,fn)
% Computes the central segmentation by gradient descent.
% Example of use:
% [seg]=CentralSeg(im,2,20,0.25,20,6,1,'tmp');
% 
% Input:
% im: input gray image. intensity range:[0,255];
% R: radius for computing the affinity matrix;
% V: stadard deviation for computing Gaussian affinities;
% alpha: typical values 0.25 or 0.5;
% TN: minimal segment size;
% iter: number of iterations
% visualFlag: 1--show the segmentation process;
% fn: output file name
% 
% Output:
% seg: the computed central segmentation
% 
% Hongzhi Wang 02/29/2008
tic;
[r,c]=size(im);
im=double(im);
% initialize segmentat label as intensity
seg=im;

% discretize from continuous segment labels 
S=Nseg(seg,1);

% compute segment boundaries
eseg=edgeSeg(S,0);

% compute Gaussian Affinity matrix
Mim=GaussianAff(im,R,V);

if visualFlag
    h=figure(1);
    subplot(3,2,1)
    imshow(im,[0,255]);
    title('input');
    subplot(3,2,2);
    imshow(reshape(sum(Mim),r,c)/size(Mim,1));    
    title('segment size');
end;

% weight for the extra force 
wEN=0.5;
for i=1:iter
    j=0;
    me=1E99;
    for j=1:501
        % compute derivative and the sum of distance
        [dS,Err]=diffSDis(im,seg,R,alpha,Mim,wEN);        
        if Err(1)<me
            me=Err(1);
            bseg=seg;
        end;

        if mod(j,100)==0
            S=Nseg(seg,1);
            [i,j,length(unique(S)),me,Err',toc]
            tic;
            if visualFlag
                figure(1);
                subplot(3,2,6);
                imshow(dS,[0,10]);
                title('derivative');
                subplot(3,2,3);
                imshow(seg/255)
                title('segment label');
                subplot(3,2,4);
                eseg=edgeSeg(round(seg),0);
                imshow(eseg)
                title('boundary of continuous segment labels');                
                subplot(3,2,5);
                eseg=edgeSeg(S,0);
                imshow(max(im/255*0.6,eseg));
                title('boundary of discretized segment labels (final segmentation)');
                pause(0.1);
            end;
        end;
       seg=seg-dS*0.25;
    end;
    % discretize from continuous segment labels 
    iseg=Nseg(bseg,1);
    % update image affinity matrix to handle textures
    [Mim]=AffUpdate(Mim,iseg,R,TN,2);
    ie=edgeSeg(iseg,0);
    imwrite(ie,[fn,'-iter',num2str(i),'-seg.bmp']);
    save([fn,'-iter',num2str(i),'-seg.txt'],'iseg','-ascii');
    seg=bseg;
end;
seg=iseg;
