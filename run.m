clear all

eigenfaces_Training();

% Read image and create its weight vector w
img = im2double(rgb2gray(imread('dream/dream1.jpg')));
img = img(:) - averageFace;

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

%% Threshold - is this close enough?
threshold = 0.5;

if min(e) < 0.5
    id = bestMatch;
end





