%% DB0

for i = 1:4
    im  = imread(strcat('DB0/db0_', int2str(i), '.jpg'));
    id(i) = tnm034(im)
end


%% DB1

for i = 1:16
    if i >= 10
        im  = imread(strcat('DB1/db1_', int2str(i), '.jpg'));
    else
        im  = imread(strcat('DB1/db1_0', int2str(i), '.jpg'));
    end
    id(i) = tnm034(im)
end

%% DB1_Modified

for i = 1:16
    if i >= 10
        imcolor  = imread(strcat('DB1_Modified/db1_', int2str(i), '_color.jpg'));
        imcombined  = imread(strcat('DB1_Modified/db1_', int2str(i), '_combined.jpg'));
        imrotated  = imread(strcat('DB1_Modified/db1_', int2str(i), '_rotated.jpg'));
        imscaled  = imread(strcat('DB1_Modified/db1_', int2str(i), '_scaled.jpg'));
    else
        imcolor  = imread(strcat('DB1_Modified/db1_0', int2str(i), '_color.jpg'));
        imcombined  = imread(strcat('DB1_Modified/db1_0', int2str(i), '_combined.jpg'));
        imrotated  = imread(strcat('DB1_Modified/db1_0', int2str(i), '_rotated.jpg'));
        imscaled  = imread(strcat('DB1_Modified/db1_0', int2str(i), '_scaled.jpg'));
    end
    idcolor(i) = tnm034(imcolor)
    idcombined(i) = tnm034(imcombined)
    idrotated(i) = tnm034(imrotated)
    idscaled(i) = tnm034(imscaled)
end

%% DB2

for i = 1:38
    im  = imread(strcat('DB2/db2 (', int2str(i), ').jpg'));
    
    id(i) = tnm034(im)
end

%%
% facebook
for i = 1:4
    im  = imread(strcat('fb (', int2str(i), ').jpg'));
    
    id(i) = tnm034(im)
end