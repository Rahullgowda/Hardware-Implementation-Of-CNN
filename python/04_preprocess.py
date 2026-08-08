"""
==============================================================
Project : Single Layer Hardware CNN

Author  : Rahul Gowda

File    : 04_preprocess.py

Purpose :
Resize all images to 16x16, convert to grayscale,
and save them into the preprocessed dataset.

==============================================================
"""

# ==========================================================
# Import Libraries
# ==========================================================

import os
from PIL import Image

# ==========================================================
# Dataset Paths
# ==========================================================

TRAIN_INPUT = r"D:\single layer hardware cnn project\dataset\train"
TEST_INPUT  = r"D:\single layer hardware cnn project\dataset\test"

TRAIN_OUTPUT = r"D:\single layer hardware cnn project\dataset\preprocessed\train"
TEST_OUTPUT  = r"D:\single layer hardware cnn project\dataset\preprocessed\test"

# ==========================================================
# Image Size
# ==========================================================

IMAGE_SIZE = (16, 16)

# ==========================================================
# Create Output Folders
# ==========================================================

os.makedirs(TRAIN_OUTPUT, exist_ok=True)
os.makedirs(TEST_OUTPUT, exist_ok=True)

# ==========================================================
# Function
# ==========================================================

def preprocess_dataset(input_path, output_path):

    classes = sorted(os.listdir(input_path))

    total_images = 0

    for class_name in classes:

        input_class = os.path.join(input_path, class_name)
        output_class = os.path.join(output_path, class_name)

        os.makedirs(output_class, exist_ok=True)

        image_list = sorted(os.listdir(input_class))

        print(f"\nProcessing Class : {class_name}")

        for image_name in image_list:

            input_image = os.path.join(input_class, image_name)

            output_image = os.path.join(output_class, image_name)

            image = Image.open(input_image)

            image = image.convert("L")

            image = image.resize(IMAGE_SIZE)

            image.save(output_image)

            total_images += 1

        print(f"Completed : {len(image_list)} images")

    return total_images

# ==========================================================
# Main Program
# ==========================================================

print("="*60)
print("PREPROCESSING TRAIN DATASET")
print("="*60)

train_count = preprocess_dataset(TRAIN_INPUT, TRAIN_OUTPUT)

print("\n")

print("="*60)
print("PREPROCESSING TEST DATASET")
print("="*60)

test_count = preprocess_dataset(TEST_INPUT, TEST_OUTPUT)

print("\n")

print("="*60)
print("PREPROCESSING COMPLETED")
print("="*60)

print(f"Training Images Processed : {train_count}")
print(f"Testing Images Processed  : {test_count}")

print("\nAll images resized to 16x16 and converted to grayscale.")