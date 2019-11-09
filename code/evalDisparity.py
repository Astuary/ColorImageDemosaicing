# This code is part of:
#
#   CMPSCI 670: Computer Vision
#   University of Massachusetts, Amherst
#   Instructor: Subhransu Maji

import numpy as np
import matplotlib.pyplot as plt
from utils import imread
from depthFromStereo import depthFromStereo
import os

read_path = "../data/disparity/"
im_name1 = "tsukuba_im1.jpg" 
im_name2 = "tsukuba_im5.jpg"
#Read test images
img1 = imread(os.path.join(read_path, im_name1))
img2 = imread(os.path.join(read_path, im_name2))

#Compute depth
depth = depthFromStereo(img1, img2, 3)

#Show result
plt.imshow(depth)
plt.show()
save_path = "../output/disparity/"
save_file = "tsukuba.png"
if not os.path.isdir(save_path):
	os.makedirs(save_path)
plt.imsave(os.path.join(save_path, save_file), depth)


