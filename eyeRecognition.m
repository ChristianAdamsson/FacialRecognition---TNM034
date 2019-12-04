%function [lefteye, righteye] = eyeRecognition(img)
img = imread('db1_05.jpg');
I = rgb2gray(img);
%% Elins implementation
%img = imread('db1_11.jpg');

I = rgb2gray(img);
%% Elins implementation


resultLogical = skinRecognitionV2(img);

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

%% Run this section for Edge based method: 
%should probably change the way SE works. 

BW1 = edge(I,'sobel');
BW2 = edge(I,'canny');

% probably needs some work with the SE ad erotion etc. 
r = 2;
n = 8;
%this is the things that workds for most pictures. 
SE = strel('diamond',r);
SE2 = strel('disk', 4, n);
SE3 = strel('diamond', 4);
SE4 = strel('disk', 8, n);

%SE = strel('diamond',r);
%SE2 = strel('disk', 2, 4);
%SE3 = strel('diamond', 2);
%SE4 = strel('disk', 2, n);
%nhood = 10;
%SE = strel(nhood)
%J2 = imdilate(BW1,SE);
%J2 = imdilate(J2, SE3);
%J2 = imerode(J2, SE2);

J2 = imdilate(BW1,SE);
J2 = imdilate(J2, SE3);
j2 = imerode(J2, SE4);
J2 = imerode(J2, SE2);
J2 = imerode(J2, SE4);

%% Lisas implementation
imRGB = img;
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


%% cb2

Cb2 = Cb.^2;
Cb2 = imadjust(Cb2,stretchlim(Cb2),[0 1]);

%% cr2
Cr2 = (Cr-1).^2;
Cr2 = imadjust(Cr2,stretchlim(Cr2),[0 1]);


%% CbCr

CbCr = Cb./Cr;

%% Eye Map C

EyeMapC = (Cb2 + Cr2 + CbCr)./3;


%% Eye Map L

se = strel('disk',10); 

dilatedY = imdilate(Y,se);


erodedY = imerode(Y,se);

EyeMapL = dilatedY./(erodedY +1 );


%% Combine final eye map

EyeMap = EyeMapC.*EyeMapL; 


%% försök nmr 2 skapa hybrid
% multiplicerar ihop logiska matriserna. 
EyeMap = (EyeMap > 0.8);

ImageIlluCol = EyeMap & binaryImage & resultLogical;
ImageColEdge = binaryImage & J2 & resultLogical; 
ImageIlluEdge =  EyeMap & J2 & resultLogical;

%figure(1)
%imshow(J2);
%figure(2); 
%imshow(binaryImage);
%figure(3);
%imshow(resultLogical);
%figure(4);
%imshow(EyeMap);

%figure(1)
%imshow(ImageColEdge)
%figure(2)
%imshow(ImageIlluCol)
%figure(3)
%imshow(ImageIlluEdge)

comboimg = ImageIlluCol .* ImageIlluEdge .* ImageColEdge;
%comboimg = ImageIlluEdge;
%comboimg = ImageIlluCol .* ImageIlluEdge;
%comboimg = ImageColEdge;
%figure;
%imshow(comboimg);

%%
%figure(1)
%imshow(comboimg);
[y, x] = size(comboimg);
%y = floor(y);
%x = floor(x);
for y1 = (y/2):y
   for x1 = 1:x
     y1 = floor(y1);
     x1 = floor(x1);
   comboimg(y1, x1) = 0;
   
   end
end
figure(2);
imshow(comboimg)
%comboimg = (comboimg > 0.5);
%imshow(comboimg);
SE5 = strel('disk', 4, 6);
SE7 = strel('square', 10);
%SE6 = strel('disk', 2, 6);
comboimg = imdilate(comboimg, SE7);
%comboimg = imdilate(comboimg, SE6);
%comboimg = imdilate(comboimg, SE6);

figure(4);
imshow(comboimg);

bwlabeled = max(bwlabel(comboimg));
boundbox = regionprops(comboimg,'Area', 'BoundingBox');
%boundbox(1).BoundingBox(1);
cc = bwconncomp(comboimg); 
minsizeofArea = 1;
cc.NumObjects
while (cc.NumObjects > 2)
    
minsizeofArea = minsizeofArea + 1

cc = bwconncomp(comboimg); 
%stats = regionprops(cc, 'Area','Eccentricity'); 
idx = find([boundbox.Area] < minsizeofArea); 
comboimg = ismember(labelmatrix(cc), idx);

boundbox = regionprops(comboimg,'Area', 'BoundingBox');
end

cc = bwconncomp(comboimg);
if (cc.NumObjects < 2)
 lefteye = [123, 247];
 righteye = [267, 250];

else
lefteye = boundbox(1).BoundingBox(1);
righteye = boundbox(2).BoundingBox(1);

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

%figure;
%imshow(img);
%drawing lines for testing
line([lefteye, lefteye + boundbox(1).BoundingBox(3)], [yleft, yleft], 'Color', 'r');
line([righteye, righteye + boundbox(2).BoundingBox(3)], [yright, yright], 'Color', 'r');
lefteye = [lefteye + (boundbox(1).BoundingBox(3)/2), yleft];

righteye = [righteye + (boundbox(2).BoundingBox(3)/2), yright];

end
if(abs(lefteye - righteye) < 20)
   righteye = lefteye + 120; 
   yright = yleft;
end

if(lefteye > righteye)
   temp = lefteye;
   lefteye = righteye;
   righteye = temp;
end
%if(abs(yleft - yright) > 50)
%    yright = 250;
%    yleft = 250;
%end
figure(5);
imshow(comboimg);



