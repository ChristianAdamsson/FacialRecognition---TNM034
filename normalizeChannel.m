function normalizedChannel = normalizeChannel(channel)
% Do not use if input channel has infinite values! 

normalizedChannel = (channel - min(channel(:))) / (max(channel(:)) - min(channel(:)));