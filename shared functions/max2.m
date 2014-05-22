function [MaxVal,yx] = max2(A)
% max2(A) returns the maximum value in a 2D array.
% (As opposed to max(A) which returns the column-wise maxima.)
%
% [MaxVal,xy] = max2(A) also returns the location of MaxVal as a  
% row vector, yx. yx(1) is the row, yx(2) is the column.
%
% CAlonzo 21May2012

[MaxVal,y] = max(A);
[MaxVal,x] = max(MaxVal);
yx = [y(x),x];

return