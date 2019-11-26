% Lighting Compensation - reference white
%   https://se.mathworks.com/help/images/ref/illumwhite.html
%   https://se.mathworks.com/help/images/ref/chromadapt.html
%   Reference white = top 5 % of luma (nonlinear gamma corrected luminance)

function [out] = referenceWhite(in)

% undo gamma correction from jpg
in = rgb2lin(in);

% Estimate the scene illumination from the top 5% brightest pixels. 
% Because the input image has been linearized, the illumwhite 
% function returns the illuminant in the linear RGB color space.
topPercent = 5;
illuminant = illumwhite(in,topPercent);

% Correct colors by providing the estimated illuminant to the chromadapt function.
in = chromadapt(in, illuminant, 'ColorSpace', 'linear-rgb');

% To display the white-balanced image correctly on the screen, 
% apply gamma correction by using the lin2rgb function.
out = lin2rgb(in);

figure, imshow(out)
title('White-balanced Image')

end

