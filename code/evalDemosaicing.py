# This code is part of:
#
#   CMPSCI 670: Computer Vision, Fall 2018
#   University of Massachusetts, Amherst
#   Instructor: Subhransu Maji
#

import os
import time
import numpy as np
import matplotlib.pyplot as plt 
import sys

from runDemosaicing import *
from utils import *

#Path to your data directory
data_dir = os.path.join('..', 'data', 'demosaic')

#Path to your output directory
out_dir = os.path.join('..', 'output', 'demosaic')
mkdir(out_dir)

#List of images
image_names = ['balloon.jpeg','cat.jpg', 'ip.jpg',
            'puppy.jpg', 'squirrel.jpg', 'pencils.jpg',
            'house.png', 'light.png', 'sails.png', 'tree.jpeg'];

#List of methods you have to implement
methods = ['baseline', 'nn', 'linear', 'adagrad'] #Add other methods to this list.

#Global variables.
display = True
error = np.zeros((len(image_names), len(methods)))

#Loop over methods and print results
sys.stdout.write('-'*50 + '\n')
sys.stdout.write('# \t image \t')
for m in methods:
    sys.stdout.write('\t {}'.format(m))
sys.stdout.write('\n')


sys.stdout.write('-'*50 + '\n')
for i, imgname in enumerate(image_names):
    sys.stdout.write('{} \t {}'.format(i, imgname))
    for j, m in enumerate(methods):
        imgpath = os.path.join(data_dir, imgname)
        err, color_img = runDemosaicing(imgpath, m, display)
        error[i, j] = err
        sys.stdout.write('\t {:9.6f}'.format(error[i, j]))

        #Write the output
        outfile_path = os.path.join(out_dir, '{}-{}-dmsc.png'.format(imgname[0:-4], m))
        plt.imsave(outfile_path, color_img)
    sys.stdout.write('\n')

#Compute average errors.
sys.stdout.write('-'*100 + '\n')
sys.stdout.write(' \t average ')
for j, m in enumerate(methods):
    sys.stdout.write('\t {:9.6f}'.format(error[:, j].mean()))
sys.stdout.write('\n')
sys.stdout.write('-'*100 + '\n')

