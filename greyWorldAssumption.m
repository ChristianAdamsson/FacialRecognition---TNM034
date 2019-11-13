% Lighting compensation - grey world assumption
%   - to normalize colour appearance 
%   - average of world is assumed to be grey [127.5]
%   - scale image so that average value is 127.5
function [out] = greyWorldAssumption(in)
clc

out = zeros(size(in));    

% scale each channel separately
for i = 1:3  
    % find average pixel value 
    avg = sum( sum(in(:,:,i)))/numel(in(:,:,i) );  
    % scale input with difference between wanted average (grey) and real average
    out(:,:,i) = in(:,:,i)*(127.5/avg);
end

% transform output to uint8
out = uint8(out); 
figure, imshow(out)
title('Grey World Corrected')

end

