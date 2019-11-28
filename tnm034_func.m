%% träningsfas
clc; close all
eigenfaces_Training();

%% igenkänningsfas
clc; close all
im = imread('db1_03.jpg');
%id = tnm034(im)

normalized = normalize(im);
img = normalized(:) - averageFace;

for j = 1:k
    w_img(j,1) = bestEigenvectors(:,j)'*img;
end
clear img j

%% Closest feature vector
e = zeros(M,1);

for i = 1:M
    e(i) = norm(w_img - w(:,i));
end
clear i

bestMatch = find(e==min(e));