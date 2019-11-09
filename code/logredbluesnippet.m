% Get Red Filter Values
redValues = zeros(imageWidth, imageHeight);
redValues(1:2:imageWidth, 1:2:imageHeight) = im(1:2:imageWidth, 1:2:imageHeight);
% Divide Red Filter values with Interpolated Green Channel; add 1 and
% take log of it so log(0) situation doesn't occur
redValues = log(redValues ./ greenChannel + 1);
redValues = rescale(redValues);

% Get Blue Filter Values
blueValues = zeros(imageWidth, imageHeight);
blueValues(2:2:imageWidth, 2:2:imageHeight) = im(2:2:imageWidth, 2:2:imageHeight);
% Divide Blue Filter values with Interpolated Green Channel; add 1 and
% take log of it so log(0) situation doesn't occur
blueValues = log(blueValues ./ greenChannel + 1);
blueValues = rescale(blueValues);