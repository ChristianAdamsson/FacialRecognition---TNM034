function [eyeNew1, eyeNew2, rotatedImage] = rotateImage(im, eye1, eye2)

%
% Takes in an image with associated eye positions. Outputs the rotated image
% and the new eye positions. 
% 
% im: an image of any size
% eye1: vector with 2 doubles, [eye1_col, eye1_row]. Is the persons right eye.
% eye1: vector with 2 doubles, [eye2_col, eye2_row]. Is the persons left eye.
%
% eye1_col is the position of the first eye expressed in number of columns
% from the picture origin. Can be a decimal number.
% eye1_row is the position of the first eye expressed in number of rows
% from he picture origin. Can be a decimal number.
%


%% Read in the positions and calculate the angle of rotation
eye1_col = eye1(1); 
eye1_row = eye1(2);

eye2_col = eye2(1);
eye2_row = eye2(2);

% Difference in height and width position of the eyes
deltaHeight = eye1_row - eye2_row;
deltaWidth = eye2_col - eye1_col;

angle = asind(deltaHeight/deltaWidth); 


%% Rotate the image
[~, imWidth, ~] = size(im);
rotatedImage = imrotate(im,real(-angle), 'bilinear');


%% Calculate new row/col coordinates of the eyes
segA = eye1_col / cosd(abs(angle));
helpsegB = eye1_col * tand(abs(angle));
helpsegC = eye1_row - helpsegB;
segD = helpsegC * sind(abs(angle));
segE = helpsegC * cosd(abs(angle));
segF = imWidth * sind(abs(angle));

eye1_rowNew = segF + segE;
eye1_colNew = segA + segD;

eyeNew1 = [eye1_colNew, eye1_rowNew];
eyeNew2 = [eye1_colNew + deltaWidth*cosd(abs(angle)), eye1_rowNew];

    