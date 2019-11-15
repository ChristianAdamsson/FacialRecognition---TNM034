function [outImg] = skinRecognition(inImg)

crMin = 134;
crMax = 183;
cbMin = 86;
cbMax = 137;
sMin = 0.15;
sMax = 0.75;
hMin = 0;
hMax = 0.873;
vMin = 0.35;
vMax = 1;

SE = strel('sphere', 2);
SE2 = strel('sphere', 30);

img = inImg;

%img = greyWorldAssumption(img);
img = referenceWhite(img);


hsvImg = rgb2hsv(img);
cbcrImg = rgb2ycbcr(img);

thresholdLogical = hsvImg(:, :, 1) > hMin & hsvImg(:, :, 1) < hMax & ...
    hsvImg(:,:,2) > sMin & hsvImg(:,:,2) < sMax & ...
    hsvImg(:,:,3) > vMin & hsvImg(:,:,3) < vMax & ...
    cbcrImg(:,:,2) > cbMin & cbcrImg(:,:,2) < cbMax & ...
    cbcrImg(:,:,3) > crMin & cbcrImg(:,:,3) < crMax;

resultHsvImg = thresholdLogical.*hsvImg(:,:,3);

resultLogical = resultHsvImg > 0.6;


resultLogical = imclose(resultLogical, SE2);
resultLogical = imopen(resultLogical, SE);

skinImg = img.*uint8(resultLogical);

outImg = resultLogical;

%imshow(skinImg);
end

