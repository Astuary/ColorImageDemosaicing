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