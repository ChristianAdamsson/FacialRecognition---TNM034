%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%            Plan:
% Läser in en RGB bild
% Konverterar till double
% Konverterar till YCbCr
%
% Skapar mouth map enligt metod föreslagen i
% FACE DETECTION IN COLOR IMAGES
% Rein-Lien Hsu et al.
%
% 
% "high Cr values are found in the mouth areas"
% 
% "the chrominance component Cr is greater than Cb near the mouth areas.
%  We further notice that the mouth has a relatively lower response 
%  in the Cr/Cb feature but a high response in Cr2.  
%  Therefore, the difference between Cr2 and Cr/Cb 
%  can emphasize the mouth regions." 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc


imRGB = imread('image_0009.jpg');
imRGB=im2double(imRGB);
imYCbCr = rgb2ycbcr(imRGB);

%% Isolate Y Cb and Cr
Y = imYCbCr(:,:,1);
Cb = imYCbCr(:,:,2);
Cr= imYCbCr(:,:,3);

%% normalize channels
Y = imadjust(Y,stretchlim(Y),[0 1]);
Cb = imadjust(Cb,stretchlim(Cb),[0 1]);
Cr = imadjust(Cr,stretchlim(Cr),[0 1]);

%% Create mouth map
% U can use center of gravity to determine mouth (or eye) region!

Cr2 = Cr.^2;
% Cr2 = imadjust(Cr2,stretchlim(Cr2),[0 1]);


% The Cr component is greater than Cb near the mouth areas.
CrCb = Cr./Cb;
% CrCb = imadjust(CrCb,stretchlim(CrCb),[0 1]);

% https://ieeexplore.ieee.org/document/6317473

% n should be: the ratio between the average Cr2 and CrCb
n = 0.95*Cr2./CrCb;
% n = imadjust(n,stretchlim(n),[0 1]);


% Image should have high response in Cr2 and lower in CrCb but this is
% opposite????

% From lecture slides
% MouthMap =  CrCb - Cr2;
% MouthMap = imadjust(MouthMap,stretchlim(MouthMap),[0 1]);
% MouthMap = MouthMap.*Cr2;
% MouthMap = imadjust(MouthMap,stretchlim(MouthMap),[0 1]);

MouthMap = Cr2.*(Cr2 - n.*CrCb);
MouthMap = imadjust(MouthMap,stretchlim(MouthMap),[0 1]);




min = min(min(MouthMap))
max = max(max(MouthMap))


figure
imshow(MouthMap)


