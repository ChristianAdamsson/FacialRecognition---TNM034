%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Skapar mouth map enligt metod föreslagen i
% FACE DETECTION IN COLOR IMAGES
% Rein-Lien Hsu et al.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc

imRGB = imread('db1_10.jpg');
imRGB=im2double(imRGB);
imYCbCr = rgb2ycbcr(imRGB);

%% Isolate Y Cb and Cr
Y = imYCbCr(:,:,1);
Cb = imYCbCr(:,:,2);
Cr= imYCbCr(:,:,3);

%% normalize channels
Y = normalizeChannel(Y);
Cb = normalizeChannel(Cb);
Cr = normalizeChannel(Cr);

%% Create mouth map
Cr2 = Cr.^2;
Cr2 = normalizeChannel(Cr2);

CrCb = Cr./Cb;
CrCb = imadjust(CrCb,stretchlim(CrCb),[0 1]);

%What is this n
n = 0.95*mean(Cr2(:))/mean(CrCb(:));

MouthMap =   Cr2 - n*CrCb; 
% MouthMap = normalizeChannel(MouthMap); 
MouthMap = MouthMap.*MouthMap; 
% MouthMap = normalizeChannel(MouthMap);
MouthMap = MouthMap.*Cr2;
MouthMap = normalizeChannel(MouthMap);

min = min(min(MouthMap))
max = max(max(MouthMap))




%% Dilate 

se = strel('disk',10);
MouthMap = imdilate(MouthMap,se);

figure
imshow(MouthMap)