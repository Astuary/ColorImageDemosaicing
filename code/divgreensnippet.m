% We will use Adaptive Gradient for Green Channel Interpolation
mosim = demosaicAdagrad(im);
greenChannel = mosim(:,:,2);