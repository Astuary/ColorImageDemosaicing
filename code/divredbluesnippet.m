% Get Red Filter Values
redValues = zeros(imageWidth, imageHeight);
redValues(1:2:imageWidth, 1:2:imageHeight) = im(1:2:imageWidth, 1:2:imageHeight);
%Divide Red Filter values with Interpolated Green Channel
redValues = redValues ./ greenChannel;

%Get Blue Filter Values
blueValues = zeros(imageWidth, imageHeight);
blueValues(2:2:imageWidth, 2:2:imageHeight) = im(2:2:imageWidth, 2:2:imageHeight);
%Divide Blue Filter values with Interpolated Green Channel
blueValues = blueValues ./ greenChannel;