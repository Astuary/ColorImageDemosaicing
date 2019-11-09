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