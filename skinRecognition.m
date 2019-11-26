
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=560536
% sMin: 0, sMax: 50, hMin: 0.23, hMax: 0.68

function [outLogical] = skinRecognition(inImg)

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

SE = strel('sphere', 3);
SE2_1 = strel('line', 300, 90);
SE2_2 = strel('line', 300, 0);


%img = greyWorldAssumption(img);
%img = referenceWhite(inImg);


hsvImg = rgb2hsv(inImg);
cbcrImg = rgb2ycbcr(inImg);

thresholdLogical = hsvImg(:, :, 1) > hMin & hsvImg(:, :, 1) < hMax & ...
    hsvImg(:,:,2) > sMin & hsvImg(:,:,2) < sMax & ...
    hsvImg(:,:,3) > vMin & hsvImg(:,:,3) < vMax & ...
    cbcrImg(:,:,2) > cbMin & cbcrImg(:,:,2) < cbMax & ...
    cbcrImg(:,:,3) > crMin & cbcrImg(:,:,3) < crMax;

resultHsvImg = thresholdLogical.*hsvImg(:,:,3);

resultLogical = resultHsvImg > 0.6;

resultLogical = imclose(resultLogical, SE2_1);
resultLogical = imclose(resultLogical, SE2_2);
resultLogical = imopen(resultLogical, SE);

outLogical = resultLogical;


%skinImg = img.*uint8(resultLogical);
%imshow(skinImg);

end

