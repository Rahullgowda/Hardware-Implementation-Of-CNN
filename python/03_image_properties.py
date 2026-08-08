"""
==============================================================
Project : Single Layer Hardware CNN

Author  : Rahul Gowda

File    : 03_image_properties.py

Purpose :
Display image properties.

==============================================================
"""

# ==========================================================
# Import Libraries
# ==========================================================

import os
from PIL import Image
import numpy as np

# ==========================================================
# Dataset Path
# ==========================================================

TRAIN_PATH = r"D:\single layer hardware cnn project\dataset\train"

# ==========================================================
# Read First Image
# ==========================================================

classes = sorted(os.listdir(TRAIN_PATH))

first_class = classes[0]

class_path = os.path.join(TRAIN_PATH, first_class)

image_name = sorted(os.listdir(class_path))[0]

image_path = os.path.join(class_path, image_name)

image = Image.open(image_path)

image_array = np.array(image)

# ==========================================================
# Display Properties
# ==========================================================

print("=" * 60)
print("IMAGE PROPERTIES")
print("=" * 60)

print(f"Class            : {first_class}")
print(f"Image Name       : {image_name}")
print(f"Image Size       : {image.size}")
print(f"Image Width      : {image.width}")
print(f"Image Height     : {image.height}")
print(f"Color Mode       : {image.mode}")
print(f"Image Format     : {image.format}")
print(f"Array Shape      : {image_array.shape}")
print(f"Data Type        : {image_array.dtype}")
print(f"Minimum Pixel    : {image_array.min()}")
print(f"Maximum Pixel    : {image_array.max()}")

print("=" * 60)