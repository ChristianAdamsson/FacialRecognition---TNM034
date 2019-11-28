%function [lefteye, righteye] = eyeRecognition(img)
img = imread('db1_11.jpg');

I = rgb2gray(im2double(img));
%% Elins implementation

S = sum(img,3);
[~,idx] = max(S(:));
[row,col] = ind2sub(size(S),idx); %Hitta ljusaste punkten


%imshow(img);
%viscircles([col, row], 3, 'Color', 'b');

hsvImg = rgb2hsv(img);

%imshow(hsvImg);

thresholdLogical = hsvImg(:, :, 1) > 0 & hsvImg(:, :, 1) < 50 & hsvImg(:,:,2) > 0.23 & hsvImg(:,:,2) < 0.68;

resultHsvImg = thresholdLogical.*hsvImg(:,:,3);

resultLogical = resultHsvImg > 0.6;

%imshow(resultLogical);

skinImg = img.*uint8(resultLogical);

%imshow(skinImg);
resultLogical = skinRecognitionV2(img);

sMin = 0.23;
sMax = 0.68;
hMin = 0;
hMax = 50;

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

%figure;
%imshow(binaryImage);


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
%this is the things that workds for most pictures. 
%SE = strel('diamond',r);
%SE2 = strel('disk', 4, n);
%SE3 = strel('diamond', 4);
%SE4 = strel('disk', 8, n);

SE = strel('diamond',r);
SE2 = strel('disk', 2, 4);
SE3 = strel('diamond', 2);
SE4 = strel('disk', 2, n);


%nhood = 10;
%SE = strel(nhood)
J2 = imdilate(BW1,SE);
J2 = imdilate(J2, SE3);
%J2 = imerode(BW2, SE4);
J2 = imerode(J2, SE2);
%J2 = imerode(J2, SE4);
%figure;
%imshow(J2);

%% Lisas implementation
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

%clc
%close all
%clear all

imRGB = img;
imRGB=im2double(imRGB);
imYCbCr = rgb2ycbcr(imRGB);

%% Isolate Y Cb and Cr
Y = imYCbCr(:,:,1);
Cb = imYCbCr(:,:,2);
Cr= imYCbCr(:,:,3);

%figure
%subplot(2,3,1)
%imshow(Y);
%subplot(2,3,2)
%imshow(Cb);
%subplot(2,3,3)
%imshow(Cr);

%% normalize channels
Y = imadjust(Y,stretchlim(Y),[0 1]);
Cb = imadjust(Cb,stretchlim(Cb),[0 1]);
Cr = imadjust(Cr,stretchlim(Cr),[0 1]);

%subplot(2,3,4)
%imshow(Y);
%subplot(2,3,5)
%imshow(Cb);
%subplot(2,3,6)
%imshow(Cr);

%% cb2

Cb2 = Cb.^2;
Cb2 = imadjust(Cb2,stretchlim(Cb2),[0 1]);

%figure
%subplot(4,2,1)
%imshow(Cb);
%subplot(4,2,2)
%imshow(Cb2);


%% cr2
Cr2 = (Cr-1).^2;
Cr2 = imadjust(Cr2,stretchlim(Cr2),[0 1]);

%subplot(4,2,3)
%imshow(Cr);
%subplot(4,2,4)
%imshow(Cr2);

%% CbCr

CbCr = Cb./Cr;
%subplot(4,2,6)
%imshow(CbCr)

%% Eye Map C

EyeMapC = (Cb2 + Cr2 + CbCr)./3;
%subplot(4,2,8)
%imshow(EyeMapC)

%% Eye Map L

% structuring element
% Different se for dilate and erode?
% Also, should be hemisphere, not disk!
% se = offsetstrel('ball',1,1);
se = strel('disk',10); 

dilatedY = imdilate(Y,se);
%figure
%subplot(3,3,1)
%imshow(dilatedY)

erodedY = imerode(Y,se);
%subplot(3,3,2)
%imshow(erodedY)

EyeMapL = dilatedY./(erodedY +1 );
%subplot(3,3,3)
%imshow(EyeMapL)

%subplot(3,3,6)
%imshow(EyeMapC)

%% Combine final eye map

EyeMap = EyeMapC.*EyeMapL; 
%subplot(3,3,9)
%imshow(EyeMap)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO:
% Fix dilation and erosion of EyeMapL
% Dilate and threshold the final EyeMap
% 
% TODO: Implement the detection
% From FACE DETECTION IN COLOR IMAGES, Rein-Lien Hsu et al.
% "Eye candidates are selected by using 
% (i) pyramid decomposition of the dilated eye map for coarse localizations 
% and (ii) binary morphological closing and iterative thresholding 
% on this dilated map for fine localizations.
% 
% TODO: Implement verification
% "The eyes and mouth candidates are verified by checking 
% (i) luma variations of eye and mouth blobs; 
% (ii) geometry and orientation constraints of eyes-mouth triangles; 
% and (iii) the presence of a face boundary around eyes-mouth triangles." 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% försök nmr 2 skapa hybrid
% ResultLogical uträkning tar nu lång tid
% multiplicerar ihop logiska matriserna. 

ImageIlluCol = EyeMap .* binaryImage .* resultLogical;
ImageColEdge = binaryImage .* J2 .* resultLogical; 
ImageIlluEdge =  EyeMap.* J2 .* resultLogical;

%figure
%imshow(ImageColEdge)
%figure
%imshow(ImageIlluCol)
%figure
%imshow(ImageIlluEdge)

comboimg = ImageIlluCol .* ImageIlluEdge .* ImageColEdge;
%figure;
%imshow(comboimg);

%imhist(comboimg);

%%
comboimg = (comboimg > 0.2);
%imshow(comboimg);
%SE5 = strel('disk', 4, 6);
SE6 = strel('disk', 1, 4);
comboimg = imopen(comboimg, SE6);
%comboimg = imclose(comboimg, SE5);

%imshow(comboimg);

%SE = strel('diamond',r);
%SE2 = strel('disk', 4, n);
%SE3 = strel('diamond', 4);
%SE4 = strel('disk', 8, n);
%nhood = 10;
%SE = strel(nhood)
%J2 = imdilate(BW1,SE);
%J2 = imdilate(J2, SE3);

bwlabeled = max(bwlabel(comboimg));
boundbox = regionprops(comboimg,'Area', 'BoundingBox');
%boundbox(1).BoundingBox(1);
cc = bwconncomp(comboimg); 
minsizeofArea = 2;
while (cc.NumObjects > 2)
    
minsizeofArea = minsizeofArea + 2;

cc = bwconncomp(comboimg); 
%stats = regionprops(cc, 'Area','Eccentricity'); 
idx = find([boundbox.Area] > minsizeofArea); 
comboimg = ismember(labelmatrix(cc), idx);

%figure;
%imshow(BW2)
boundbox = regionprops(comboimg,'Area', 'BoundingBox');
end

cc = bwconncomp(comboimg);
if (cc.NumObjects < 2)
 lefteye = [123,247];
 righteye = [267, 250];

else
lefteye = boundbox(1).BoundingBox(1);
righteye = boundbox(2).BoundingBox(1);
if(lefteye > righteye)
   temp = lefteye;
   lefteye = righteye;
   righteye = temp;
end

leftline = (lefteye: lefteye + boundbox(1).BoundingBox(3));
rightline = (righteye: righteye + boundbox(2).BoundingBox(3));
%plot(leftline);
%%
% what we get out of regionpropsfunction.boundingbox.
%[left, top, width, height
%left = floor(boundbox(1).BoundingBox(1))
%top = floor(boundbox(1).BoundingBox(2))
%width = boundbox(1).BoundingBox(3)
%height = boundbox(1).BoundingBox(4)

yleft = boundbox(1).BoundingBox(2) + (boundbox(1).BoundingBox(4)/2);
yright = boundbox(2).BoundingBox(2) + (boundbox(2).BoundingBox(4)/2);

figure;
imshow(img);

if(abs(lefteye - righteye) < 20)
   righteye = lefteye + 120; 
   yright = yleft;
end
%drawing lines for testing
line([lefteye, lefteye + boundbox(1).BoundingBox(3)], [yleft, yleft], 'Color', 'r');
line([righteye, righteye + boundbox(2).BoundingBox(3)], [yright, yright], 'Color', 'r');

lefteye = [lefteye + (boundbox(1).BoundingBox(3)/2), yleft];


righteye = [righteye + (boundbox(2).BoundingBox(3)/2), yright];
end


