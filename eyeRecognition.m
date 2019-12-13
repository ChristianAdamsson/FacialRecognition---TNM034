function [out, lefteye, righteye] = eyeRecognition(img) % error ska också vara en utvariabel


% Saker som kan förbättras/implementeras:
% Skapa förväntad ögonposition inom skin mask (svårt eftersom opålitlig skin mask)
% Svårt att använda min och max distance eftersom det beror på upplösningen
% av bilderna som kommer in


% image needs to be B/W for edge & illumination based methods

% img  = imread("bl_04.jpg");
I = rgb2gray(img);

%% Skin recognition
skinMask = skinRecognitionV2(im2double(img));

maxAngle = 45;
minEdgeDist = 10; % Distance to edge in percent
expectedPosition = 0;   % expected position in eye map
error = 0;

% maximumHeightDifference = 10;
minimumSpaceBetweenBlobs = 70;
maximumSpaceBetweenBlobs = 300;
% smallestArea = 300;
% biggesttArea = 2000;

% image needs to be B/W for edge & illumination based methods
I = rgb2gray(img);

imSize = size(I);
imHeight = imSize(1);
clear imSize

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
% clear SE r newim J

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

% clear r1 r2 r3 SE SE2 SE3 J2 BW1 I

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

% clear se se2 EyeMapL EyeMapC erodedY dilatedY CbCr Cr2 Cb2 Cr Cb Y imYCbCr img
%% Kombinera de tre metoderna med &operation i olika ordning till 3 masker. 

ImageIlluCol = EyeMap .* illuminationBasedMask .* skinMask;
ImageColEdge = illuminationBasedMask .* edgeBasedMask .* skinMask; 
ImageIlluEdge = EyeMap .* edgeBasedMask .* skinMask;

figure(); imshow(EyeMap); title('Ögonigenkänning - Illumination')
figure(); imshow(colorBasedMask); title('Ögonigenkänning - Färgskillnader')
figure(); imshow(edgeBasedMask); title('Ögonigenkänning - Kantdetektering')

% Kombinera de tre maskerna med |operation till en mask
comboImg = ImageIlluCol | ImageIlluEdge | ImageColEdge;
% comboImg = EyeMap;            % alla ögon med, lite mycket hår ibland
% comboImg = illuminationBasedMask;    % alla ögon med, maaaassor annat
% comboImg = edgeBasedMask;
% figure; imshow(comboImg); title('Combination of 3 masks')

% clear ImageIlluCol ImageColEdge ImageIlluEdge EyeMap illuminationBasedMask edgeBasedMask
%% Save only blobs with correct orientation and solidity 

[y, x] = size(comboImg);

% ta bort nedre tredjedelen av ansiktsmasken 
for y1 = (2*y/3):y
    for x1 = 1:x
        y1 = floor(y1);
        x1 = floor(x1);
        comboImg(y1, x1) = 0;
   end
end
clear x y x1 y1 

%%

% save only blobs with orientation angle less than 50 degrees
% Props contains properties for the connected components of combiImg
% cc contains all the connected components of combiImg
props = regionprops(comboImg, 'Solidity', 'Orientation');
cc = bwconncomp(comboImg); 

% eyeBlobs is a list of integers corresponding to the blob labels
% fulfilling the statement.
% all the blobs in cc whose label is an integer present in eyeBlobs is
% saved in comboImg(logical).
eyeBlobs = find(abs([props.Orientation]) < 50 & [props.Solidity] > 0.5); 
comboImg = ismember(labelmatrix(cc), eyeBlobs);

SE = strel('disk', 5);
SE2 = strel('disk', 3);

comboImg = imopen(comboImg, SE);
comboImg = imopen(comboImg, SE2);

% clear SE SE2 eyeBlobs props cc

%% Find blobs with horizontal friend
labeledImage=bwlabel(comboImg);

s = regionprops(comboImg,'centroid', 'Area');
centroids = cat(1,s.Centroid);
areas = cat(1, s.Area); 

noPairs = false;
if(max(labeledImage(:)) > 1)
    clear pairs;
    counter = 1;
    %Find all pairs of blobs that are horizontal
    for i = 1:max(labeledImage(:))-1
        for j = i+1:max(labeledImage(:))
            
            x1 = centroids(i,1);
            y1 = imHeight - centroids(i,2);
            x2 = centroids(j,1);
            y2 = imHeight - centroids(j,2); 
            
            tempAngle = atan2(y2-y1,x2-x1);
            tempAngle = tempAngle*180/pi;
            
            if(abs(tempAngle) > maxAngle)
                % do nothing
            else              
                tempEdgeDist1 = 100;
                tempEdgeDist2 = 100;              
                if (tempEdgeDist1 < minEdgeDist)||(tempEdgeDist2 < minEdgeDist)     % avst till kant av bild i procent
                    % do nothing
                else
                    tempDistBetween = abs(centroids(j, 1) - centroids(i, 1));        % distance between blobs, better be related to skin mask or resolution instead. 
                    if (tempDistBetween > maximumSpaceBetweenBlobs)||(tempDistBetween < minimumSpaceBetweenBlobs) 
                        % do nothing
                    else           
                        tempDistExpected = 0;           % distance to expected position in skin map,
                        pairs{counter} = [centroids(i,1),centroids(i,2), centroids(j,1), centroids(j,2), tempAngle, tempEdgeDist1, tempEdgeDist2, tempDistBetween, tempDistExpected, i, j]; %i and j are label index
                        counter = counter + 1;
                    end
                end
            end              
        end
    end
    if(exist('pairs', 'var') == 0)
        noPairs = true;
    end
else
    noPairs = true;
end

% clear i j x1 x2 y1 y2 tempAngle tempEdgeDist1 tempEdgeDist2 tempDistBetween tempDistExpected maxAngle minEdgeDist maximumSpaceBetweenBlobs minimumSpaceBetweenBlobs counter s imHeight centroids

%%
% if noPairs, kan implementera att söka efter en blob inom skin mask och försöka anta vart andra
% ögat ska vaara. Eller bara returna false.
if noPairs
    error = "Inga ögonpar hittades"
    lefteye = [100, 100 ];       % problematiskt eftersom bilderna har olika upplösning
    righteye = [200, 100];
else
    % compare the pairs and chose the best ones
    sizePairs = size(pairs);
    nPairs = sizePairs(2);
    clear sizePairs
    
    if nPairs > 1
        % Compare area. Want to find out which pair of blobs has similar area.
        % implement more comparisons if we want to
        % for example angles, distance to edge, which pair has one or two eyes inside skin
        % mask etc.
        areaScore = zeros(1, nPairs);
        angleScore = zeros(1, nPairs);
        score = zeros(nPairs,3);
        for i = 1:nPairs
            tempPair = pairs{i};
            areaScore(i) =  abs(areas(tempPair(10))-areas(tempPair(11))) / abs(areas(tempPair(10))+areas(tempPair(11))); % low score is better
            angleScore(i) = abs(tempPair(5));                                                                        % low score is better                                                                               
        end
%         clear tempPair area
        
        % Compare which pair is best. Low score is better.
        
        for i = 1:nPairs
            score(i,1) = areaScore(i)/max(areaScore);
            score(i,2) = angleScore(i)/max(angleScore);
            score(i,3) = score(i,1) + score(i,2);   % total score. Low is better. Can add weights to the most important comparison feature
        end
        
        finalScores = score(:,3);
        
        winIdx = find(finalScores == min(finalScores));
        winningPair = pairs{winIdx};
        lefteye = [winningPair(1), winningPair(2)];
        righteye = [winningPair(3), winningPair(4)];
        
    else
        winningPair = pairs{1};
        lefteye = [winningPair(1), winningPair(2)];
        righteye = [winningPair(3), winningPair(4)];
    end
end

out = labeledImage;
% imshow(img)
% hold on
%     plot(lefteye(1),lefteye(2), 'g+', 'MarkerSize', 10, 'LineWidth', 2);
%     plot(righteye(1),righteye(2), 'r+', 'MarkerSize', 10, 'LineWidth', 2);

