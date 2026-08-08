"""
==============================================================
Project : Single Layer Hardware CNN

Author  : Rahul Gowda

File    : 08A_understand_weights.py

Purpose :
Display the extracted weights and biases.

==============================================================
"""

# ==========================================================
# Import Libraries
# ==========================================================

import os
import numpy as np

# ==========================================================
# Weight Path
# ==========================================================

WEIGHT_PATH = r"D:\single layer hardware cnn project\weights"

# ==========================================================
# Load Weights
# ==========================================================

conv_weights = np.load(
    os.path.join(
        WEIGHT_PATH,
        "conv_weights.npy"
    )
)

conv_bias = np.load(
    os.path.join(
        WEIGHT_PATH,
        "conv_bias.npy"
    )
)

fc_weights = np.load(
    os.path.join(
        WEIGHT_PATH,
        "fc_weights.npy"
    )
)

fc_bias = np.load(
    os.path.join(
        WEIGHT_PATH,
        "fc_bias.npy"
    )
)

# ==========================================================
# Display Shapes
# ==========================================================

print("="*60)
print("WEIGHT INFORMATION")
print("="*60)

print("\nConvolution Weight Shape :", conv_weights.shape)
print("Convolution Bias Shape   :", conv_bias.shape)

print("\nFully Connected Weight Shape :", fc_weights.shape)
print("Fully Connected Bias Shape   :", fc_bias.shape)

# ==========================================================
# Display Convolution Filters
# ==========================================================

print("\n")
print("="*60)
print("CONVOLUTION FILTERS")
print("="*60)

for i in range(conv_weights.shape[3]):

    print(f"\nFilter {i+1}")

    print(conv_weights[:, :, 0, i])

# ==========================================================
# Display Convolution Bias
# ==========================================================

print("\n")
print("="*60)
print("CONVOLUTION BIAS")
print("="*60)

print(conv_bias)

# ==========================================================
# Display Dense Weights
# ==========================================================

print("\n")
print("="*60)
print("FULLY CONNECTED WEIGHTS")
print("="*60)

print("Showing first 10 rows only\n")

print(fc_weights[:10])

# ==========================================================
# Display Dense Bias
# ==========================================================

print("\n")
print("="*60)
print("FULLY CONNECTED BIAS")
print("="*60)

print(fc_bias)

print("\nDone.")