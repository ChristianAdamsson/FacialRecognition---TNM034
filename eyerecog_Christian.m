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
%nhood = 10;
%SE = strel(nhood)
J2 = imdilate(BW1,SE);
J2 = imdilate(J2, SE3);
j2 = imerode(J2, SE2);
J2 = imerode(J2, SE3);
J2 = imerode(J2, SE3);
figure;
imshow(J2);




