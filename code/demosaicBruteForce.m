function error = demosaicBruteForce(im)

[imageWidth, imageHeight, channels] = size(im);
im = double(im);
c = 1;
error = zeros(81, 1);
% Try every permutation
for p = 1:3
    for q = 1:3
        for r = 1:3
            for s = 1:3
                % 2 x 2 Grid
                temp = [p, q, r, s];
                % Create Masks, 1 = R, 2 = G, 3 = B
                imageMask = repmat(reshape(temp, [2, 2]), round(imageWidth/2), round(imageHeight/2));
                redMask = imageMask==1;
                redMask = redMask>0;
                
                greenMask = imageMask==2;
                greenMask = greenMask>0;
                
                blueMask = imageMask==3;
                blueMask = blueMask>0;
                        
                redValues = im(:,:,1);
                greenValues = im(:,:,2);
                blueValues = im(:,:,3);
                
                % Linear Interpolation
                for i = 1:imageWidth
                    for j = 1:imageHeight
                        if redMask(i, j) == 0
                            count = 0;
                            sum = 0;
                            if (i - 1 > 0)
                                sum = sum + redValues(i-1, j)*uint8(redMask(i-1, j));
                                count = count + 1*uint8(redMask(i-1, j));
                                if (j + 1 <= imageHeight)
                                    sum = sum + redValues(i-1, j+1)*uint8(redMask(i-1, j+1));
                                    count = count + 1*uint8(redMask(i-1, j+1));
                                end
                                if (j - 1 > 0)
                                    sum = sum + redValues(i-1, j-1)*uint8(redMask(i-1, j-1));
                                    count = count + 1*uint8(redMask(i-1, j-1));
                                end
                            end
                            if (i + 1 <= imageWidth)
                                sum = sum + redValues(i+1, j)*uint8(redMask(i+1, j));
                                count = count + 1*uint8(redMask(i+1, j));
                                if (j + 1 <= imageHeight)
                                    sum = sum + redValues(i+1, j+1)*uint8(redMask(i+1, j+1));
                                    count = count + 1*uint8(redMask(i+1, j+1));
                                end
                                if (j - 1 > 0)
                                    sum = sum + redValues(i+1, j-1)*uint8(redMask(i+1, j-1));
                                    count = count + 1*uint8(redMask(i+1, j-1));
                                end
                            end
                            if (j + 1 <= imageHeight)
                                sum = sum + redValues(i, j+1)*uint8(redMask(i, j+1));
                                count = count + 1*uint8(redMask(i, j+1));
                            end
                            if (j - 1 > 0)
                                sum = sum + redValues(i, j-1)*uint8(redMask(i, j-1));
                                count = count + 1*uint8(redMask(i, j-1));
                            end

                            redValues(i, j) = sum/count;
                        end
                    end
                end
                mosim(:, :, 1) = redValues;

                for i = 1:imageWidth
                    for j = 1:imageHeight
                        if blueMask(i, j) == 0
                            count = 0;
                            sum = 0;
                            if (i - 1 > 0)
                                sum = sum + blueValues(i-1, j)*uint8(blueMask(i-1, j));
                                count = count + 1*uint8(blueMask(i-1, j));
                                if (j + 1 <= imageHeight)
                                    sum = sum + blueValues(i-1, j+1)*uint8(blueMask(i-1, j+1));
                                    count = count + 1*uint8(blueMask(i-1, j+1));
                                end
                                if (j - 1 > 0)
                                    sum = sum + blueValues(i-1, j-1)*uint8(blueMask(i-1, j-1));
                                    count = count + 1*uint8(blueMask(i-1, j-1));
                                end
                            end
                            if (i + 1 <= imageWidth)
                                %blueValues(i+1, j)
                                %uint8(blueMask(i+1, j))
                                %i + 1
                                sum = sum + blueValues(i+1, j)*uint8(blueMask(i+1, j));
                                count = count + 1*uint8(blueMask(i+1, j));
                                if (j + 1 <= imageHeight)
                                    sum = sum + blueValues(i+1, j+1)*uint8(blueMask(i+1, j+1));
                                    count = count + 1*uint8(blueMask(i+1, j+1));
                                end
                                if (j - 1 > 0)
                                    sum = sum + blueValues(i+1, j-1)*uint8(blueMask(i+1, j-1));
                                    count = count + 1*uint8(blueMask(i+1, j-1));
                                end
                            end
                            if (j + 1 <= imageHeight)
                                sum = sum + blueValues(i, j+1)*uint8(blueMask(i, j+1));
                                count = count + 1*uint8(blueMask(i, j+1));
                            end
                            if (j - 1 > 0)
                                sum = sum + blueValues(i, j-1)*uint8(blueMask(i, j-1));
                                count = count + 1*uint8(blueMask(i, j-1));
                            end

                            blueValues(i, j) = sum/count;
                        end
                    end
                end
                mosim(:, :, 3) = blueValues;

                for i = 1:imageWidth
                    for j = 1:imageHeight
                        if greenMask(i, j) == 0
                            count = 0;
                            sum = 0;
                            if (i - 1 > 0)
                                sum = sum + greenValues(i-1, j)*uint8(greenMask(i-1, j));
                                count = count + 1*uint8(greenMask(i-1, j));
                            end
                            if (i + 1 <= imageWidth)
                                sum = sum + greenValues(i+1, j)*uint8(greenMask(i+1, j));
                                count = count + 1*uint8(greenMask(i+1, j));
                            end
                            if (j + 1 <= imageHeight)
                                sum = sum + greenValues(i, j+1)*uint8(greenMask(i, j+1));
                                count = count + 1*uint8(greenMask(i, j+1));
                            end
                            if (j - 1 > 0)
                                sum = sum + greenValues(i, j-1)*uint8(greenMask(i, j-1));
                                count = count + 1*uint8(greenMask(i, j-1));
                            end

                            greenValues(i, j) = sum/count;
                        end
                    end
                end
                mosim(:, :, 2) = greenValues;
                gt = im2double(im);

                pixelError = abs(gt - mosim);
                error(c) = mean(mean(mean(double(pixelError))));
 
                c = c + 1;
                
            end
        end
    end
end