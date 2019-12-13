% Lighting compensation - grey world assumption
%   https://se.mathworks.com/matlabcentral/fileexchange/40937-gray-world-colour-correction
%   - to normalize colour appearance 
%   - average of world is assumed to be grey
%   - scale image so that average value is
function [out] = greyWorldAssumption(in)
clc
[X,Y] = size(in(:,:,1));
out = zeros(size(in));    

% Find average grey
Ravg = sum( sum(in(:,:,1)))/numel(in(:,:,1) ); 
Gavg = sum( sum(in(:,:,2)))/numel(in(:,:,2) ); 
Bavg = sum( sum(in(:,:,3))/numel(in(:,:,3) ) );
avgGrey = mean([Ravg, Gavg, Bavg]);

% scale input with difference between average grey and real average
out(:,:,1) = in(:,:,1)*(avgGrey/Ravg);
out(:,:,2) = in(:,:,2)*(avgGrey/Gavg);
out(:,:,3) = in(:,:,3)*(avgGrey/Bavg);

for i=1:X
    for j=1:Y
        for k=1:3
            if in(i,j,k) > 255
                in(i,j,k) = 255;
            end
        end
    end
end

% transform output to uint8
out = uint8(out); 

end

