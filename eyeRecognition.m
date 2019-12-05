function [out, lefteye, righteye] = eyeRecognition(img)

I = rgb2gray(img);

%% Elins Skin recognition
skinMask = skinRecognitionV2(img);

% plocka ut området från skinMask i inbilden

% img = im2double(I) .* skinMask;
% figure; imshow(img); title('skin masked img')


%% Color-based method 
% [counts,binLocations] = imhist(I);    these are not used ?

% equlized histogram in grayscale
J = histeq(I, 256);

% J < 20, J > 20? 
% Both seem to work, according to the report we might wanna use J > 20?
newim = J < 20;

% dilation(newim);

% Attempt in detecting the actual eyes
% needs to define shape that we want to use morphological open on. 
% Dilation, erotion. I think this is close to an ellipse.

r = 1;
n = 4;
SE = strel('disk',r,n);

colorBasedMask = imopen(newim, SE);


%% Edge based method: 

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

J2 = imdilate(BW1,SE);
J2 = imdilate(J2, SE3);
j2 = imerode(J2, SE4);
J2 = imerode(J2, SE2);
edgeBasedMask = imerode(J2, SE4);


%% Lisas implementation
img = im2double(img);
imYCbCr = rgb2ycbcr(img);

% Isolate Y Cb and Cr
Y = imYCbCr(:,:,1);
Cb = imYCbCr(:,:,2);
Cr = imYCbCr(:,:,3);

% normalize channels
Y = normalizeChannel(Y);
Cb = normalizeChannel(Cb);
Cr = normalizeChannel(Cr);

% cb2
Cb2 = Cb.^2;
Cb2 = normalizeChannel(Cb2);

% cr2
Cr2 = (Cr-1).^2;
Cr2 = normalizeChannel(Cr2);

% CbCr
CbCr = Cb./Cr;
CbCr = imadjust(CbCr,stretchlim(CbCr),[0 1]);

% Eye Map Chroma
EyeMapC = (Cb2 + Cr2 + CbCr)./3;
EyeMapC = normalizeChannel(EyeMapC);

% Eye map luminance
se = strel('disk',5);
dilatedY = imdilate(Y,se);
erodedY = imerode(Y,se);

EyeMapL = dilatedY./(erodedY +1 );
normalizeChannel(EyeMapL);

% Combine final logical eye map

EyeMap = EyeMapC.*EyeMapL; 
normalizeChannel(EyeMap);

se2 = strel('disk',5);
EyeMap = imdilate(EyeMap,se2);
EyeMap = (EyeMap > 0.67);  


%% Kombinera de tre metoderna med &operation. 

ImageIlluCol = EyeMap & colorBasedMask .* skinMask;
ImageColEdge = colorBasedMask & edgeBasedMask .* skinMask; 
ImageIlluEdge =  EyeMap & edgeBasedMask.* skinMask;

% figure(); imshow(EyeMap); title('Lisas typ illumination')
% figure(); imshow(colorBasedMask); title('color based mask')
% figure(); imshow(edgeBasedMask); title('edge based mask')

comboImg = ImageIlluCol | ImageIlluEdge | ImageColEdge;
% figure; imshow(comboImg); title('Combination of 3 masks')


%% tips från Daniel => ögonen är alltid i övre halvan av bilden
[y, x] = size(comboImg);

% ta bort nedre halvan av ansiktsmasken 
for y1 = (y/2):y
    for x1 = 1:x
        y1 = floor(y1);
        x1 = floor(x1);
        comboImg(y1, x1) = 0;
   end
end


% create smallest possible box around all holes
boundbox = regionprops(comboImg,'Area', 'BoundingBox', 'Solidity', 'Orientation', 'Extent');
cc = bwconncomp(comboImg); 

ngt = find( [boundbox.Solidity] > 0.5 & abs([boundbox.Orientation]) < 45 ); % 0.8 < [boundbox.Extent] < 4.0
comboImg = ismember(labelmatrix(cc), ngt);

%SE5 = strel('disk', 4, 6);
SE7 = strel('square', 10);
%SE6 = strel('disk', 2, 6);
comboImg = imdilate(comboImg, SE7);

% get all remaining holes 
% cc = bwconncomp(comboImg); 
% minsizeofArea = 1;
% cc.NumObjects

% remove small holes
% while (cc.NumObjects > 2)
%     
% minsizeofArea = minsizeofArea + 1;
% 
% cc = bwconncomp(comboImg); 
% idx = find([boundbox.Area] > minsizeofArea); 
% comboImg = ismember(labelmatrix(cc), idx);
% 
% boundbox = regionprops(comboImg,'Area', 'BoundingBox');
% end



% what we get out of regionpropsfunction.boundingbox.
    % [left, top, width, height]
    % left = floor(boundbox(1).BoundingBox(1))
    % top = floor(boundbox(1).BoundingBox(2))
    % width = boundbox(1).BoundingBox(3)
    % height = boundbox(1).BoundingBox(4)
    
% update bounding box
boundbox = regionprops(comboImg,'BoundingBox');
cc = bwconncomp(comboImg);

if (cc.NumObjects < 2)
    lefteye = [123, 247];
    righteye = [267, 250];
    fprintf('Less than 2 eyes found! \n')
else
      
    % x-values
    lefteye = boundbox(1).BoundingBox(1);
    righteye = boundbox(1).BoundingBox(1) + boundbox(1).BoundingBox(3);

    % y-values
    yleft = boundbox(1).BoundingBox(2);
    yright = boundbox(1).BoundingBox(2);

    % drawing lines for testing
    line([lefteye, lefteye + 20], [yleft, yleft], 'Color', 'r');
    line([righteye, righteye - 20], [yright, yright], 'Color', 'g');
    lefteye = [lefteye + 10, yleft];
    righteye = [righteye - 10, yright];

end

% error något
if( abs(lefteye - righteye) < 20 )
    fprintf('Eyes too close! \n')
end 
if(lefteye > righteye)
   fprintf('Left is right! \n')
end

out = comboImg;


end
