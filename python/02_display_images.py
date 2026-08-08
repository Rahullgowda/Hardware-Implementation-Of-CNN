"""
==============================================================
Project : Single Layer Hardware CNN

Author  : Rahul Gowda

File    : 02_display_images.py

Purpose :
Display one sample image from each class.

==============================================================
"""

# ==========================================================
# Import Libraries
# ==========================================================

import os
import matplotlib.pyplot as plt
from PIL import Image

# ==========================================================
# Dataset Path
# ==========================================================

TRAIN_PATH = r"D:\single layer hardware cnn project\dataset\train"

# ==========================================================
# Read Classes
# ==========================================================

classes = sorted(os.listdir(TRAIN_PATH))

# ==========================================================
# Display Images
# ==========================================================

plt.figure(figsize=(12,4))

for i, cls in enumerate(classes):

    class_folder = os.path.join(TRAIN_PATH, cls)

    image_name = sorted(os.listdir(class_folder))[0]

    image_path = os.path.join(class_folder, image_name)

    image = Image.open(image_path)

    plt.subplot(1, len(classes), i+1)

    plt.imshow(image)

    plt.title(cls)

    plt.axis("off")

plt.tight_layout()

plt.show()