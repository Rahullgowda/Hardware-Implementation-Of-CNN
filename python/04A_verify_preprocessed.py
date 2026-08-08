"""
==============================================================
Project : Single Layer Hardware CNN

Author  : Rahul Gowda

File    : 04A_verify_preprocessed.py

Purpose :
Verify the preprocessed dataset.

==============================================================
"""

# ==========================================================
# Import Libraries
# ==========================================================

import os
from PIL import Image

# ==========================================================
# Dataset Path
# ==========================================================

DATASET_PATH = r"D:\single layer hardware cnn project\dataset\preprocessed"

EXPECTED_SIZE = (16,16)

# ==========================================================
# Verify Function
# ==========================================================

def verify_dataset(dataset_type):

    folder = os.path.join(DATASET_PATH, dataset_type)

    classes = sorted(os.listdir(folder))

    total = 0
    error = 0

    print("\n" + "="*60)
    print(dataset_type.upper())
    print("="*60)

    for cls in classes:

        class_folder = os.path.join(folder, cls)

        count = 0

        for image_name in os.listdir(class_folder):

            image_path = os.path.join(class_folder, image_name)

            try:

                image = Image.open(image_path)

                if image.size != EXPECTED_SIZE:

                    print("Wrong Size :", image_path)

                    error += 1

                if image.mode != "L":

                    print("Not Grayscale :", image_path)

                    error += 1

                count += 1

            except:

                print("Cannot Open :", image_path)

                error += 1

        total += count

        print(f"{cls:<12} : {count}")

    print("\nTotal Images :", total)
    print("Errors       :", error)

# ==========================================================
# Main Program
# ==========================================================

print("="*60)
print("VERIFYING PREPROCESSED DATASET")
print("="*60)

verify_dataset("train")

verify_dataset("test")

print("\nVerification Completed.")