
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=560536

function [outLogical] = skinRecognitionV2(inImg)

sizeImg = size(inImg);
maxSize = sizeImg(1)*sizeImg(2);

SE = strel('sphere', 3);
SE2_1 = strel('line', 300, 90);
SE2_2 = strel('line', 300, 0);

hsvImg = rgb2hsv(inImg);
ycbcrImg = rgb2ycbcr(inImg);

arrayImg = reshape(inImg, [],3);
arrayHsv = reshape(hsvImg, [],3);
arrayYcbcr = reshape(ycbcrImg, [],3);

hMin = 0; hMax = 50; sMin = 0.23; sMax = 0.68;
rMin = 95; gMin = 40; bMin = 20; % r > g & r > b & |r-g| > 15 
crMin = 135; cbMin = 85; yMin = 80;

arrayResult = zeros(1, maxSize);

for i = 1:maxSize
    r = arrayImg(i,1); g = arrayImg(i,2); b = arrayImg(i,3);
    h = arrayHsv(i,1); s = arrayHsv(i,2); 
    y = arrayYcbcr(i,1); cb = arrayYcbcr(i,2); cr = arrayYcbcr(i,3);
    crMax = (1.5862*cb)+20;
    crMin2 = (0.3448*cb)+76.2069;
    crMin3 = (-4.5652*cb)+234.5652;
    crMax2 = (-1.15*cb)+301.75;
    crMax3 = (-2.2875*cb)+432.85;
    
    test1 = (h > hMin && h < hMax && s > sMin && s < sMax &&...
            r > rMin && g > gMin && b > bMin && r > g && r > b && abs(r-g) > 15);
    if( test1)
        arrayResult(i) = 1;
    elseif( cr > crMin && cb > cbMin && y > yMin &&...
         cr < crMax && cr > crMin2 && cr > crMin3 && cr < crMax2 && cr < crMax3)
     
        arrayResult(i) = 1;
    else
        arrayResult(i) = 0;
    end
    
end


result = reshape(arrayResult, sizeImg(1), sizeImg(2));

result = imclose(result, SE2_1);
result = imclose(result, SE2_2);
result = imopen(result, SE);

outLogical = result;

end
