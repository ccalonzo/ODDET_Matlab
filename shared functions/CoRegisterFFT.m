function [Target,Shift] = CoRegisterFFT(Reference,Target)
% Image registration using FFT-based cross-correlation.
% Each frame in Target is shifted to match with corresponding frame in Reference.
% Target and Reference should have square frames, but otherwise image size and
% stack height are arbitrary.
% Array of row and column shifts for each frame is optionally returned as Shift.
% calls on max2.m
% CAlonzo 21 May 2012
%
% 12Jun2012 CAlonzo
% This function works best when imageSize is a power of 2, e.g. 512.  Pad
% your images with zeros to acheive this before applying CoRegisterFFT.
% There are no restrictions on stack height.
%
% 17Oct2012 CAlonzo
% Incorrect image registration for stacks, but works for single slices. 
% Fixed by moving FFT inside the for loop.
% To do: crop FFT to nearest power of 2, but apply translation to full
% image.


%% Determine stack size and image size
imageSize = size(Reference,1);
stackSize = size(Reference,3);
Shift = zeros(stackSize,2);

%% Find the nearest power of 2 and work with that subset
%p = round(log2(imageSize);

%% Find the amount to shift in each slice of the image stack
%[Q Shift] = max2(fftshift(real(ifft2(fft2(Reference).*conj(fft2(Target)))))); %conj(fft2(Target)) is the same as fft2(rot90(Target,2))
%Shift = (shiftdim(Shift))';
%Shift = Shift - (imageSize/2 + 1);  %Shift = Shift - (imageSize/2); if using fft2(rot90(Target,2)).
%	Shift(:,1) --> row shifts
%	Shift(:,2) --> column shifts

%% Apply shift to Target image stacks
for k = 1:stackSize

    [Q Shift(k,:)] = max2(fftshift(real(ifft2(fft2(Reference(:,:,k)).*conj(fft2(Target(:,:,k))))))); %conj(fft2(Target)) is the same as fft2(rot90(Target,2))
    Shift(k,:) = Shift(k,:) - (imageSize/2 + 1);  %Shift = Shift - (imageSize/2); if using fft2(rot90(Target,2)).
        
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
