# This code is part of:
#
#   CMPSCI 670: Computer Vision, Spring 2018
#   University of Massachusetts, Amherst
#   Instructor: Subhransu Maji

import numpy as np

def mosaicImage(img):
    ''' Computes the mosaic of an image.

    mosaicImage computes the response of the image under a Bayer filter.

    Args:
        img: NxMx3 numpy array (image).

    Returns:
        NxM image where R, G, B channels are sampled according to RGRG in the
        top left.
    '''

    image_height, image_width, num_channels = img.shape
    assert(num_channels == 3) #Checks if it is a color image

    #Green channel. It will be overwritten by the red and blue.
    mos_img = img[:, :, 1]
    #Red channel (odds rows and columns)
    mos_img[0:image_height:2, 0:image_width:2] = img[0:image_height:2, 0:image_width:2, 0]
    #Blue channel (even rows and columns)
    mos_img[1:image_height:2, 1:image_width:2] = img[1:image_height:2, 1:image_width:2, 2]

    return mos_img

