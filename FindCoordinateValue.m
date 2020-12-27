function y = FindCoordinateValue(I,A)
%% To obtain the coordinate values
% I image
% A the coordinate A(x,y)
    [m n] = size(I);
    [x y] = size(A);
    disp(sprintf('Resolution :  %dx%dpx', n, m));
    counter = 1;
    for i=1:x
            y(counter) = I(A(i,2),A(i,1));
            counter=counter+1;
    end
end


