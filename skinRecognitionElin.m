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
    imshow(face);
    figure;
end

%%

%w = 


%comapredFace = faceCluster - averageFace;

%displayImages();


% img = imread('db1_02.jpg');
% 
% 
% %img = greyWorldAssumption(img);
% img = referenceWhite(img);
% 
% resultLogical = skinRecognition(img);
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