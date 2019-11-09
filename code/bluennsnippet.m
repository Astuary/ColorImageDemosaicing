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
