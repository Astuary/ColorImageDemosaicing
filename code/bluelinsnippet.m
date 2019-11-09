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