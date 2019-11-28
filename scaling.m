function [out] = scaling(in)
% author: Hilmurt 2019-11-27

% OBS: coordinates are given as [y,x]

%% read and rotate image so that eyes are horizontally alligned
clc; close all;

%in = imread('db1_01.jpg');

%rotate();   % dummy code to select eye positions
[lefteye, righteye] = eyeRecognition(in);
% rotate image so that eyes are horizontally alligned  
[rightEye, leftEye, rotatedImage] = rotateImage(in, righteye, lefteye);
%figure, imshow(rotatedImage); title('Rotated Image')

%% decide common eye positions and eye distance 
leftEyePos = [160,80];
commonEyeDist = 140;

% compute true distance between eyes
eyeDist = rightEye(2) - leftEye(2);

% get scalefactor
scaleFactor = commonEyeDist/eyeDist;


%% scale image so that eyes have default distance

scaledImage = imresize(rotatedImage, scaleFactor);
%figure, imshow(scaledImage); title('Scaled Image')

%% translate image so that eyes are at default position
leftEye = leftEye*scaleFactor;
translationDistance = [leftEyePos(2) - leftEye(2), leftEyePos(1) - leftEye(1)];

translatedImage = imtranslate(scaledImage, translationDistance);
out = translatedImage(1:400, 1:300, :); 
%figure, imshow(translatedImage); title('Translated Image')

end

