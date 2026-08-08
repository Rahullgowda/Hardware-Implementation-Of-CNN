"""
==============================================================
Project : Single Layer Hardware CNN

Author  : Rahul Gowda

File    : 09_convert_to_fixed_point.py

Purpose :
Convert floating-point weights to
8-bit signed fixed-point integers.

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
# Load Floating Point Weights
# ==========================================================

conv_weights = np.load(
    os.path.join(WEIGHT_PATH, "conv_weights.npy")
)

conv_bias = np.load(
    os.path.join(WEIGHT_PATH, "conv_bias.npy")
)

fc_weights = np.load(
    os.path.join(WEIGHT_PATH, "fc_weights.npy")
)

fc_bias = np.load(
    os.path.join(WEIGHT_PATH, "fc_bias.npy")
)

# ==========================================================
# Fixed Point Conversion
# ==========================================================

SCALE_FACTOR = 64

conv_weights_fixed = np.round(conv_weights * SCALE_FACTOR)
conv_bias_fixed = np.round(conv_bias * SCALE_FACTOR)

fc_weights_fixed = np.round(fc_weights * SCALE_FACTOR)
fc_bias_fixed = np.round(fc_bias * SCALE_FACTOR)

# ==========================================================
# Limit to Signed 8-bit Range
# ==========================================================

conv_weights_fixed = np.clip(conv_weights_fixed, -128, 127).astype(np.int8)
conv_bias_fixed = np.clip(conv_bias_fixed, -128, 127).astype(np.int8)

fc_weights_fixed = np.clip(fc_weights_fixed, -128, 127).astype(np.int8)
fc_bias_fixed = np.clip(fc_bias_fixed, -128, 127).astype(np.int8)

# ==========================================================
# Save Fixed Point Weights
# ==========================================================

np.save(
    os.path.join(WEIGHT_PATH, "conv_weights_fixed.npy"),
    conv_weights_fixed
)

np.save(
    os.path.join(WEIGHT_PATH, "conv_bias_fixed.npy"),
    conv_bias_fixed
)

np.save(
    os.path.join(WEIGHT_PATH, "fc_weights_fixed.npy"),
    fc_weights_fixed
)

np.save(
    os.path.join(WEIGHT_PATH, "fc_bias_fixed.npy"),
    fc_bias_fixed
)

# ==========================================================
# Display Information
# ==========================================================

print("=" * 60)
print("FIXED POINT CONVERSION COMPLETED")
print("=" * 60)

print("\nScale Factor :", SCALE_FACTOR)

print("\nExample Conversion")

print("----------------------------")

print("Floating Weight :", conv_weights[0,0,0,0])

print("Fixed Weight    :", conv_weights_fixed[0,0,0,0])

print("\nFiles Saved")

print("----------------------------")

print("conv_weights_fixed.npy")
print("conv_bias_fixed.npy")
print("fc_weights_fixed.npy")
print("fc_bias_fixed.npy")