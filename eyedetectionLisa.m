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
% Metoden beskriven här verkar det som:
% https://books.google.se/books?id=CswUcAl5Rp4C&pg=PA75&lpg=PA75&dq=pyramid+decomposition+eye+detection&source=bl&ots=OUihFCCayN&sig=ACfU3U3ky6CTygZCyGI6CRXMihjyI0Zqmg&hl=sv&sa=X&ved=2ahUKEwjz3_PFgOzlAhVyxaYKHVX2BtgQ6AEwBnoECBEQBA#v=onepage&q=pyramid%20decomposition%20eye%20detection&f=false
%
% "Note that the eye and mouth maps are computed within the entire areas of
% the face candidate, which is bounded by a rectangle"
%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
close all
clear all

imRGB = imread('db1_10.jpg');
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
Y = normalizeChannel(Y);
Cb = normalizeChannel(Cb);
Cr = normalizeChannel(Cr);

subplot(2,3,4)
imshow(Y);
subplot(2,3,5)
imshow(Cb);
subplot(2,3,6)
imshow(Cr);

%% cb2
% HMM: Ska man normalisera efter varje operation eller förstör det 
% när man räknar skillnader etc sedan? 
Cb2 = Cb.^2;
Cb2 = normalizeChannel(Cb2);

figure
subplot(4,2,1)
imshow(Cb);
subplot(4,2,2)
imshow(Cb2);


%% cr2
Cr2 = (Cr-1).^2;
Cr2 = normalizeChannel(Cr2);


subplot(4,2,3)
imshow(Cr);
subplot(4,2,4)
imshow(Cr2);

%% CbCr
% Since it has infinitely large values use imadjust instead of
% normalizeChannel
CbCr = Cb./Cr;
CbCr = imadjust(CbCr,stretchlim(CbCr),[0 1]);

subplot(4,2,6)
imshow(CbCr)

%% Eye Map C

EyeMapC = (Cb2 + Cr2 + CbCr)./3;
EyeMapC = normalizeChannel(EyeMapC);
subplot(4,2,8)
imshow(EyeMapC)

%% Eye Map L

% structuring element
% Different se for dilate and erode?
% Also, should be hemisphere, not disk!
% se = offsetstrel('ball',2,2);

% Larger structural element gives bigger blobs in the end, 
% which might make it harder to determine eyes since the eye shape
% gets less defined (for example not eye shaped, but circle shaped)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO:
% Find good values for the structural elements
% Is there an advantage when using different se for dilation and erosion?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Should be hemisphere
se = strel('disk',5);

dilatedY = imdilate(Y,se);
figure
subplot(3,3,1)
imshow(dilatedY)

erodedY = imerode(Y,se);
subplot(3,3,2)
imshow(erodedY)


EyeMapL = dilatedY./(erodedY +1 );
normalizeChannel(EyeMapL);
subplot(3,3,3)
imshow(EyeMapL)

subplot(3,3,6)
imshow(EyeMapC)

%% Combine final eye map

EyeMap = EyeMapC.*EyeMapL; 
normalizeChannel(EyeMap);
subplot(3,3,9)
imshow(EyeMap)



% Dilate the EyeMap
se2 = strel('disk',5);
EyeMap = imdilate(EyeMap,se2);

figure
imshow(EyeMap)

% Threshold, creates binary mask
EyeMap = (EyeMap > 0.67);
figure
imshow(EyeMap)

%% Detection

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: Implement the detection
% Like Lab 4 in BoB
% From FACE DETECTION IN COLOR IMAGES, Rein-Lien Hsu et al.
%
% MAYBE I MISUNDERSTOOD DIS
% Maybe this describes how to create a good eye map?
%
% "Eye candidates are selected by using 
% (i) pyramid decomposition of the dilated eye map for coarse localizations 
% and (ii) binary morphological closing and iterative thresholding 
% on this dilated map for fine localizations.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: Implement verification
% "The eyes and mouth candidates are verified by checking 
% (i) luma variations of eye and mouth blobs; 
% (ii) geometry and orientation constraints of eyes-mouth triangles; 
% and (iii) the presence of a face boundary around eyes-mouth triangles." 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

