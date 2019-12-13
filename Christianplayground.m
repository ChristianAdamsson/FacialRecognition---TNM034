% This code calculates the feature vectors for a set of training images
% Modify the code to fit your needs


M = 100;  
n = 300*400;
k = 16;

faceCluster = zeros(n,M);
%% Store all images in faceCluster
% images from 
% De som ska läsas in i loopen ska vara normaliserade redan
for i = 1:M
    if  i >= 100
      img = normalize(imread(strcat('C:\Users\chris\Downloads\faces\image(', int2str(i), ').jpg')));    
    elseif i >= 10
      img = normalize(imread(strcat('C:\Users\chris\Downloads\faces\image(0', int2str(i), ').jpg')));
      %img = normalize(imread(strcat('C:\Users\Hilma\OneDrive - Linköpings universitet\FLUM\TNM034 - ABOB\DB1\db1_0', int2str(i), '.jpg')));
    else  
      img = normalize(imread(strcat('C:\Users\chris\Downloads\faces\image(00', int2str(i), ').jpg')));
    end
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
clear V

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
%clear A i j 










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





