function output = demosaicImage(im, method)
% DEMOSAICIMAGE computes the color image from mosaiced input
%   OUTPUT = DEMOSAICIMAGE(IM, METHOD) computes a demosaiced OUTPUT from
%   the input IM. The choice of the interpolation METHOD can be 
%   'baseline', 'nn', 'linear', 'adagrad'. 
%
% This code is part of:
%
%   CMPSCI 670: Computer Vision
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%

switch lower(method)
    case 'baseline'
        output = demosaicBaseline(im);
    case 'nn'
        output = demosaicNN(im);         % Implement this
    case 'linear'
        output = demosaicLinear(im);     % Implement this
    case 'adagrad'
        output = demosaicAdagrad(im);    % Implement this
end
end

%--------------------------------------------------------------------------
%                          Baseline demosacing algorithm. 
%                          The algorithm replaces missing values with the
%                          mean of each color channel.
%--------------------------------------------------------------------------
function mosim = demosaicBaseline(im)
mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
[imageHeight, imageWidth] = size(im);

% Red channel (odd rows and columns);
redValues = im(1:2:imageHeight, 1:2:imageWidth);
meanValue = mean(mean(redValues));
mosim(:,:,1) = meanValue;
mosim(1:2:imageHeight, 1:2:imageWidth,1) = im(1:2:imageHeight, 1:2:imageWidth);

% Blue channel (even rows and colums);
blueValues = im(2:2:imageHeight, 2:2:imageWidth);
meanValue = mean(mean(blueValues));
mosim(:,:,3) = meanValue;
mosim(2:2:imageHeight, 2:2:imageWidth,3) = im(2:2:imageHeight, 2:2:imageWidth);

% Green channel (remaining places)
% We will first create a mask for the green pixels (+1 green, -1 not green)
mask = ones(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = -1;
mask(2:2:imageHeight, 2:2:imageWidth) = -1;
greenValues = mosim(mask > 0);
meanValue = mean(greenValues);
% For the green pixels we copy the value
greenChannel = im;
greenChannel(mask < 0) = meanValue;
mosim(:,:,2) = greenChannel;
end 
%--------------------------------------------------------------------------
%                           Nearest neighbour algorithm
%--------------------------------------------------------------------------
function mosim = demosaicNN(im)
%mosim = demosaicBaseline(im);
%
% Implement this 
%
mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
[imageHeight, imageWidth] = size(im);

% Red channel (odd rows and columns);
redValues = ones(imageHeight, imageWidth)*-1;
redValues(1:2:imageHeight, 1:2:imageWidth) = im(1:2:imageHeight, 1:2:imageWidth);
for i = 1:2:imageHeight
    for j = 1:2:imageWidth
        if( i + 1 <= imageHeight)
            redValues(i+1, j) = redValues(i, j);
        end
        if( j + 1 <= imageWidth)
            redValues(i, j+1) = redValues(i, j);
        end
        if( j + 1 <= imageWidth && i + 1 <= imageHeight)
            redValues(i+1, j+1) = redValues(i, j);
        end
    end
end
%mosim(:, :, 1) = padarray(redValues, [1, 1], 'replicate', 'post');
mosim(:, :, 1) = redValues;

% Blue channel (odd rows and columns);
blueValues = ones(imageHeight, imageWidth)*-1;
blueValues(2:2:imageHeight, 2:2:imageWidth) = im(2:2:imageHeight, 2:2:imageWidth);
for i = 2:2:imageHeight
    for j = 2:2:imageWidth
        if( i + 1 <= imageHeight)
            blueValues(i+1, j) = blueValues(i, j);
        end
        if( j + 1 <= imageWidth)
            blueValues(i, j+1) = blueValues(i, j);
        end
        if( j + 1 <= imageWidth && i + 1 <= imageHeight)
            blueValues(i+1, j+1) = blueValues(i, j);
        end
    end
end
blueValues(1,:) = blueValues(2,:);
blueValues(:,1) = blueValues(:,2);
mosim(:, :, 3) = blueValues;

% Green channel 
greenValues = ones(imageHeight, imageWidth)*-1;
greenValues(1:2:imageHeight, 2:2:imageWidth) = im(1:2:imageHeight, 2:2:imageWidth);
greenValues(2:2:imageHeight, 1:2:imageWidth) = im(2:2:imageHeight, 1:2:imageWidth);

for i = 1:2:imageHeight
    for j = 2:2:imageWidth
        if (i - 1 > 0)
            greenValues(i - 1, j) = greenValues(i, j);
        end
    end
end

for i = 2:2:imageHeight
    for j = 1:2:imageWidth
        if (i + 1 <= imageHeight)
            greenValues(i + 1, j) = greenValues(i, j);
        end
    end
end

mosim(:, :, 2) = greenValues;

end

%--------------------------------------------------------------------------
%                           Linear interpolation
%--------------------------------------------------------------------------
function mosim = demosaicLinear(im)
%mosim = demosaicBaseline(im);
%
% Implement this 
%
mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
[imageWidth, imageHeight] = size(im);

% Red channel (odd rows and columns);
redValues = ones(imageWidth, imageHeight)*-1;
redMask = zeros(imageWidth, imageHeight);
redValues(1:2:imageWidth, 1:2:imageHeight) = im(1:2:imageWidth, 1:2:imageHeight);
redMask(1:2:imageWidth, 1:2:imageHeight) = 1;

for i = 1:imageWidth
    for j = 1:imageHeight
        if redValues(i, j) == -1
            count = 0;
            sum = 0;
            if (i - 1 > 0)
                sum = sum + redValues(i-1, j)*redMask(i-1, j);
                count = count + 1*redMask(i-1, j);
                if (j + 1 <= imageHeight)
                    sum = sum + redValues(i-1, j+1)*redMask(i-1, j+1);
                    count = count + 1*redMask(i-1, j+1);
                end
                if (j - 1 > 0)
                    sum = sum + redValues(i-1, j-1)*redMask(i-1, j-1);
                    count = count + 1*redMask(i-1, j-1);
                end
            end
            if (i + 1 <= imageWidth)
                sum = sum + redValues(i+1, j)*redMask(i+1, j);
                count = count + 1*redMask(i+1, j);
                if (j + 1 <= imageHeight)
                    sum = sum + redValues(i+1, j+1)*redMask(i+1, j+1);
                    count = count + 1*redMask(i+1, j+1);
                end
                if (j - 1 > 0)
                    sum = sum + redValues(i+1, j-1)*redMask(i+1, j-1);
                    count = count + 1*redMask(i+1, j-1);
                end
            end
            if (j + 1 <= imageHeight)
                sum = sum + redValues(i, j+1)*redMask(i, j+1);
                count = count + 1*redMask(i, j+1);
            end
            if (j - 1 > 0)
                sum = sum + redValues(i, j-1)*redMask(i, j-1);
                count = count + 1*redMask(i, j-1);
            end
            
            redValues(i, j) = sum/count;
        end
    end
end
mosim(:, :, 1) = redValues;

% Blue channel (odd rows and columns);
blueValues = ones(imageWidth, imageHeight)*-1;
blueMask = zeros(imageWidth, imageHeight);
blueValues(2:2:imageWidth, 2:2:imageHeight) = im(2:2:imageWidth, 2:2:imageHeight);
blueMask(2:2:imageWidth, 2:2:imageHeight) = 1;

for i = 1:imageWidth
    for j = 1:imageHeight
        if blueValues(i, j) == -1
            count = 0;
            sum = 0;
            if (i - 1 > 0)
                sum = sum + blueValues(i-1, j)*blueMask(i-1, j);
                count = count + 1*blueMask(i-1, j);
                if (j + 1 <= imageHeight)
                    sum = sum + blueValues(i-1, j+1)*blueMask(i-1, j+1);
                    count = count + 1*blueMask(i-1, j+1);
                end
                if (j - 1 > 0)
                    sum = sum + blueValues(i-1, j-1)*blueMask(i-1, j-1);
                    count = count + 1*blueMask(i-1, j-1);
                end
            end
            if (i + 1 <= imageWidth)
                sum = sum + blueValues(i+1, j)*blueMask(i+1, j);
                count = count + 1*blueMask(i+1, j);
                if (j + 1 <= imageHeight)
                    sum = sum + blueValues(i+1, j+1)*blueMask(i+1, j+1);
                    count = count + 1*blueMask(i+1, j+1);
                end
                if (j - 1 > 0)
                    sum = sum + blueValues(i+1, j-1)*blueMask(i+1, j-1);
                    count = count + 1*blueMask(i+1, j-1);
                end
            end
            if (j + 1 <= imageHeight)
                sum = sum + blueValues(i, j+1)*blueMask(i, j+1);
                count = count + 1*blueMask(i, j+1);
            end
            if (j - 1 > 0)
                sum = sum + blueValues(i, j-1)*blueMask(i, j-1);
                count = count + 1*blueMask(i, j-1);
            end
            
            blueValues(i, j) = sum/count;
        end
    end
end
mosim(:, :, 3) = blueValues;

% Green channel 
greenValues = ones(imageWidth, imageHeight)*-1;
greenMask = zeros(imageWidth, imageHeight);
greenValues(1:2:imageWidth, 2:2:imageHeight) = im(1:2:imageWidth, 2:2:imageHeight);
greenMask(1:2:imageWidth, 2:2:imageHeight) = 1;
greenValues(2:2:imageWidth, 1:2:imageHeight) = im(2:2:imageWidth, 1:2:imageHeight);
greenMask(2:2:imageWidth, 1:2:imageHeight) = 1;

for i = 1:imageWidth
    for j = 1:imageHeight
        if greenValues(i, j) == -1
            count = 0;
            sum = 0;
            if (i - 1 > 0)
                sum = sum + greenValues(i-1, j)*greenMask(i-1, j);
                count = count + 1*greenMask(i-1, j);
            end
            if (i + 1 <= imageWidth)
                sum = sum + greenValues(i+1, j)*greenMask(i+1, j);
                count = count + 1*greenMask(i+1, j);
            end
            if (j + 1 <= imageHeight)
                sum = sum + greenValues(i, j+1)*greenMask(i, j+1);
                count = count + 1*greenMask(i, j+1);
            end
            if (j - 1 > 0)
                sum = sum + greenValues(i, j-1)*greenMask(i, j-1);
                count = count + 1*greenMask(i, j-1);
            end
            
            greenValues(i, j) = sum/count;
        end
    end
end
mosim(:, :, 2) = greenValues;

end

%--------------------------------------------------------------------------
%                           Adaptive gradient
%--------------------------------------------------------------------------
function mosim = demosaicAdagrad(im)
%mosim = demosaicBaseline(im);
%
% Implement this 
%
mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
[imageWidth, imageHeight] = size(im);

redValues = zeros(imageWidth, imageHeight);
redValues(1:2:imageWidth, 1:2:imageHeight) = im(1:2:imageWidth, 1:2:imageHeight);

blueValues = zeros(imageWidth, imageHeight);
blueValues(2:2:imageWidth, 2:2:imageHeight) = im(2:2:imageWidth, 2:2:imageHeight);

greenValues = zeros(imageWidth, imageHeight);
greenValues(1:2:imageWidth, 2:2:imageHeight) = im(1:2:imageWidth, 2:2:imageHeight);
greenValues(2:2:imageWidth, 1:2:imageHeight) = im(2:2:imageWidth, 1:2:imageHeight);
end