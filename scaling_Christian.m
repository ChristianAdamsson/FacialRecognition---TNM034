id = 0;

im = imread('image_0009.jpg');
img = imread('image_0009.jpg');
%tnm034(im);
%figure
%imshow(im);
I = rgb2gray(im);
figure
imshow(I)

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
%%plot(centroids(:,1),centroids(:,2),'b*')
%[left, top, width, height
left = floor(boundbox(1).BoundingBox(1))
top = floor(boundbox(1).BoundingBox(2))
width = boundbox(1).BoundingBox(3)
height = boundbox(1).BoundingBox(4)

%mybox = zeros(width, height);
%mybox(1) = left: left + width;
%testbox = [left: (left + width), 0:top];
scale = 1/2;
J = imresize(newimage,scale);
intbox = uint8(boundbox(1).BoundingBox);
%bbox = [int(left), int(top), int(width), int(height)];
bboxResized = bboxresize(intbox,scale);

%testbox = imrezise(newimage, [testbox(1), testbox(2)]);
figure;
imshow(newimage);




