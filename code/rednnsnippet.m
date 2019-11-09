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