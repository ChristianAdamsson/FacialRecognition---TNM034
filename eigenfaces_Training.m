% This code calculates the feature vectors for a set of training images
% Modify the code to fit your needs

clear
clc 
close all


M = 16;
n = 300*400;
k = 9;


%% Store all images in faceCluster

for i = 1:M
    img = imread(strcat('dream\dream', int2str(i), '.jpg'));
    faceCluster( :, :, i) = im2double(rgb2gray(img));
end

%% Compute average face

averageFace = 1/M * sum(faceCluster,3);
imshow(averageFace);

%% Compute phi, which holds each image in face cluster minus the average face
for i = 1:M
    phi(:,:,i) = faceCluster(:,:,i) - averageFace;
end

%% Vectorize phi
% Each image gets stored as column vector, starting with element 
% [1,1], [1,2], [1,3]...
% A is phi but in vector form

for i = 1:M 
    temp = phi(:,:,i)';
    A(:,i) = temp(:); 
end

%% Covariance matrix
C = A'*A;

%% Compute eigenvectors for C, will be M vectors of dimension M*1
% V = eigenvectors, D = corresponding eigenvalues in diagonal matrix

[V,D] = eig(C);


%% Compute eigenvectors and store the k best ones in bestEigenvectors

for i = 1:M
   U(:,i) = A*V(:,i);
end

for j = 1:k
    bestEigenvectors(:,j) = U(:, M + 1 - j);
end

%% Calculate weights for all images
% Use only the best k eigenvectors
% w is a matrix of M column vectors, and the column vectors contain the
% weights (k weights per vector)

for i = 1:M 
    for j = 1:k
        w(j,i) = bestEigenvectors(:,j)'*A(:,i);
    end
end

% w(:,1) is the feature vector for image 1










% 
% %% Reshape U into matrice to get eigenfaces
% 
% for i = 1:M
%     eigenface(:,:,i) = (reshape(U(:,i),[300,400])'); %normalizeChannel
% end
% 
% % Show all eigenfaces
% figure
% for i = 1:M
%     subplot(4,4,i)
%     imshow(eigenface(:,:,i))    
% end






