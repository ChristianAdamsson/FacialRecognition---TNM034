function [id] = tnm034(im)

% im = image of unknown face, RGB-image in uint8 format in
% the range [0,255]
%
% id: The identity number(integer) of the identified person,
% i.e. '1', '2', ... , '16' for the persons belonging to 'db1'
% and '0' for all other faces

% Variables from training:
load('variables.mat');

% ranges (also from training)
p1 = 1:14;
p2 = 15:32;
p3 = 33:50;
p4 = 51:66;
p5 = 67:70;
p6 = 71:88;
p7 = 89:100;
p8 = 101:117;
p9 = 118:135;
p10 = 136:152;
p11 = 153:168;
p12 = 169:173;
p13 = 174:190;
p14 = 191:204;
p15 = 205:208;
p16 = 209:226;

% normalize the image
normalized = normalize(im);
img = normalized(:) - averageFace;

% calculate weights for the image
for j = 1:k
    w_img(j,1) = bestEigenvectors(:,j)'*img;
end

% calculate euclidian distance
for i = 1:M
    e(i) = norm(w_img(:,1) - w(:,i)); 
end


% Threshold
% thresh = 1800;  % strict
thresh = 3300;  % loose


% calculate best match with min error, min(e)
if (min(e)>thresh)
    id = 0;
    
else
    bestMatch = find(e == min(e));

    if(size(bestMatch)>1)
        bestMatch = bestMatch(1);
    end
    
    % display best match
    if     (min(p1)<= bestMatch) && (bestMatch <= max(p1))
        id = 1;    
    elseif (min(p2)<= bestMatch) && (bestMatch <= max(p2))
        id = 2;     
    elseif (min(p3)<= bestMatch) && (bestMatch <= max(p3))
        id = 3;
    elseif (min(p4)<= bestMatch) && (bestMatch <= max(p4))
        id = 4;
    elseif (min(p5)<= bestMatch) && (bestMatch <= max(p5))
        id = 5;
    elseif (min(p6)<= bestMatch) && (bestMatch <= max(p6))
        id = 6;
    elseif (min(p7)<= bestMatch) && (bestMatch <= max(p7))
        id = 7;
    elseif (min(p8)<= bestMatch) && (bestMatch <= max(p8))
        id = 8; 
    elseif (min(p9)<= bestMatch) && (bestMatch <= max(p9))
        id = 9;     
    elseif (min(p10)<= bestMatch) && (bestMatch <= max(p10))
        id = 10;
    elseif (min(p11)<= bestMatch) && (bestMatch <= max(p11))
        id = 11;
    elseif (min(p12)<= bestMatch) && (bestMatch <= max(p12))
        id = 12;
    elseif (min(p13)<= bestMatch) && (bestMatch <= max(p13))
        id = 13;
    elseif (min(p14)<= bestMatch) && (bestMatch <= max(p14))
        id = 14;
    elseif (min(p15)<= bestMatch) && (bestMatch <= max(p15))
        id = 15;
    elseif (min(p16)<= bestMatch) && (bestMatch <= max(p16))
        id = 16;
    else
        id = 0;
    end

% diplay image of best match
%     figure
%     subplot(1,2,1)
%     imshow(im)
%     subplot(1,2,2)
%     found = (imread(strcat('database/img (', int2str(bestMatch), ').jpg')));
%     imshow(found)
end

