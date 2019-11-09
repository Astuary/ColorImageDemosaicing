% Interpolation of Red pixels
mosim(:,:,1) = imfilter(redValues,[1,2,1; 2,4,2;1,2,1]/4);

% Interpolation of Blue pixels
mosim(:,:,3) = imfilter(blueValues,[1,2,1; 2,4,2;1,2,1]/4);

