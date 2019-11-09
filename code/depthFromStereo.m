function depth = depthFromStereo(img1, img2, ws)
% Implement this

% We take mean of all three channels of the first and second images to get a grayscale approximation of the images
img1_m = mean(img1, 3);
img2_m = mean(img2, 3);
% Initialize depth mean to all zeros
depth = zeros(size(img1_m, 1), size(img1_m, 2), 'uint8');

% Keep the search within this range away from boundary
range = 50;
% Patch Box size
patch_size = 5;

[row, col] = size(img1_m);

% Traverse through all Epipolar Lines
for i = 1:row
    
    % Boundary and Index range checks
    row_min = max(1, i - patch_size);
    row_max = min(row, i + patch_size);

    % For each pixel on epipolar lines
    for j = 1:col
        
        % Set the patch sizes according to boudary ranges
        col_min = max(1, j - patch_size);
        col_max = min(col, j + patch_size);

        % Patch box dimensions/ locations
        pix_min = max(-range, 1 - col_min);
        pix_max = min(range, col - col_max);

        % Temporary Patch Box
        t = img2_m(row_min:row_max, col_min:col_max);
        
        % An array storing the SSD (Sum of Squared Difference)
        count = pix_max - pix_min + 1;
        diff = zeros(count, 1);

        % Match the image patches on an epipolar line
        for k = pix_min : pix_max
            block = img1_m(row_min:row_max, (col_min+k):(col_max+k));
            index = k - pix_min + 1;
            diff(index, 1) = sumsqr(t - block);
        end

        % Get the pixel location where the patch disparity is the smallest
        [x, y] = sort(diff);
        m_index = y(1, 1);
        disparity = m_index + pix_min - 1;
        % Calculate the depth for that specific pixel
        depth(i, j) = 1/disparity;
        depth = imadjust(depth);
    end
end




