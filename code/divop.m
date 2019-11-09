% Create the new filter with updated red and blue values
im_new = redValues + greenValues + blueValues;

% Get the interpolated RGB Channels
mosim = demosaicAdagrad(im_new);

% Multiply Red Filter values with Interpolated Green Channel
mosim(:,:,1) = mosim(:,:,1) .* greenChannel;
% Multiply Blue Filter values with Interpolated Green Channel
mosim(:,:,3) = mosim(:,:,3) .* greenChannel;