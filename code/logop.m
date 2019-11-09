% Create the new filter with updated red and blue values
im_new = redValues + greenValues + blueValues;

% Get the interpolated RGB Channels
mosim = demosaicAdagrad(im_new);

% Multiply Red Filter values with Interpolated Green Channel; take
% exponential to even out the log effect and add -1 because we had
% added +1 before taking log of the ratio

% exp(log(x + 1)) - 1 = x + 1 - 1 = x
mosim(:,:,1) = exp(mosim(:,:,1) .* greenChannel ) -1;
% Multiply Blue Filter values with Interpolated Green Channel
mosim(:,:,3) = exp(mosim(:,:,3) .* greenChannel ) -1;