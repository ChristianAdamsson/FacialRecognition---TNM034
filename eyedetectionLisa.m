%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Läser in en RGB bild
% Konverterar till double
% Konverterar till YCbCr
%
% Skapar EyeMap för chrominance och luminance enligt metod föreslagen i
% FACE DETECTION IN COLOR IMAGES
% Rein-Lien Hsu et al.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
close all
clear all

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

%% cb2

Cb2 = Cb.^2;
Cb2 = imadjust(Cb2,stretchlim(Cb2),[0 1]);

figure
subplot(4,2,1)
imshow(Cb);
subplot(4,2,2)
imshow(Cb2);


%% cr2
Cr2 = (Cr-1).^2;
Cr2 = imadjust(Cr2,stretchlim(Cr2),[0 1]);

subplot(4,2,3)
imshow(Cr);
subplot(4,2,4)
imshow(Cr2);

%% CbCr

CbCr = Cb./Cr;
subplot(4,2,6)
imshow(CbCr)

%% Eye Map C

EyeMapC = (Cb2 + Cr2 + CbCr)./3;
subplot(4,2,8)
imshow(EyeMapC)

%% Eye Map L

% structuring element
% Different se for dilate and erode?
% Also, should be hemisphere, not disk!
% se = offsetstrel('ball',1,1);
se = strel('disk',10); 

dilatedY = imdilate(Y,se);
figure
subplot(3,3,1)
imshow(dilatedY)

erodedY = imerode(Y,se);
subplot(3,3,2)
imshow(erodedY)

EyeMapL = dilatedY./(erodedY +1 );
subplot(3,3,3)
imshow(EyeMapL)

subplot(3,3,6)
imshow(EyeMapC)

%% Combine final eye map

EyeMap = EyeMapC.*EyeMapL; 
subplot(3,3,9)
imshow(EyeMap)





