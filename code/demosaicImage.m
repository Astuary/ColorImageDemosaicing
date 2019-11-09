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
    case 'divide'
        output = demosaicDivide(im);
    case 'logdivide'
        output = demosaicLogDivide(im);    
end
end

%------------------------------------------------
% Baseline demosacing algorithm. 
% The algorithm replaces missing values with the
%  mean of each color channel.
%------------------------------------------------
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

%------------------------------------------------
% Nearest neighbour algorithm
%------------------------------------------------
function mosim = demosaicNN(im)
%
% Implement this 
%
mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
[imageHeight, imageWidth] = size(im); % Got size of the image

%% Red channel (odd rows and columns);

% Initialize the resultant red channel to all the -1 values
redValues = ones(imageHeight, imageWidth)*-1;
% Put the already known red values to the resultant image corresponding pixels
redValues(1:2:imageHeight, 1:2:imageWidth) = im(1:2:imageHeight, 1:2:imageWidth);

% For every alternate row, starting from 1st row
for i = 1:2:imageHeight
    % For every alternate column, starting from 1st column
    for j = 1:2:imageWidth
        % Put the same value as that of known pixel's, to the pixel at right
        if( i + 1 <= imageHeight)
            redValues(i+1, j) = redValues(i, j);
        end
        % Put the same value as that of known pixel's, to the pixel at bottom
        if( j + 1 <= imageWidth)
            redValues(i, j+1) = redValues(i, j);
        end
        % Put the same value as that of known pixel's, to the pixel at bottom right
        if( j + 1 <= imageWidth && i + 1 <= imageHeight)
            redValues(i+1, j+1) = redValues(i, j);
        end
    end
end

%mosim(:, :, 1) = padarray(redValues, [1, 1], 'replicate', 'post');
% Make the interpolated red value matrix, the red channel of the final output image
mosim(:, :, 1) = redValues;

%% Blue channel (even rows and columns);

% Initialize the resultant blue channel to all the -1 values
blueValues = ones(imageHeight, imageWidth)*-1;

% Put the already known blue values to the resultant image corresponding pixels
blueValues(2:2:imageHeight, 2:2:imageWidth) = im(2:2:imageHeight, 2:2:imageWidth);

% For every alternate row, starting from 2nd row
for i = 2:2:imageHeight
    % For every alternate column, starting from 2nd column
    for j = 2:2:imageWidth
        % Put the same value as that of known pixel's, to the pixel at right
        if( i + 1 <= imageHeight)
            blueValues(i+1, j) = blueValues(i, j);
        end
        % Put the same value as that of known pixel's, to the pixel at bottom
        if( j + 1 <= imageWidth)
            blueValues(i, j+1) = blueValues(i, j);
        end
        % Put the same value as that of known pixel's, to the pixel at bottom right
        if( j + 1 <= imageWidth && i + 1 <= imageHeight)
            blueValues(i+1, j+1) = blueValues(i, j);
        end
    end
end

% For the first row, copy the values from 2nd row, they are the "nearest" 
blueValues(1,:) = blueValues(2,:);
% For the first column, copy the values from 2nd column, they are the "nearest" 
blueValues(:,1) = blueValues(:,2);
% Make the interpolated blue value matrix, the blue channel of the final output image
mosim(:, :, 3) = blueValues;

%% Green channel 

% Initialize the resultant green channel to all the -1 values
greenValues = ones(imageHeight, imageWidth)*-1;

% We put the already known green values to the resultant image corresponding pixels
% Odd rows have green pixel's known values at even columns 
greenValues(1:2:imageHeight, 2:2:imageWidth) = im(1:2:imageHeight, 2:2:imageWidth);
% Even rows have green pixel's known values at odd columns 
greenValues(2:2:imageHeight, 1:2:imageWidth) = im(2:2:imageHeight, 1:2:imageWidth);

% Odd rows
for i = 1:2:imageHeight
    % Even columns
    for j = 2:2:imageWidth
        % Put the same value as that of known pixel's, to the pixel at left
        if (i - 1 > 0)
            greenValues(i - 1, j) = greenValues(i, j);
        end
    end
end

% Even rows
for i = 2:2:imageHeight
    % Odd columns
    for j = 1:2:imageWidth
        % Put the same value as that of known pixel's, to the pixel at right
        if (i + 1 <= imageHeight)
            greenValues(i + 1, j) = greenValues(i, j);
        end
    end
end

% Make the interpolated green value matrix, the green channel of the final output image
mosim(:, :, 2) = greenValues;

end

%------------------------------------------------
% Linear interpolation
%------------------------------------------------
function mosim = demosaicLinear(im)
%
% Implement this 
%
mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
[imageWidth, imageHeight] = size(im);

%% Red channel (odd rows and columns);
% Initialize the resultant red channel to all the -1 values
redValues = ones(imageWidth, imageHeight)*-1;
% Create a mask which shows which pixels have known values and which are to be interpolated
redMask = zeros(imageWidth, imageHeight);
% Put the already known red values to the resultant image corresponding pixels
redValues(1:2:imageWidth, 1:2:imageHeight) = im(1:2:imageWidth, 1:2:imageHeight);
% Put mask value to 1/true where image pixels are already have known values
redMask(1:2:imageWidth, 1:2:imageHeight) = 1;

for i = 1:imageWidth
    for j = 1:imageHeight
        % If a pixel has its value yet to be interpolated
        if redValues(i, j) == -1
            count = 0;
            sum = 0;
            % Here we will just check all the 8 neighboring pixels. It will
            % take care of all the cases (diagonal, horizontal and
            % vertical) as only the redMask = 1 values will hold any
            % weight. Others will be simply 0 and won't contribute if a
            % case doesn't apply for them
            
            % Checking for 3 neighboring pixels at left side
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
            
            % Checking for 3 neighboring pixels at right side
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
            
            % Checking for neighboring pixel at bottom
            if (j + 1 <= imageHeight)
                sum = sum + redValues(i, j+1)*redMask(i, j+1);
                count = count + 1*redMask(i, j+1);
            end
            
            % Checking for neighboring pixel at top
            if (j - 1 > 0)
                sum = sum + redValues(i, j-1)*redMask(i, j-1);
                count = count + 1*redMask(i, j-1);
            end
            
            % Take the average of the sum of the values of neighboring pixels which have known
            % values
            redValues(i, j) = sum/count;
        end
    end
end
% Make the interpolated red value matrix, the red channel of the final output image
mosim(:, :, 1) = redValues;

%% Blue channel (even rows and columns);
% Initialize the resultant blue channel to all the -1 values
blueValues = ones(imageWidth, imageHeight)*-1;
% Create a mask which shows which pixels have known values and which are to be interpolated
blueMask = zeros(imageWidth, imageHeight);
% Put the already known blue values to the resultant image corresponding pixels
blueValues(2:2:imageWidth, 2:2:imageHeight) = im(2:2:imageWidth, 2:2:imageHeight);
% Put mask value to 1/true where image pixels are already have known values
blueMask(2:2:imageWidth, 2:2:imageHeight) = 1;

for i = 1:imageWidth
    for j = 1:imageHeight
        % If a pixel has its value yet to be interpolated
        if blueValues(i, j) == -1
            count = 0;
            sum = 0;
            % Here we will just check all the 8 neighboring pixels. It will
            % take care of all the cases (diagonal, horizontal and
            % vertical) as only the redMask = 1 values will hold any
            % weight. Others will be simply 0 and won't contribute if a
            % case doesn't apply for them
            
            % Checking for 3 neighboring pixels at left side
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
            
            % Checking for 3 neighboring pixels at right side
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
            
            % Checking for neighboring pixel at bottom
            if (j + 1 <= imageHeight)
                sum = sum + blueValues(i, j+1)*blueMask(i, j+1);
                count = count + 1*blueMask(i, j+1);
            end
            
            % Checking for neighboring pixel at top
            if (j - 1 > 0)
                sum = sum + blueValues(i, j-1)*blueMask(i, j-1);
                count = count + 1*blueMask(i, j-1);
            end
            
            % Take the average of the sum of the values of neighboring pixels which have known values
            blueValues(i, j) = sum/count;
        end
    end
end
% Make the interpolated blue value matrix, the blue channel of the final output image
mosim(:, :, 3) = blueValues;

%% Green channel 
% Initialize the resultant green channel to all the -1 values
greenValues = ones(imageWidth, imageHeight)*-1;
% Create a mask which shows which pixels have known values and which are to be interpolated
greenMask = zeros(imageWidth, imageHeight);
greenValues(1:2:imageWidth, 2:2:imageHeight) = im(1:2:imageWidth, 2:2:imageHeight);
greenMask(1:2:imageWidth, 2:2:imageHeight) = 1;
greenValues(2:2:imageWidth, 1:2:imageHeight) = im(2:2:imageWidth, 1:2:imageHeight);
greenMask(2:2:imageWidth, 1:2:imageHeight) = 1;

for i = 1:imageWidth
    for j = 1:imageHeight
        % If a pixel has its value yet to be interpolated
        if greenValues(i, j) == -1
            count = 0;
            sum = 0;
            % Here we will just check only 4 neighboring pixels [top,
            % bottom, left and right]. Becasuse at any unknown valued pixel
            % location, there will be the same pattern observed, which look
            % like as follows in the green mask:
            % 0 1 0
            % 1 0 1
            % 0 1 0
            
            % Averaging all 4 neighboring pixels 
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
            
            % Take the average of the sum of the values of neighboring pixels which have known values
            greenValues(i, j) = sum/count;
        end
    end
end
% Make the interpolated green value matrix, the green channel of the final output image
mosim(:, :, 2) = greenValues;

end

%------------------------------------------------
% Adaptive gradient
%------------------------------------------------
function mosim = demosaicAdagrad(im)
%
% Implement this 
%
[imageWidth, imageHeight] = size(im);
% Linear Interpolation of Red and Blue Channels
mosim = demosaicLinear(im);

%% Green channel 
% Initialize the resultant green channel to all the -1 values
greenValues = ones(imageWidth, imageHeight)*-1;
% Create a mask which shows which pixels have known values and which are to be interpolated
greenMask = zeros(imageWidth, imageHeight);
greenValues(1:2:imageWidth, 2:2:imageHeight) = im(1:2:imageWidth, 2:2:imageHeight);
greenMask(1:2:imageWidth, 2:2:imageHeight) = 1;
greenValues(2:2:imageWidth, 1:2:imageHeight) = im(2:2:imageWidth, 1:2:imageHeight);
greenMask(2:2:imageWidth, 1:2:imageHeight) = 1;

for i = 1:imageWidth
    for j = 1:imageHeight
        if greenValues(i, j) == -1
            sum_h = 0; abs_h = 0; sum_v = 0; abs_v = 0;
            
            % Finding left and right pixel values difference and sum for core, edge and corner cases
            if (i - 1 > 0 && i + 1 <= imageWidth)
                abs_h = abs(greenValues(i-1, j)*greenMask(i-1, j) - greenValues(i+1, j)*greenMask(i+1, j));
                sum_h = greenValues(i-1, j)*greenMask(i-1, j) + greenValues(i+1, j)*greenMask(i+1, j);
                sum_h = sum_h/2;
            elseif i - 1 > 0
                abs_h = greenValues(i-1, j)*greenMask(i-1, j);
                sum_h = greenValues(i-1, j)*greenMask(i-1, j);
            elseif i + 1 <= imageWidth
                abs_h = greenValues(i+1, j)*greenMask(i+1, j);
                sum_h = greenValues(i+1, j)*greenMask(i+1, j);
            end
            
            % Finding top and bottom pixel values difference and sum for core, edge and corner cases
            if (j - 1 > 0 && j + 1 <= imageHeight)
                abs_v = abs(greenValues(i, j+1)*greenMask(i, j+1) - greenValues(i, j-1)*greenMask(i, j-1));
                sum_v = greenValues(i, j+1)*greenMask(i, j+1) + greenValues(i, j-1)*greenMask(i, j-1);
                sum_v = sum_v/2;
            elseif j - 1 > 0
                abs_v = greenValues(i, j-1)*greenMask(i, j-1);
                sum_v = greenValues(i, j-1)*greenMask(i, j-1);
            elseif j + 1 <= imageHeight
                abs_v = greenValues(i, j+1)*greenMask(i, j+1);
                sum_v = greenValues(i, j+1)*greenMask(i, j+1);
            end
                 
            % Choose which value to adapt
            if abs_v > abs_h
                greenValues(i, j) = sum_h;
            else 
                greenValues(i, j) = sum_v;
            end
        end
    end
end
% Make the interpolated green value matrix, the green channel of the final output image
mosim(:, :, 2) = greenValues;
end

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
