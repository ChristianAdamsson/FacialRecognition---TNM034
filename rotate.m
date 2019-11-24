% Face alignment is the task of identifying the geometric structure of faces 
% in digital images, and attempting to obtain a canonical alignment of the face 
% based on translation, scale, and rotation.
% source: https://paperswithcode.com/task/face-alignment

clear all
close all

%% Read image
Image = imread('db1_01.jpg');

[imHeight, imWidth, channels] = size(Image);


%% Mark the mouth and eyes
% x = distance from top
% y = distance from left edge

fh1 = figure; imshow(Image);
set(fh1,'NumberTitle','off','Name','Select eyes n mouth')
[e1_y,e1_x] = ginput(1);
[e2_y,e2_x] = ginput(1);
[m_y,m_x] = ginput(1);



% 
% e1 = [e1_x,e1_y];
% e2 = [e2_x,e2_y];
% m_center = [m_x,m_y];


%% Calculate how much eyes are off from x-axis
% If the right eye is positioned higher, then height will be positive.
height = e1_x - e2_x;
width = e2_y - e1_y;

% Angle will be positive if the right eye is above the left
angle = asind(height/width);




%% Rotate based on eye position
rotatedImage = imrotate(Image,-angle, 'bilinear');


%% Calculate new position of eyes
segA = e1_y / cosd(abs(angle));
helpsegB = e1_y * tand(abs(angle));
helpsegC = e1_x - helpsegB;
segD = helpsegC * sind(abs(angle));
segE = helpsegC * cosd(abs(angle)); % fel tror jag
segF = imWidth * sind(abs(angle));

e1_xNew = segF + segE;
e1_yNew = segA + segD;


% Check that position is correct
fh2 = figure; imshow(rotatedImage);
set(fh2,'NumberTitle','off','Name','Select eye')
[e1r_y,e1r_x] = ginput(1);


