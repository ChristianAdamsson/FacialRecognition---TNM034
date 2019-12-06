clear
clc 
close all

for i = 1:16
    img = imread(strcat('dream\dream', int2str(i), '.jpg'));
    faceCluster( i, :, :) = im2double(rgb2gray(img));
end


M = 16;
n = 300*400;
k = 9;
averageFace(:,:,1) = 1/M * sum(faceCluster);

imshow(averageFace);

for i = 1:16
    face(:,:,1) = faceCluster(i,:,:);
    phi(i,:,:) = face - averageFace;
end

face(:,:,1) = phi(i,:,:);
imshow(face);


for i = 1:16
    for j = 1:16
        eigenFaces(i,j,:,:) = phi(i,:,:) .* phi(j,:,:);
    end
end

for i = 1:16
    eigenFace(:,:,:,1) = eigenFaces(i, :, :, :);
    bestEigenFaces(:,:,:,1) = phi .* eigenFace;
end


for i = 1:16
    face(:,:,1) = normalizeChannel(bestEigenFaces(i,:,:));
    subplot(4, 4, i)
    imshow(face);
end


%%
clc 
close all
% face(:,:,1) = bestEigenFaces(1,:,:);
% phiFace(:,:,1) = phi(1,:,:);
% alphaFaces(1,1,:,:) = face' * phiFace;
% sumEigen = face * face' * phiFace;

for i = 1:16
    for j = 1:16
        
        bestEigenFace(:,:,1) = bestEigenFaces(j,:,:);
        phiFace(:,:,1) = phi(i,:,:);
        
        alphaFaces(i,j,:,:) = bestEigenFace' * phiFace;
        
        if j == 1
            sumEigen = bestEigenFace * bestEigenFace' * phiFace;
        else
            sumEigenFaces(i,:,:) = sumEigen + (bestEigenFace * bestEigenFace' *phiFace);
        end
        
        
%         alphaFaces(i,j,:,:) = face' * phiFace;
%         
%         face(:,:,1) = bestEigenFaces(j,:,:);
%         phiFace(:,:,1) = phi(j,:,:);
%         alpha(j,:,:) = face' * phiFace;
%         sumEigen = sumEigen + ( face * face' * phiFace);
    end
    sumEigenFace(:,:,1) = sumEigenFaces(i,:,:);
    reconstructionFaces(i,:,:) = averageFace + sumEigenFace;
end

reconstructionFace(:,:,1) = reconstructionFaces(15,:,:);
imshow(normalize(reconstructionFace));   

%%
clc
close all

kingFace = im2double(rgb2gray(imread(strcat('dream\dreamTest.jpg'))));
    
kingPhi = kingFace - averageFace;
 
face(:,:,1) = bestEigenFaces(1,:,:);
kingAlpha(1,:,:) = face' * kingPhi;

for j = 2:16
    face(:,:,1) = bestEigenFaces(j,:,:);
    kingAlpha(j,:,:) = face' * phiFace;
end

for i = 1:16
    alphaFace(:,:,:,1) = alphaFaces(i,:,:,:);
    result(i,:,:,:) = kingAlpha - alphaFace;
end

result2 = min(min(min(min(result))));


%%
clear
close all
clc

%displayImages();

images = cell(16,1);
referenceWhiteImages = cell(16,1);
greyWorldAssumptionImages = cell(16,1);
resultLogical = cell(16,1);
refResultLogical = cell(16,1);
grayResultLogical = cell(16,1);

for i = 1:16
    if i < 10 
        images{i} = imread(strcat('db1_0', int2str(i), '.jpg'));
    else
        images{i} = imread(strcat('db1_', int2str(i), '.jpg'));
    end
end

figure('Name', 'Skin Recognition V2 - Orginal');
for i = 1:16
    resultLogical{i} = skinRecognitionV2(images{i});
    skinImg = images{i}.*uint8(resultLogical{i});
    subplot(4, 4, i);
    imshow(skinImg);
end

sgtitle('Skin Recognition V2 - Orginal');

figure('Name', 'Orginal - Reference White');
for i = 1:16
    referenceWhiteImages{i} = referenceWhite(images{i});
    refResultLogical{i} = skinRecognitionV2(referenceWhiteImages{i});
    skinImg = images{i}.*uint8(resultLogical{i}-refResultLogical{i});
    subplot(4, 4, i);
    imshow(skinImg);
end

sgtitle('Orginal - Reference White');

figure('Name', 'Reference White - Orginal');
for i = 1:16
    skinImg = images{i}.*uint8(refResultLogical{i}-resultLogical{i});
    subplot(4, 4, i);
    imshow(skinImg);
end

sgtitle('Reference White - Orginal');

figure('Name', 'Reference White');
for i = 1:16
    skinImg = images{i}.*uint8(refResultLogical{i});
    
    subplot(4, 4, i);
    imshow(skinImg);
end

sgtitle('Reference White');

figure('Name', 'Orginal - Gray World Assumption');
for i = 1:16
    greyWorldAssumptionImages{i} = greyWorldAssumption(images{i});
    grayResultLogical{i} = skinRecognitionV2(greyWorldAssumptionImages{i});
    skinImg = images{i}.*uint8(resultLogical{i}-grayResultLogical{i});
    
    subplot(4, 4, i);
    imshow(skinImg);
end
sgtitle('Orginal - Gray World Assumption');

figure('Name', 'Gray World Assumption - Orginal');
for i = 1:16
    skinImg = images{i}.*uint8(grayResultLogical{i}-resultLogical{i});
    
    subplot(4, 4, i);
    imshow(skinImg);
end
sgtitle('Gray World Assumption - Orginal');

figure('Name', 'Gray World Assumption');
for i = 1:16
    skinImg = images{i}.*uint8(grayResultLogical{i});
    
    subplot(4, 4, i);
    imshow(skinImg);
end
sgtitle('Gray World Assumption');


%%
clear
close all
clc

img = imread('db1_02.jpg');

%img = greyWorldAssumption(img);
%img = referenceWhite(img);
    
    

    resultLogical = skinRecognitionV2(img);
    [ coolt,  noRice, noSmallMacs, noLargeMacs] = CountObjects(img, resultLogical);
    skinImg = img.*uint8(resultLogical);
    subplot(1, 2, 1);
    imshow(skinImg);
    resultLogical = skinRecognitionV2(img);
    skinImg = img.*uint8(resultLogical);
    subplot(1, 2, 2);
    imshow(coolt);



%img = greyWorldAssumption(img);
%img = referenceWhite(img);
% 
% resultLogical = skinRecognitionV2(img);
% 
% skinImg = img.*uint8(resultLogical);
% 
% imshow(skinImg);

% 
% S = sum(img,3);
% [~,idx] = max(S(:));
% [row,col] = ind2sub(size(S),idx); %Hitta ljusaste punkten
% 
% imshow(img);
% viscircles([col, row], 3, 'Color', 'b');