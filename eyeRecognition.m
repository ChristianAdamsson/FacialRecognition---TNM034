function [out, lefteye, righteye] = eyeRecognition(img)

% image needs to be B/W for edge & illumination based methods
I = rgb2gray(img);

%% Elins Skin recognition
skinMask = skinRecognitionV2(img);


%% Illumination-based method 

% equlized histogram in grayscale
J = histeq(I);
newim = J < 30;

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

ImageIlluCol = EyeMap .* illuminationBasedMask .* skinMask;
ImageColEdge = illuminationBasedMask .* edgeBasedMask .* skinMask; 
ImageIlluEdge = EyeMap .* edgeBasedMask .* skinMask;

% Kombinera de tre maskerna med |operation till en mask
comboImg = ImageIlluCol | ImageIlluEdge | ImageColEdge;
% comboImg = EyeMap;            
% comboImg = illuminationBasedMask;    
% comboImg = edgeBasedMask;


%% tips från Daniel => ögonen är alltid i övre halvan av bilden

% save only high density blobs with angle around 45 degrees and specified area 
props = regionprops(comboImg,'Area', 'Solidity', 'Orientation');
cc = bwconncomp(comboImg); 

eyeBlobs = find( abs([props.Orientation]) < 50 & [props.Solidity] > 0.5 & [props.Area] > 350 & [props.Area] < 3500); 
comboImg = ismember(labelmatrix(cc), eyeBlobs);

SE = strel('disk', 5);
SE2 = strel('disk', 3);

comboImg = imopen(comboImg, SE);
comboImg = imopen(comboImg, SE2);


%% what we get out of regionpropsfunction.boundingbox.
    % [left, top, width, height]
    % left = floor(boundbox(1).BoundingBox(1))
    % top = floor(boundbox(1).BoundingBox(2))
    % width = boundbox(1).BoundingBox(3)
    % height = boundbox(1).BoundingBox(4)
    

%% update bounding box
boundbox = regionprops(comboImg,'BoundingBox');
cc = bwconncomp(comboImg);

% cc.NumObjects

if (cc.NumObjects < 2)
    lefteye = [123, 247];
    righteye = [267, 250];
    fprintf('Less than 2 eyes found! \n')
else
      
    % x-values
    lefteye = boundbox(1).BoundingBox(1) + 0.5*boundbox(1).BoundingBox(3);
    righteye = boundbox(2).BoundingBox(1)+ 0.5*boundbox(2).BoundingBox(3);

    % y-values
    yleft = boundbox(1).BoundingBox(2) + 0.5*boundbox(1).BoundingBox(4);
    yright = boundbox(2).BoundingBox(2) + 0.5*boundbox(2).BoundingBox(4);

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
