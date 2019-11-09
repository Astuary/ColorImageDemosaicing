% This code is part of:
%
%   CMPSCI 670: Computer Vision
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji

clear;

%Read test images
%img1 = imread('../data/disparity/poster_im2.jpg');
%img2 = imread('../data/disparity/poster_im6.jpg');

% Another pair of images
img1 = imread('../data/disparity/tsukuba_im1.jpg');
img2 = imread('../data/disparity/tsukuba_im5.jpg');

%Compute depth
depth = depthFromStereo(img1, img2);

%Show result
figure(1);
subplot(1,2,1);
imshow(img1);
title('Input image');
subplot(1,2,2);
imshow(depth); colormap gray;
title('Estimated depth map');
