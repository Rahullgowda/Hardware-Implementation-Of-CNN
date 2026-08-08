"""
==============================================================
Project : Single Layer Hardware CNN

Author  : Rahul Gowda

File    : 10_decimal_to_hex.py

Purpose :
Convert signed 8-bit fixed-point weights
to hexadecimal memory files.

==============================================================
"""

# ==========================================================
# Import Libraries
# ==========================================================

import os
import numpy as np

# ==========================================================
# Paths
# ==========================================================

WEIGHT_PATH = r"D:\single layer hardware cnn project\weights"

# ==========================================================
# Load Fixed Point Weights
# ==========================================================

conv_weights = np.load(
    os.path.join(WEIGHT_PATH, "conv_weights_fixed.npy")
)

conv_bias = np.load(
    os.path.join(WEIGHT_PATH, "conv_bias_fixed.npy")
)

fc_weights = np.load(
    os.path.join(WEIGHT_PATH, "fc_weights_fixed.npy")
)

fc_bias = np.load(
    os.path.join(WEIGHT_PATH, "fc_bias_fixed.npy")
)

# ==========================================================
# Function
# ==========================================================

def save_hex(data, filename):

    file_path = os.path.join(WEIGHT_PATH, filename)

    with open(file_path, "w") as file:

        for value in data.flatten():

            hex_value = format(np.uint8(value), "02X")

            file.write(hex_value + "\n")

# ==========================================================
# Save Hex Files
# ==========================================================

save_hex(conv_weights, "conv_weights.mem")

save_hex(conv_bias, "conv_bias.mem")

save_hex(fc_weights, "fc_weights.mem")

save_hex(fc_bias, "fc_bias.mem")

# ==========================================================
# Done
# ==========================================================

print("="*60)
print("HEX FILES CREATED")
print("="*60)

print()

print("conv_weights.mem")

print("conv_bias.mem")

print("fc_weights.mem")

print("fc_bias.mem")