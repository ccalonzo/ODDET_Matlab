function [Target] = CoRegisterShift(Shift,Target)
% Image registration based on known displacements listed in Shift.
% Each frame in Target is shifted according to the corresponding row and
% column shifts listed in Shift.  
% If you need to calculate the shifts needed for registration use
% CoRegisterFFT.m instead.
% CAlonzo 18 May 2012

%% Determine stack size and image size
stackSize = size(Target,3);
imageSize = size(Target,1);

%% Apply shift to Target image stacks
for k = 1:stackSize
        
    % shift rows 
    temp = zeros(imageSize);
    if Shift(k,1) >= 0
        temp(1+Shift(k,1):imageSize,:) = Target(1:imageSize-Shift(k,1),:,k);        
    else
        temp(1:imageSize+Shift(k,1),:) = Target(1-Shift(k,1):imageSize,:,k);
    end % if Shift(k,1) > 0
	    
	% shift columns
    Target(:,:,k) = zeros(imageSize);
    if Shift(k,2) >= 0  
        Target(:,1+Shift(k,2):imageSize,k) = temp(:,1:imageSize-Shift(k,2));
    else
        Target(:,1:imageSize+Shift(k,2),k) = temp(:,1-Shift(k,2):imageSize);
    end % if Shift(k,2) > 0
    
end % for k = 1:stackSize

return
