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