% träningsfas
eigenfaces_Training();

% igenkänningsfas
im = imread('image_0009.jpg');
id = tnm034(im);

fprintf('ID: '+ id)