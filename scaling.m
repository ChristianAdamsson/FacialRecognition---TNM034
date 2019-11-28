function [out] = scaling(in, lefteye, righteye)
% author: Hilmurt 2019-11-27

% OBS: coordinates are given as [x,y]

%% read and rotate image so that eyes are horizontally alligned
in = im2double(in);
% rotate image so that eyes are horizontally alligned  
[leftEye, rightEye, rotatedImage] = rotateImage(in, lefteye, righteye);

%figure, imshow(rotatedImage); title('Rotated Image')

%% decide common eye positions and eye distance 
leftEyePos = [80, 160];
commonEyeDist = 140;

% compute true distance between eyes
eyeDist = rightEye(1) - leftEye(1);

% get scalefactor
scaleFactor = commonEyeDist/eyeDist;

%% scale image so that eyes have default distance

scaledImage = imresize(rotatedImage, scaleFactor);

%figure, imshow(scaledImage); title('Scaled Image')

%% translate image so that eyes are at default position
leftEye = leftEye*scaleFactor;
translationDistance = [leftEyePos(1) - leftEye(1), leftEyePos(2) - leftEye(2)];

translatedImage = imtranslate(scaledImage, translationDistance);
out = rgb2gray(translatedImage(1:400, 1:300, :)); 

figure, imshow(out); title('Scaled & translated Image')

end

