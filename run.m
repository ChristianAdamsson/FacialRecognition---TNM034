%clear all

%eigenfaces_Training();

%dream10 blir 2
%dream11 blir 1
%dream13 blir 7
%dream14 blir 1
%dream15 blir 10
%dream17 blir 7
%dream18 (kungen) blir 2. 
% Read image and create its weight vector w
%img = im2double(rgb2gray(imread('dream/dream1.jpg')));
img = normalize(imread('ex_01.jpg'));
img = img(:) - averageFace;

%if we want to check all the images, should probably be put outside
%of this script to return numbers. 
M = 16;
%imgcontainer = zeros(16);
%for i = 1:M
%img = im2double(rgb2gray(imread(strcat('dream/dream', int2str(i), '.jpg'))));
%img = img(:) - averageFace;
%end
for j = 1:k
    w_img(j,1) = bestEigenvectors(:,j)'*img;
end
%clear img j

%%



%% Closest feature vector
e = zeros(M,1);

for i = 1:M
    e(i) = norm(w_img - w(:,i));
end
clear i

bestMatch = find(e==min(e));

%% Threshold - is this close enough?
%min error differs vastly, sometimes around 3000 sometimes around 900. 
%Everyone isn't classified correctly. 
threshold = 3000;
if min(e) > threshold
    bestMatch = 0;
    %intruder!! / Kungen
end

bestMatch




