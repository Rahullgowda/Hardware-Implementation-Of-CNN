"""
==============================================================
Project : Single Layer Hardware CNN

Author  : Rahul Gowda

File    : 11_image_to_mem.py

Purpose :
Convert an original dataset image into a
16x16 grayscale hexadecimal memory (.mem) file
for Verilog Image Memory.

==============================================================
"""

# ==========================================================
# Import Libraries
# ==========================================================

import os
import numpy as np
from PIL import Image

# ==========================================================
# Input Image
# ==========================================================

IMAGE_PATH = r"D:\single layer hardware cnn project\dataset\test\lung_aca\lungaca3916.jpeg"

# Change this path to any dataset image.

# ==========================================================
# Output Folder
# ==========================================================

MEMORY_FOLDER = r"D:\single layer hardware cnn project\hardware\memory"

os.makedirs(MEMORY_FOLDER, exist_ok=True)

MEM_FILE = os.path.join(MEMORY_FOLDER, "input_image.mem")

VERIFY_IMAGE = os.path.join(MEMORY_FOLDER, "input_image_16x16.png")

# ==========================================================
# Load Image
# ==========================================================

print("=" * 60)
print("LOADING IMAGE")
print("=" * 60)

image = Image.open(IMAGE_PATH)

print("Original Image Size :", image.size)

# ==========================================================
# Preprocessing
# ==========================================================

print("\nPreprocessing Image...")

# Convert to Grayscale
image = image.convert("L")

# Resize to 16x16
image = image.resize((16, 16))

# Save the processed image for verification
image.save(VERIFY_IMAGE)

# ==========================================================
# Convert to NumPy
# ==========================================================

pixels = np.array(image, dtype=np.uint8)

# ==========================================================
# Verify
# ==========================================================

print("\nProcessed Image Size :", pixels.shape)

print("Total Pixels :", pixels.size)

# ==========================================================
# Create Memory File
# ==========================================================

with open(MEM_FILE, "w") as file:

    for row in range(16):

        for col in range(16):

            pixel = pixels[row][col]

            file.write(f"{pixel:02X}\n")

# ==========================================================
# Display Pixel Matrix
# ==========================================================

print("\n")
print("=" * 60)
print("16x16 PIXEL VALUES (DECIMAL)")
print("=" * 60)

for row in range(16):

    for col in range(16):

        print(f"{pixels[row][col]:3}", end=" ")

    print()

# ==========================================================
# Display First 32 Hex Values
# ==========================================================

print("\n")
print("=" * 60)
print("FIRST 32 HEX VALUES")
print("=" * 60)

count = 0

for row in range(16):

    for col in range(16):

        print(f"{pixels[row][col]:02X}", end=" ")

        count += 1

        if count == 32:
            break

    if count == 32:
        break

print()

# ==========================================================
# Done
# ==========================================================

print("\n")
print("=" * 60)
print("FILES CREATED SUCCESSFULLY")
print("=" * 60)

print("\nMemory File")

print(MEM_FILE)

print("\nVerification Image")

print(VERIFY_IMAGE)

print("\nImage successfully converted to Verilog memory file.")

print("=" * 60)