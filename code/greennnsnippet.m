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