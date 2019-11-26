id = 0;

%im = imread('image_0009.jpg');
%img = imread('image_0009.jpg');
im = imread('db1_01.jpg');
img = imread('db1_01.jpg');

%im = imread('db1_04.jpg');
%img = imread('db1_04.jpg');
%tnm034(im);
%figure
%imshow(im);
I = rgb2gray(im);
%figure
%imshow(I)

S = sum(img,3);
[~,idx] = max(S(:));
[row,col] = ind2sub(size(S),idx); %Hitta ljusaste punkten


%imshow(img);
viscircles([col, row], 3, 'Color', 'b');

hsvImg = rgb2hsv(img);

%imshow(hsvImg);

thresholdLogical = hsvImg(:, :, 1) > 0 & hsvImg(:, :, 1) < 50 & hsvImg(:,:,2) > 0.23 & hsvImg(:,:,2) < 0.68;

resultHsvImg = thresholdLogical.*hsvImg(:,:,3);

resultLogical = resultHsvImg > 0.6;

%imshow(resultLogical);

skinImg = img.*uint8(resultLogical);

%imshow(skinImg);
resultLogical = skinRecognition(img);

sMin = 0.23;
sMax = 0.68;
hMin = 0;
hMax = 50;
%%
newimage = img .* uint8(resultLogical);

boundbox = regionprops(resultLogical,'Area', 'BoundingBox');
boundbox(1).BoundingBox(1)
%[left, top, width, height
left = floor(boundbox(1).BoundingBox(1))
top = floor(boundbox(1).BoundingBox(2))
width = boundbox(1).BoundingBox(3)
height = boundbox(1).BoundingBox(4)

%mybox = zeros(width, height);
%mybox(1) = left: left + width;
%testbox = [left: (left + width), 0:top];

scale = 1;
J = imresize(newimage,1);
%nothing working :///


%Things that didn't work
%bboxA = floor(boundbox(1).BoundingBox);
%bboxA = int64(bboxA);
%bboxB = bboxresize(bboxA ,scale);
%intbox = int8(boundbox(1).BoundingBox);

% In order to see the box around the selected face. 
%J = insertObjectAnnotation(J,'Rectangle',boundbox(1).BoundingBox,'testbox');

%testbox = imrezise(newimage, [testbox(1), testbox(2)]);
%figure;
%imshow(J);

%%
% cropping the image to the bounding box. 
rezisedimg = imcrop(J, boundbox(1).BoundingBox);
%rezisedimg = J(left: left + width, top: top + height);

%showing the cropped image
figure;
imshow(rezisedimg)

%% scaling
%ska det verkligen skalas varje g�ng??
%scaledim = imresize(rezisedimg, [400, 300]);
%figure;
%imshow(scaledim);
%im = imread('db1_15.jpg');
rotate();
[eyeNew1, eyeNew2, rotatedImage] = rotateImage(Image, righteye, lefteye);
figure
imshow(rotatedImage);
%%
%Then, assuming get the edges.
%Let's say you want 960 by 960 centered on (y,x) = (rowMax, colMax).
[rows, columns, numberOfColorChannels] = size(rotatedImage);
diffx = (eyeNew1(2) - eyeNew2(2))/2;
%diffy = (eyeNew2(1) - eyeNew1(1))/2;
centery = eyeNew2(2) + diffx;
centerx = eyeNew2(1);


height = 300;
halfheight = height/2;
width = 400;
halfWidth = width /2;
row1 = centerx - halfWidth;
row2 = row1 + width - 1;
col1 = centery - halfheight;
col2 = col1 + height - 1;

if row1 < 1
    row1 = 1;
end
if row2 > rows
    row2 = rows;
end
if col1 < 1
    col1 = 1;
end
if col2 > columns
    col2 = columns;
end
%if row1 > left
%    row1 = left;
%end
%if col1 < top
%    col1 = top;
%end

%I = imresize(rotatedImage, [col2, row2]);
I = rotatedImage(row1:row2, col1:col2, :);

figure;
imshow(I);
%A = [row1:row2, col1:col2];
%rotatedImage = (row1:row2, col1:col2);
%rotatedImage = mat2gray(row1:floor(row2), col1:floor(col2));
%figure;
%imshow(rotatedImage);
%scaledIm = imresize(rotatedImage, [row1:row2, col1:col2]);





