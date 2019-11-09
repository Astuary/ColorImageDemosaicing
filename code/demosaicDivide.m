%------------------------------------------------
% Tranformed Color Space Divide
%------------------------------------------------
function mosim = demosaicDivide(im)
    % Get dimensions of the filter values
    [imageWidth, imageHeight] = size(im);
    
    % We will use Adaptive Gradient for Green Channel Interpolation
    mosim = demosaicAdagrad(im);
    greenChannel = mosim(:,:,2);
    
    % Get Red Filter Values
    redValues = zeros(imageWidth, imageHeight);
    redValues(1:2:imageWidth, 1:2:imageHeight) = im(1:2:imageWidth, 1:2:imageHeight);
    % Divide Red Filter values with Interpolated Green Channel
    redValues = redValues ./ greenChannel;
    
    % Get Blue Filter Values
    blueValues = zeros(imageWidth, imageHeight);
    blueValues(2:2:imageWidth, 2:2:imageHeight) = im(2:2:imageWidth, 2:2:imageHeight);
    % Divide Blue Filter values with Interpolated Green Channel
    blueValues = blueValues ./ greenChannel;
    
    % We will get Green Filter only values from the filter again, to make a new filter
    greenValues = zeros(imageWidth, imageHeight);
    greenValues(1:2:imageWidth, 2:2:imageHeight) = im(1:2:imageWidth, 2:2:imageHeight);
    greenValues(2:2:imageWidth, 1:2:imageHeight) = im(2:2:imageWidth, 1:2:imageHeight);
    
    % Create the new filter with updated red and blue values
    im_new = redValues + greenValues + blueValues;
        
    % Get the interpolated RGB Channels
    mosim = demosaicAdagrad(im_new);
    
    % Multiply Red Filter values with Interpolated Green Channel
    mosim(:,:,1) = mosim(:,:,1) .* greenChannel;
    % Multiply Blue Filter values with Interpolated Green Channel
    mosim(:,:,3) = mosim(:,:,3) .* greenChannel;
    
end


