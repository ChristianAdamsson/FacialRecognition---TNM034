clear
close all
clc

image = greyWorldAssumption(imread('bilder\bl_10.jpg')); 
skinMask = skinRecognitionV2(image);
imshow(image.*uint8(skinMask));

%%
clear
close all
clc

%displayImages();

images = cell(54,1);
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
images{17} = imread('bilder\bl_01.jpg'); images{18} = imread('bilder\bl_02.jpg'); images{19} = imread('bilder\bl_04.jpg');
images{20} = imread('bilder\bl_05.jpg'); images{21} = imread('bilder\bl_06.jpg'); images{22} = imread('bilder\bl_07.jpg');
images{23} = imread('bilder\bl_10.jpg'); images{24} = imread('bilder\bl_13.jpg'); images{25} = imread('bilder\bl_14.jpg');

counter = 1;
for i = 26:41
    if counter < 10 
        images{i} = imread(strcat('bilder\cl_0', int2str(counter), '.jpg'));
    else
        images{i} = imread(strcat('bilder\cl_', int2str(counter), '.jpg'));
    end
    counter = counter + 1;
end

images{42} = imread('bilder\ex_01.jpg'); images{43} = imread('bilder\ex_03.jpg'); images{44} = imread('bilder\ex_04.jpg');
images{45} = imread('bilder\ex_07.jpg'); images{46} = imread('bilder\ex_09.jpg'); images{47} = imread('bilder\ex_11.jpg');
images{48} = imread('bilder\ex_12.jpg'); 

images{49} = imread('bilder\il_01.jpg'); images{50} = imread('bilder\il_07.jpg'); images{51} = imread('bilder\il_08.jpg');
images{52} = imread('bilder\il_09.jpg'); images{53} = imread('bilder\il_12.jpg'); images{54} = imread('bilder\il_16.jpg');

figure('Name', 'DB1');
for i = 1:16
    [resultLogical{i}, leftEye, rightEye] = eyeRecognitionElin(images{i});
    subplot(4, 4, i);   
    imshow(images{i}); 
    hold on
    plot(leftEye(1),leftEye(2), 'g+', 'MarkerSize', 10, 'LineWidth', 2);
    plot(rightEye(1),rightEye(2), 'r+', 'MarkerSize', 10, 'LineWidth', 2);
end

counter = 1;
figure('Name', 'BL');
for i = 17:25
    faceMask = uint8(skinRecognitionV2(images{i}));
    [resultLogical{i}, leftEye, rightEye] = eyeRecognitionElin(images{i});
    subplot(4, 5, counter);
    imshow(images{i}.*faceMask);
    counter = counter + 1;
    subplot(4, 5, counter);  
    imshow(images{i}); 
    hold on
    plot(leftEye(1),leftEye(2), 'g+', 'MarkerSize', 10, 'LineWidth', 2);
    plot(rightEye(1),rightEye(2), 'r+', 'MarkerSize', 10, 'LineWidth', 2);
    counter = counter + 1;
end

counter = 1;
figure('Name', 'CL');
for i = 26:42
    faceMask = uint8(skinRecognitionV2(images{i}));
    [resultLogical{i}, leftEye, rightEye] = eyeRecognitionElin(images{i});
    subplot(6, 6, counter);
    imshow(images{i}.*faceMask);
    counter = counter + 1;
    subplot(6, 6, counter);   
    imshow(images{i}); 
    hold on
    plot(leftEye(1),leftEye(2), 'g+', 'MarkerSize', 10, 'LineWidth', 2);
    plot(rightEye(1),rightEye(2), 'r+', 'MarkerSize', 10, 'LineWidth', 2);
    counter = counter + 1;
end

counter = 1;
figure('Name', 'EX');
for i = 42:48
    faceMask = uint8(skinRecognitionV2(images{i}));
    [resultLogical{i}, leftEye, rightEye] = eyeRecognitionElin(images{i});
    subplot(4, 4, counter);
    imshow(images{i}.*faceMask);
    counter = counter + 1;
    subplot(4, 4, counter);    
    imshow(images{i}); 
    hold on
    plot(leftEye(1),leftEye(2), 'g+', 'MarkerSize', 10, 'LineWidth', 2);
    plot(rightEye(1),rightEye(2), 'r+', 'MarkerSize', 10, 'LineWidth', 2);
    counter = counter + 1;
end

counter = 1;
figure('Name', 'IL');
for i = 48:54
    faceMask = uint8(skinRecognitionV2(images{i}));
    [resultLogical{i}, leftEye, rightEye] = eyeRecognitionElin(images{i});
    subplot(4, 4, counter);
    imshow(images{i}.*faceMask);
    counter = counter + 1;
    subplot(4, 4, counter);   
    imshow(images{i}); 
    hold on
    plot(leftEye(1),leftEye(2), 'g+', 'MarkerSize', 10, 'LineWidth', 2);
    plot(rightEye(1),rightEye(2), 'r+', 'MarkerSize', 10, 'LineWidth', 2);
    counter = counter + 1;
end

%%
sgtitle('Skin Recognition V2 - Orginal');

figure('Name', 'Orginal - Reference White');
for i = 1:16
    referenceWhiteImages{i} = referenceWhite(images{i});
    refResultLogical{i} = skinRecognitionV2(referenceWhiteImages{i});
    skinImg = images{i}.*uint8(resultLogical{i}-refResultLogical{i});
    subplot(4, 4, i);
    imshow(skinImg);
end
sgtitle('Gray World Assumption');


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

img = imread('bilder\bl_05.jpg');

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


%%
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

%%
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
