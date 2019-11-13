clc
close all
clear all

imRGB = imread('image_0009.jpg');
imRGB=im2double(imRGB);
% whos imRGB;
imYCbCr = rgb2ycbcr(imRGB);
whos imYCBCR;
% imshow(imYCbCr)

%% Isolate Y Cb and Cr
Y = imYCbCr(:,:,1);
Cb = imYCbCr(:,:,2);
Cr= imYCbCr(:,:,3);

figure
subplot(1,3,1)
imshow(Y);
subplot(1,3,2)
imshow(Cb);
subplot(1,3,3)
imshow(Cr);

% highestPixelValue = max(Cr(:));
% lowestPixelValue = min(Cr(:));


%% normalize channels
Y = imadjust(Y,stretchlim(Y),[0 1]);
Cb = imadjust(Cb,stretchlim(Cb),[0 1]);
Cr = imadjust(Cr,stretchlim(Cr),[0 1]);


figure
subplot(1,3,1)
imshow(Y);
subplot(1,3,2)
imshow(Cb);
subplot(1,3,3)
imshow(Cr);

% %%  convert to 0 255 uint8
% Y = 255*Y;
% Y = uint8(Y);
% 
% Cb = 255*Cb;
% Cb = uint8(Cb);
% 
% Cr = 255*Cr;
% Cr = uint8(Cr);
% 
% % highestPixelValue = max(Y(:));
% % lowestPixelValue = min(Y(:));
% 
% figure
% subplot(1,3,1)
% imshow(Y);
% subplot(1,3,2)
% imshow(Cb);
% subplot(1,3,3)
% imshow(Cr);


%% calculate components of illumination map
% Shall they be [0 1] or [0 255] before square??
% https://books.google.se/books?id=r02WDwAAQBAJ&pg=PA1174&lpg=PA1174&dq=cb+cr+illumination+eye+map&source=bl&ots=2NoIrTyql4&sig=ACfU3U2jFRGC0biFNv-DMJw2u_OkIz7zhQ&hl=sv&sa=X&ved=2ahUKEwjX7_nOrOflAhUNxqYKHYLWCzUQ6AEwEnoECA4QBA#v=onepage&q=cb%20cr%20illumination%20eye%20map&f=false



% Cb2 = Cb.^2;
% % Cb2 = double(Cb2);
% Cb2 = imadjust(Cb2,stretchlim(Cb2),[0 1]);
% Cb2 = 255*Cb2;
% Cb2 = uint8(Cb2);
% 
% figure
% subplot(1,2,1)
% imshow(Cb);
% subplot(1,2,2)
% imshow(Cb2);
% 
% Cr2 = Cr.^2;
% Cr2 = imadjust(Cr2,stretchlim(Cr2),[0 1]);
% Cr2 = 255*Cr2;
% Cr2 = uint8(Cr2);
% 
% figure
% subplot(1,2,1)
% imshow(Cr);
% subplot(1,2,2)
% imshow(Cr2);


%% Temp values for map thing
Cb2 = Cb;
Cr2 = 1-Cr;
CbCr = Cb./Cr;

%% Eye Map C

EyeMapC = (Cb2 + Cr2 + CbCr)/3;
figure
imshow(EyeMapC);


%% Eye Map L

% structuring element
%se = offsetstrel('ball',5,5);
%Yuint = uint8(Y*255);
se1 = strel('line',3,0);
se2 = strel('line',3,90);

dilatedY = imdilate(Y,[se1 se2],'full');
figure
subplot(1,3,1)
imshow(dilatedY)

erodedY = imerode(Y,[se1 se2],'full');
subplot(1,3,2)
imshow(erodedY)

subplot(1,3,3)
EyeMapL = dilatedY./erodedY;
imshow(EyeMapL)





