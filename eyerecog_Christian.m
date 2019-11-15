im = imread('image_0009.jpg');

%tnm034(im);
%figure
%imshow(im);
I = rgb2gray(im);
figure
imshow(I)

%% Run this section for Color-based method 
[counts,binLocations] = imhist(I);

%%equlized histogram in grayscale
J = histeq(I, 256);

% J < 20, J > 20? Both seem to work, according to the report we might wanna use J > 20?
newim = J < 20;
%dilation(newim);
% and Attempt in detecting the actual eyes
%%needs to define shape that we want to use morphological open on. Dilation
%, erotion. I think this is close to an ellipse. 
r = 1;
n = 4;
SE = strel('disk',r,n);

binaryImage = imopen(newim, SE);

figure;
imshow(binaryImage);


%% https://se.mathworks.com/matlabcentral/fileexchange/25157-image-segmentation-tutorial
% tried this but didn't really work -> needs further improvement/testing. 
%% Run this section for Edge based method: 
%should probably change the way SE works. 

BW1 = edge(I,'sobel');
BW2 = edge(I,'canny');
%figure;
%imshowpair(BW1,BW2,'montage')
%title('Sobel Filter                                   Canny Filter');

% probably needs some work with the SE ad erotion etc. 
r = 2;
n = 8;
SE = strel('diamond',r);
SE2 = strel('disk', 4, n);
SE3 = strel('diamond', 4);
SE4 = strel('disk', 8, n);
%nhood = 10;
%SE = strel(nhood)
J2 = imdilate(BW1,SE);
J2 = imdilate(J2, SE3);
j2 = imerode(J2, SE4);
J2 = imerode(J2, SE2);
J2 = imerode(J2, SE4);
figure;
imshow(J2);

%% f�rs�ker skapa hybrid

for i = size(J2, 2)
    for j = size(J2, 1)
        if J2(j, i) == binaryImage(j, i)
            hybridim (j,i) = J2(j,i);
        else
            hybridim(j,i) = 0
        end
    
    end
end

    imshow(hybridim)



%% Lisas implementation
%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% L�ser in en RGB bild
% Konverterar till double
% Konverterar till YCbCr
%
% Skapar EyeMap f�r chrominance och luminance enligt metod f�reslagen i
% FACE DETECTION IN COLOR IMAGES
% Rein-Lien Hsu et al.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%

%clc
%close all
%clear all

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


%% f�rs�k nmr 2 skapa hybrid
ImageIlluCol = EyeMap .* binaryImage;
ImageColEdge = binaryImage .* J2; 
ImageIlluEdge =  EyeMap.*J2;
figure
imshow(ImageColEdge)
figure
imshow(ImageIlluCol)
figure
imshow(ImageIlluEdge)






