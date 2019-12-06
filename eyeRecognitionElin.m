% function [out, lefteye, righteye] = eyeRecognition(img)

img = imread('db1_09.jpg');
I = rgb2gray(img);

%% Elins Skin recognition
skinMask = skinRecognitionV2(img);

% plocka ut omr�det fr�n skinMask i inbilden

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
Y = imadjust(Y,stretchlim(Y),[0 1]);
Cb = imadjust(Cb,stretchlim(Cb),[0 1]);
Cr = imadjust(Cr,stretchlim(Cr),[0 1]);

% cb2
Cb2 = Cb.^2;
Cb2 = imadjust(Cb2,stretchlim(Cb2),[0 1]);

% cr2
Cr2 = (Cr-1).^2;
Cr2 = imadjust(Cr2,stretchlim(Cr2),[0 1]);

% CbCr
CbCr = Cb./Cr;

% Eye Map Chroma
EyeMapC = (Cb2 + Cr2 + CbCr)./3;

% Eye Map Luminance
se = strel('disk',10); 

dilatedY = imdilate(Y,se);
erodedY = imerode(Y,se);

EyeMapL = dilatedY./(erodedY + 1 );

% Combine final logical eye map

EyeMap = EyeMapC.*EyeMapL; 
EyeMap = (EyeMap > 0.8);   


%% Kombinera de tre metoderna med &operation. 

ImageIlluCol = EyeMap & colorBasedMask .* skinMask;
ImageColEdge = colorBasedMask & edgeBasedMask .* skinMask; 
ImageIlluEdge =  EyeMap & edgeBasedMask.* skinMask;

% figure(); imshow(EyeMap); title('Lisas typ illumination')
% figure(); imshow(colorBasedMask); title('color based mask')
% figure(); imshow(edgeBasedMask); title('edge based mask')

comboImg = ImageIlluCol | ImageIlluEdge | ImageColEdge;
% figure; imshow(comboImg); title('Combination of 3 masks')


%% tips fr�n Daniel => �gonen �r alltid i �vre halvan av bilden
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

% error n�got
if( abs(lefteye - righteye) < 20 )
    fprintf('Eyes too close! \n')
end 
if(lefteye > righteye)
   fprintf('Left is right! \n')
end

out = comboImg;

labeledImage=bwlabel(comboImg);

s = regionprops(comboImg,'centroid');
centroids = cat(1,s.Centroid);


maximumHeightDifference = 10;
maximumSpaceBetweenBlobs = 50;

for i = 1:(max(max(labeledImage))-1)
    for j = i+1:max(max(labeledImage))
        distance = sqrt( (centroids(j,1)-centroids(i,1))^2 + (centroids(j,2)-centroids(i,2))^2 )
        if(distance < maximumSpaceBetweenBlobs)
            tempMask = ismember(labeledImage, i);
            labeledImage(tempMask) = 0;
            tempMask = ismember(labeledImage, j);
            labeledImage(tempMask) = 0;
        end
    end
end

labeledImage=bwlabel(labeledImage);
s = regionprops(logical(labeledImage),'centroid');
centroids2 = cat(1,s.Centroid);
clear pairs;
counter = 1;
for i = 1:(max(max(labeledImage))-1)
    for j = i+1:max(max(labeledImage))
        if(abs(centroids2(i,2)-centroids2(j,2)) < maximumHeightDifference)
            pairs(counter,:) = [i,j];
            counter = counter + 1;
        end
    end
end


imshow(labeledImage/max(max(labeledImage)))
hold on
plot(centroids(:,1),centroids(:,2),'b*')

BW5 = bwmorph(labeledImage,'skel',Inf);
labeledLines=bwlabel(BW5);


%imshow(comboImg)

% end

