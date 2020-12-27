function [out, revertclass] = tofloat(in)
%TOFLOAT Convert image to floating point
% [OUT, REVERTCLASSj = TOFLOAT(IN) converts the input image IN to
% floating-point. If IN is a double or single image, then OUT
% equals IN. Otherwise, OUT equals IM2SINGLE(IN). REVERTCLASS is
% a function handle that can be used to convert back to the class
% of IN.
identity = @(x) x;
tosingle = @im2single;
table = { 'uint8', tosingle, @im2uint8
'uint16', tosingle, @im2uint16
'int16', tosingle, @im2int16
'logical', tosingle, @logical
'double', identity, identity
'single' , identity , identity};
c = find(strcmp(class(in), table(:, 1)));
if isempty(c)
    error ('Unsupported input image class.');
end
out = table{c, 2}(in);
revertclass = table{c, 3};