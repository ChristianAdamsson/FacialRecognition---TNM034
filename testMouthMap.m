% read all images
images = cell(16,1);
for i = 1:16
    if i < 10 
        images{i} = imread(strcat('db1_0', int2str(i), '.jpg'));
    else
        images{i} = imread(strcat('db1_', int2str(i), '.jpg'));
    end
end
out = cell(16,1);

figure('Name', 'Munigenkänning')
title('Munigenkänning')
for i = 1:16
    [out{i}] = mouthmapLisa(images{i});
     subplot(4, 4, i);
     imshow(out{i});
end

sgtitle('Munigenkänning')

%%
clear all
in = imread('db1_10.jpg');
[~, lefteye, righteye] = eyeRecognition(in);
[rot, scal, trans] = scaling(in, lefteye, righteye);

subplot(1,1)
imshow(rot)

subplot(1,2)
imshow(scal)

subplot(1,3)
imshow(trans)