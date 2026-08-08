"""
==============================================================
Project : Single Layer Hardware CNN

Author  : Rahul Gowda

File    : 08_extract_weights.py

Purpose :
Extract trained CNN weights and biases.

==============================================================
"""

# ==========================================================
# Import Libraries
# ==========================================================

import os
import numpy as np
import tensorflow as tf

# ==========================================================
# Paths
# ==========================================================

MODEL_PATH = r"D:\single layer hardware cnn project\model\best_model.keras"

WEIGHT_PATH = r"D:\single layer hardware cnn project\weights"

os.makedirs(WEIGHT_PATH, exist_ok=True)

# ==========================================================
# Load Model
# ==========================================================

model = tf.keras.models.load_model(MODEL_PATH)

print("\nModel Loaded Successfully.\n")

# ==========================================================
# Display Layers
# ==========================================================

print("Layers in Model\n")

for i, layer in enumerate(model.layers):

    print(i, ":", layer.name)

# ==========================================================
# Convolution Layer
# ==========================================================

conv_weights, conv_bias = model.get_layer("Convolution").get_weights()

# ==========================================================
# Fully Connected Layer
# ==========================================================

fc_weights, fc_bias = model.get_layer("FullyConnected").get_weights()

# ==========================================================
# Display Shapes
# ==========================================================

print("\n========================================")

print("Convolution Weights Shape :", conv_weights.shape)

print("Convolution Bias Shape    :", conv_bias.shape)

print()

print("Dense Weights Shape       :", fc_weights.shape)

print("Dense Bias Shape          :", fc_bias.shape)

print("========================================")

# ==========================================================
# Save Weights
# ==========================================================

np.save(

    os.path.join(

        WEIGHT_PATH,

        "conv_weights.npy"

    ),

    conv_weights

)

np.save(

    os.path.join(

        WEIGHT_PATH,

        "conv_bias.npy"

    ),

    conv_bias

)

np.save(

    os.path.join(

        WEIGHT_PATH,

        "fc_weights.npy"

    ),

    fc_weights

)

np.save(

    os.path.join(

        WEIGHT_PATH,

        "fc_bias.npy"

    ),

    fc_bias

)

print("\nWeights Saved Successfully.")

print("\nSaved Files")

print("------------------------------")

print("conv_weights.npy")

print("conv_bias.npy")

print("fc_weights.npy")

print("fc_bias.npy")