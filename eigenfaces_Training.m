% This code calculates the feature vectors for a set of training images
% Modify the code to fit your needs


M = 16;  
n = 300*400;
k = 9;


%% Store all images in faceCluster
% images from https://drive.google.com/open?id=1RJBgyVqO49sA99aOSHr6SkkiDnX3JMGP

for i = 1:M
    img = im2double(rgb2gray(imread(strcat('dream\dream', int2str(i), '.jpg'))));
    faceCluster(:,i) = img(:);
end
clear img

%% Compute average face
averageFace = 1/M * sum(faceCluster,2);

%% Compute phi = A, which holds each image minus the average face
A = faceCluster - averageFace;
clear faceCluster

%% Covariance matrix
C = A'*A;

%% Compute eigenvectors for C, will be M vectors of dimension M*1
% V = eigenvectors, D = corresponding eigenvalues in diagonal matrix
[V,D] = eig(C);
clear D C

%% Compute eigenvectors and store the k best ones in bestEigenvectors

for i = 1:M
   U(:,i) = A*V(:,i);
end

for j = 1:k
    bestEigenvectors(:,j) = U(:, M + 1 - j);
end
clear U

%% Calculate weights for all images
% Use only the best k eigenvectors
% w is a matrix of M column vectors, and the column vectors contain the
% weights (k weights per vector)

for i = 1:M 
    for j = 1:k
        w(j,i) = bestEigenvectors(:,j)'*A(:,i);
    end
end
clear A










% %% Reshape U into matrice to get eigenfaces
% 
% for i = 1:M
%     eigenface(:,:,i) = (reshape(U(:,i),[400,300])); %normalizeChannel
% end
% 
% % Show all eigenfaces
% figure
% for i = 1:M
%     subplot(4,4,i)
%     imshow(eigenface(:,:,i))    
% end
% 





