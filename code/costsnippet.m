%% Normalized Correlation

% t = patch of the first image whose counterpart we want to find in second image, on the same epipolar line
% width = width of the image/ length of the epipolar line
% block = patch of the second image, it will be each patch on the epipolar line of the second image

% We are dividing the sum of the difference between two patches by the
% square roots of the variances of each patch
norm_corr(index, 1) = (1 / width) * (sum(t - mean(block))/sqrt(var(t)*var(block)));

%% Sum of Squarred Differences
diff(index, 1) = sumsqr(t - block);