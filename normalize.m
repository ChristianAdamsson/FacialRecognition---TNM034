function [out] = normalize(in)

% skin & eye detection
[out1, leftEye, rightEye] = eyeRecognition(in);

% rotate, scale & translate
scaled = scaling(in, leftEye, rightEye);

% normalize the intensity for the feature extraction
gray = (rgb2gray(scaled));
meanValue = mean2(gray);
desiredMean = 0.5;

if meanValue > 0
    out = gray*(desiredMean/meanValue);
else
    out = gray;
    "dis is black, like my soul"
end

% 
% HGRAM = ones(1,256);
% out = histeq(out, HGRAM);

% perform highboost filtering (like high pass but keep low freq details) 

[b,a] = butter(4,0.8);
lowPass = filter(b,a,out);

unsharpMask = out - lowPass;
out = out + 2.5*unsharpMask;

% out = normalizeChannel(out);

% figure
% imshow(out)


end

