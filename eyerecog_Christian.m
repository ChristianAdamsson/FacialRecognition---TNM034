function [out, lefteye, righteye] = eyerecog_Christian(img)


% image needs to be B/W for edge & illumination based methods
I = rgb2gray(img);

%% Elins Skin recognition
skinMask = skinRecognitionV2(img);


%% Illumination-based method 

% equlized histogram in grayscale
J = histeq(I);
newim = J < 30;

% Attempt in detecting the actual eyes
% needs to define shape that we want to use morphological open on. 
% Dilation, erotion. I think this is close to an ellipse.

r = 3;
SE = strel('disk',r);

illuminationBasedMask = imclose(newim, SE);


%% Edge based method: 

BW1 = edge(I,'sobel');
% BW2 = edge(I,'canny');

% probably needs some work with the SE ad erotion etc. 
r1 = 1;
r2 = 2;
r3 = 4;

%this is the things that workds for most pictures. 
SE = strel('disk', r1);
SE2 = strel('disk', r2);
SE3 = strel('disk', r3);

% 2 dilation to enhance connected regions and fill holes 
% 3 erosion to remove unwanted connected regions

J2 = imdilate(BW1,SE3);
J2 = imdilate(J2, SE3);
J2 = imerode(J2, SE3);    
J2 = imerode(J2, SE);
J2 = imerode(J2, SE);

edgeBasedMask = J2;

%% Lisas Color Based implementation

img = im2double(img) .* skinMask;
imYCbCr = rgb2ycbcr(img);

% Isolate Y Cb and Cr
Y = imYCbCr(:,:,1);
Cb = imYCbCr(:,:,2);
Cr = imYCbCr(:,:,3);

% normalize channels
Y = normalizeChannel(Y);
Cb = normalizeChannel(Cb);
Cr = normalizeChannel(Cr);

% compute stuff to combine to chroma map
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

EyeMapL = dilatedY./(erodedY + 1);
normalizeChannel(EyeMapL);

% Combine final logical eye map
EyeMap = EyeMapC.*EyeMapL; 
se2 = strel('disk',7);
EyeMap = imdilate(EyeMap, se2);

normalizeChannel(EyeMap);
EyeMap = (EyeMap > 0.42);  


%% Kombinera de tre metoderna med &operation i olika ordning till 3 masker. 

% PROVA FIND SOLIDITY PÅ VARJE MASK

ImageIlluCol = EyeMap .* illuminationBasedMask .* skinMask;
ImageColEdge = illuminationBasedMask .* edgeBasedMask .* skinMask; 
ImageIlluEdge = EyeMap .* edgeBasedMask .* skinMask;

% figure(); imshow(EyeMap); title('Lisas typ illumination')
% figure(); imshow(colorBasedMask); title('color based mask')
% figure(); imshow(edgeBasedMask); title('edge based mask')

% Kombinera de tre maskerna med |operation till en mask
comboImg = ImageIlluCol | ImageIlluEdge | ImageColEdge;
% comboImg = EyeMap;            % alla ögon med, lite mycket hår ibland
% comboImg = illuminationBasedMask;    % alla ögon med, maaaassor annat
% comboImg = edgeBasedMask;
% figure; imshow(comboImg); title('Combination of 3 masks')


%% tips från Daniel => ögonen är alltid i övre halvan av bilden
[y, x] = size(comboImg);

% ta bort nedre halvan av ansiktsmasken 
% for y1 = (y/2):y
%     for x1 = 1:x
%         y1 = floor(y1);
%         x1 = floor(x1);
%         comboImg(y1, x1) = 0;
%    end
% end


% save only blobs with angle around 45 degrees
props = regionprops(comboImg,'Area', 'BoundingBox', 'Solidity', 'Orientation', 'Extent');
cc = bwconncomp(comboImg); 

ngt = find(  abs([props.Orientation]) < 50 & [props.Solidity] > 0.5); %  0.8 < [boundbox.Extent] < 4.0
comboImg = ismember(labelmatrix(cc), ngt);

SE = strel('disk', 5);
SE2 = strel('disk', 3);

comboImg = imopen(comboImg, SE);
comboImg = imopen(comboImg, SE2);

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
boundingbox = regionprops(comboImg,'BoundingBox');
cc = bwconncomp(comboImg);

if (cc.NumObjects < 2)
    lefteye = [123, 247];
    righteye = [267, 250];
    fprintf('Less than 2 eyes found! \n')
else
      
    % x-values
    lefteye = boundingbox(1).BoundingBox(1);
    righteye = boundingbox(1).BoundingBox(1) + boundingbox(1).BoundingBox(3);

    % y-values
    yleft = boundingbox(1).BoundingBox(2);
    yright = boundingbox(1).BoundingBox(2);

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


end
