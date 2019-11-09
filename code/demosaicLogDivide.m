%------------------------------------------------
% Tranformed Color Space Divide and Log
%------------------------------------------------

function mosim = demosaicLogDivide(im)
    % Get dimensions of the filter values
    [imageWidth, imageHeight] = size(im);
    
    % We will use Adaptive Gradient for Green Channel Interpolation
    mosim = demosaicAdagrad(im);
    greenChannel = mosim(:,:,2);
    
    % Get Red Filter Values
    redValues = zeros(imageWidth, imageHeight);
    redValues(1:2:imageWidth, 1:2:imageHeight) = im(1:2:imageWidth, 1:2:imageHeight);
    % Divide Red Filter values with Interpolated Green Channel; add 1 and
    % take log of it so log(0) situation doesn't occur
    redValues = log(redValues ./ greenChannel + 1);
    
    % Get Blue Filter Values
    blueValues = zeros(imageWidth, imageHeight);
    blueValues(2:2:imageWidth, 2:2:imageHeight) = im(2:2:imageWidth, 2:2:imageHeight);
    % Divide Blue Filter values with Interpolated Green Channel; add 1 and
    % take log of it so log(0) situation doesn't occur
    blueValues = log(blueValues ./ greenChannel + 1);
    
    % We will get Green Filter only values from the filter again, to make a new filter
    greenValues = zeros(imageWidth, imageHeight);
    greenValues(1:2:imageWidth, 2:2:imageHeight) = im(1:2:imageWidth, 2:2:imageHeight);
    greenValues(2:2:imageWidth, 1:2:imageHeight) = im(2:2:imageWidth, 1:2:imageHeight);
    
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
    
end