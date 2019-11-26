function [scaledImage] = scaling(im, eyeNew1, eyeNew2)

%function that returns a scaled image to 300*400 centered aroiund the
%centerpoint to the eyes. 
%im is the rotated image, eyenew1 is the left eye, eyenew2 is the right
%one. 


[rows, columns, numberOfColorChannels] = size(im);
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
scaledImage = im(row1:row2, col1:col2, :);