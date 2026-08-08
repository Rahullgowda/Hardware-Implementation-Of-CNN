"""
==============================================================
Project : Single Layer Hardware CNN

Author  : Rahul Gowda

File    : 01_dataset_info.py

Purpose :
Display complete dataset information.

==============================================================
"""

# ==========================================================
# Import Libraries
# ==========================================================

import os

# ==========================================================
# Dataset Paths
# ==========================================================

TRAIN_PATH = r"D:\single layer hardware cnn project\dataset\train"
TEST_PATH  = r"D:\single layer hardware cnn project\dataset\test"

# ==========================================================
# Check Dataset Paths
# ==========================================================

print("=" * 60)
print("DATASET INFORMATION")
print("=" * 60)

if not os.path.exists(TRAIN_PATH):
    print("ERROR : Training folder not found!")
    exit()

if not os.path.exists(TEST_PATH):
    print("ERROR : Testing folder not found!")
    exit()

# ==========================================================
# Read Class Names
# ==========================================================

train_classes = sorted(os.listdir(TRAIN_PATH))
test_classes = sorted(os.listdir(TEST_PATH))

print("\nTraining Classes:")
for cls in train_classes:
    print(" -", cls)

print("\nTesting Classes:")
for cls in test_classes:
    print(" -", cls)

# ==========================================================
# Count Images
# ==========================================================

total_train = 0
total_test = 0

print("\nTraining Images")

for cls in train_classes:

    folder = os.path.join(TRAIN_PATH, cls)

    count = len([
        file for file in os.listdir(folder)
        if file.lower().endswith((".jpg", ".jpeg", ".png"))
    ])

    total_train += count

    print(f"{cls:<12} : {count}")

print("\nTesting Images")

for cls in test_classes:

    folder = os.path.join(TEST_PATH, cls)

    count = len([
        file for file in os.listdir(folder)
        if file.lower().endswith((".jpg", ".jpeg", ".png"))
    ])

    total_test += count

    print(f"{cls:<12} : {count}")

# ==========================================================
# Summary
# ==========================================================

print("\n" + "=" * 60)
print("SUMMARY")
print("=" * 60)

print(f"Number of Classes      : {len(train_classes)}")
print(f"Total Training Images  : {total_train}")
print(f"Total Testing Images   : {total_test}")

print("\nDataset verification completed successfully.")