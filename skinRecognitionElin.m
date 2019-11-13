clear
clc 
close

% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=560536

img = imread('image_0009.jpg');


S = sum(img,3);
[~,idx] = max(S(:));
[row,col] = ind2sub(size(S),idx); %Hitta ljusaste punkten


imshow(img);
viscircles([col, row], 3, 'Color', 'b');

hsvImg = rgb2hsv(img);

imshow(hsvImg);

thresholdLogical = hsvImg(:, :, 1) > 0 & hsvImg(:, :, 1) < 50 & hsvImg(:,:,2) > 0.23 & hsvImg(:,:,2) < 0.68;

resultHsvImg = thresholdLogical.*hsvImg(:,:,3);

resultLogical = resultHsvImg > 0.6;

imshow(resultLogical);

skinImg = img.*uint8(resultLogical);

imshow(skinImg);

sMin = 0.23;
sMax = 0.68;
hMin = 0;
hMax = 50;

