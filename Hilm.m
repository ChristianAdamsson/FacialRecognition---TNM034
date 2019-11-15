in = imread('db1_10.jpg');
figure,imshow(in)
title('Original')

greyWorldAssumption(in);
referenceWhite(in);