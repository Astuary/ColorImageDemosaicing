# This code is part of:
#
#   CMPSCI 670: Computer Vision, Fall 2018
#   University of Massachusetts, Amherst
#   Instructor: Subhransu Maji

import numpy as np
from utils import *
from mosaicImage import *
from demosaicImage import *

def runDemosaicing(imgpath, method, display):
    ''' Simulates mosaicing and demosaicing.

    Args:
        imgpath : str
            Path to an image.
        method : str
            'baseline' or 'nn'.
        display : bool
            True if one wishes to see demosaicing results and error.
            False otherwise.

    Returns:
        (error, output) : (float, np.array)
            Error and demosaiced image.

    '''

    #Load ground truth image
    gt = imread(imgpath)
    #Create a mosaiced image
    input_img = mosaicImage(gt.copy())
    #Compute a demosaiced image
    output = demosaicImage(input_img, method)
    #Sanity check.
    assert (output.shape == gt.shape)

    #Compute error.
    pixel_error = np.abs(gt - output)
    error = pixel_error.mean()

    #Visualize errors if display is set.
    if display:
        plt.figure(1)
        plt.clf()

        plt.subplot(131)
        plt.title('Input image'); plt.imshow(gt); plt.axis('off')

        plt.subplot(132) 
        plt.title('Output'); plt.imshow(output); plt.axis('off')

        plt.subplot(133) 
        plt.title('Error'); plt.imshow(pixel_error); plt.axis('off')

        plt.show()
    
    return error, output
