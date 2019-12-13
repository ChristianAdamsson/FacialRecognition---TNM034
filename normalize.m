function [out] = normalize(in)

% skin & eye detection
[~, leftEye, rightEye] = eyeRecognition(in);

% rotate, scale & translate
scaled = scaling(in, leftEye, rightEye);

% normalize the intensity for the feature extraction    - easy gray world
gray = (rgb2gray(scaled));
meanValue = mean2(gray);
desiredMean = 0.5;

if meanValue > 0
    out = gray*(desiredMean/meanValue);
else
    out = gray;
end


[b,a] = butter(4,0.8);
lowPass = filter(b,a,out);

unsharpMask = out - lowPass;
out = out + 2.5*unsharpMask;


end

