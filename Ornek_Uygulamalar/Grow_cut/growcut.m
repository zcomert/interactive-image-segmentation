%  [labels strengths] = growcut(img, labels)
%
%  GrowCut algorithm
%  from "GrowCut" - Interactive Multi-Label N-D Image Segmentation
%       By Cellular Autonoma
%  by Vladimir Vezhnevets and Vadim Konouchine
%
%  usage: [labels, strengths] = growcutmex(image, labels)
%         image can be RGB or grayscale
%         labels has values: -1 (bg), 1 (fg), or 0 (undef.)
% 
%         resulting labels will be either 0 (bg) or 1 (fg)
%         resulting strengths will be between 0 and 1
%
%  coded by: Shawn Lankton (www.shawnlankton.com)


function [l s] = growcut(img, labels)
  
  %-- make sure image is in the double format
  img = double(img);

  %-- enforce that foreground and background labels exist
  if(numel(unique(labels))~=3)
    error('labels must be comprised of -1, 0, 1');
  end

  %-- enforce that image and labels are the same size
  si = size(img);
  sl = size(labels);
  if(~all(sl(1:2)==si(1:2)))
  	error('labels and image must be the same size');
  end
  
  %-- automatically compile mex file if not already done
  if(exist('growcutmex','file')~=3)
    mex growcutmex.cpp;
  end
  
  %-- run the c++ growcut algorithm
  [l s] = growcutmex(img,labels);
  
