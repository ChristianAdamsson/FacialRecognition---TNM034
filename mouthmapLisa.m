%%%%%%%%%%%%%%%%%%%%%%%%%%
%
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

figure
subplot(2,3,1)
imshow(Y);
subplot(2,3,2)
imshow(Cb);
subplot(2,3,3)
imshow(Cr);


%% normalize channels
Y = imadjust(Y,stretchlim(Y),[0 1]);
Cb = imadjust(Cb,stretchlim(Cb),[0 1]);
Cr = imadjust(Cr,stretchlim(Cr),[0 1]);

subplot(2,3,4)
imshow(Y);
subplot(2,3,5)
imshow(Cb);
subplot(2,3,6)
imshow(Cr);

%% Create mouth map

Cr2 = Cr.^2;
Cr2 = imadjust(Cr2,stretchlim(Cr2),[0 1]);

CrCb = Cr./Cb;
CrCb = imadjust(CrCb,stretchlim(CrCb),[0 1]);


MouthMap = CrCb - Cr2;
MouthMap = imadjust(MouthMap,stretchlim(MouthMap),[0 1]);

MouthMap = MouthMap.*Cr2;
MouthMap = imadjust(MouthMap,stretchlim(MouthMap),[0 1]);



min = min(min(MouthMap))
max = max(max(MouthMap))


figure
imshow(MouthMap)


