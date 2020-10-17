import numpy as np 
import cv2
import os
import glob

def read_image_folder(images_folder_path = './data/SET002/'):

    """
    Read all red, green, blue, nir, red edge images in a specific folder
    
    Args:
        images_folder_path (string): Images folder path.
    Ret: 
        masked: n x m x 5 np.array, double format
        
    """
    path = os.path.join(images_folder_path ,'*')
    files_list = np.sort(glob.glob(path))
    try:
        # Intenta leer en formato de la cámara Micasense Red Edge (b,g,r,re,n)
        blue, green, nir, red, red_edge = [np.double(cv2.imread(files_list[i], cv2.IMREAD_GRAYSCALE)) / 255.0 for i in range (len(files_list))]
    except:
        print('Error 01: There is a problem reading files, check for the correct images in path ' +  images_folder_path.upper())
        return False

    # all bands container
    masked = np.zeros(shape=(blue.shape[0], blue.shape[1], 5),dtype=(np.double))
    masked[:,:,0] = blue
    masked[:,:,1] = green
    masked[:,:,2] = red
    masked[:,:,3] = nir
    masked[:,:,4] = red_edge
    masked[masked<0] = 0
    
    return masked

def align_all_images(Masked):

    Masked_8 = np.uint8(Masked*255)
    height, width = Masked_8[:,:,0].shape
    orb_detector = cv2.ORB_create(5000) 
    matcher = cv2.BFMatcher(cv2.NORM_HAMMING, crossCheck = True) 
    transformed_img = np.copy(Masked_8)
    for image in range(1,5):
        kp1, d1 = orb_detector.detectAndCompute(transformed_img[:,:,image], None) 
        kp2, d2 = orb_detector.detectAndCompute(transformed_img[:,:,0], None) 

        matches = matcher.match(d1, d2) 
        matches.sort(key = lambda x: x.distance) 
        matches = matches[:int(len(matches)*90)] 
        no_of_matches = len(matches) 
        p1 = np.zeros((no_of_matches, 2)) 
        p2 = np.zeros((no_of_matches, 2)) 

        for i in range(len(matches)): 
            p1[i, :] = kp1[matches[i].queryIdx].pt 
            p2[i, :] = kp2[matches[i].trainIdx].pt 

            # Find the homography matrix. 
        homography, mask = cv2.findHomography(p1, p2, cv2.RANSAC) 

        transformed_img[:,:,image] = cv2.warpPerspective(transformed_img[:,:,image], homography, (width, height))

        return transformed_img