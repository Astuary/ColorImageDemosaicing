function R = visualizeInformation(im)
    %im = imread('../data/disparity/tsukuba_im1.jpg');
    im = imread('../data/disparity/poster_im2.jpg');
    [width, height, c] = size(im);
    % Converting image to grayscale because color channels don't matter for second-moment matrix, just the corresponding relative pixel values.
    im = rgb2gray(im);
    % Radius
    r = 5;
    % Informative Patch
    R = zeros(width, height, 'uint8');
    
    % For each pixel
    for u = 1: width-r-1
        for v = 1:height-r-1
            % Computer Ixx, Ixy and Iyy for the given neighbors in the window
            Ixx = 0; Ixy = 0; Iyy = 0;
            for i = 1:r
                for j = 1:r
                   Ix = im(u + i + 1, v) - im(u + i, v);
                   Iy = im(u, v + i + 1) - im(u, v + i);
                   Ixx = Ixx + Ix*Ix;
                   Ixy = Ixy + Ix*Iy;
                   Iyy = Iyy + Iy*Iy;                   
                end
            end
            % Computer R
            R(u, v) = Ixx*Iyy - 0.03*(Ixx + Iyy)*(Ixx + Iyy);
        end
    end
    figure;
    subplot(121); imshow(im);
    subplot(122); imshow(imcomplement(R)); colorbar;
    figure;
    imshow(imcomplement(R));
end
