function [out] = normalize(in)

%in = im2double(in);

% colour correct
%in = referenceWhite(in);

% skin & eye detection
[leftEye, rightEye] = eyeRecognition(in);

% rotate, scale & translate
out = scaling(in, leftEye, rightEye);

end

