# learning-guided-SEM
Code for "Learning Guided Electron Microscopy with Active Acquisition, MICCAI 2020"

### authors
Lu Mi^1, Hao Wang^1, Yaron Meirovitch^2, Richard Schalek^2, Srinivas Turaga^3, Jeff Lichtman^2, Aravinthan Samuel^2, Nir Shavit^1

1 MIT, 2 Harvard, 3 Janelia

### contact
corresponding email: lumi@mit.edu

## Abstract

Single-beam scanning electron microscopes (SEM) are widely used to acquire massive data sets for biomedical study, material analysis, and fabrication inspection. Datasets are typically acquired with uniform acquisition: applying the electron beam with the same power and duration to all image pixels, even if there is great variety in the pixels' importance for eventual use. Many SEMs are now able to move the beam to any pixel in the field of view without delay, enabling them, in principle, to invest their time budget more effectively with non-uniform imaging.    

In this paper, we show how to use deep learning to accelerate and optimize single-beam SEM acquisition of images. Our algorithm rapidly collects an information-lossy image (e.g. low resolution) and then applies a novel learning method to identify a small subset of pixels to be collected at higher resolution based on a trade-off between the saliency and spatial diversity. We demonstrate the efficacy of this novel technique for active acquisition by speeding up the task of collecting connectomic datasets for neurobiology by up to an order of magnitude.

## Overview:
### Reconstruction: 
pixel2pixel, Isola et. al (https://phillipi.github.io/pix2pix/)

code base: https://github.com/affinelayer/pix2pix-tensorflow

Dependencies: Tensorflow 1.4.1

### Binarized Error Estimation:
coming soon...

### WDPP:
code built based on DPP from https://www.alexkulesza.com/

Dependencies: matlab
