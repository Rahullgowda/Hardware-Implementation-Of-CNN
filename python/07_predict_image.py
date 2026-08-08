"""
==============================================================
Project : Single Layer Hardware CNN

Author  : Rahul Gowda

File    : 07_predict_image.py

Purpose :
Predict the class of a single image.

==============================================================
"""

# ==========================================================
# Import Libraries
# ==========================================================

import numpy as np
import tensorflow as tf
import matplotlib.pyplot as plt
from PIL import Image

# ==========================================================
# Paths
# ==========================================================

MODEL_PATH = r"D:\single layer hardware cnn project\model\best_model.keras"

IMAGE_PATH = r"D:\single layer hardware cnn project\dataset\test\lung_n\lungn4798.jpeg"
# Change this path to any image you want to test

# ==========================================================
# Class Names
# ==========================================================

CLASS_NAMES = [
    "lung_aca",
    "lung_n",
    "lung_scc"
]

# ==========================================================
# Load Model
# ==========================================================

model = tf.keras.models.load_model(MODEL_PATH)

# ==========================================================
# Load Image
# ==========================================================

image = Image.open(IMAGE_PATH)

image = image.convert("L")

image = image.resize((16,16))

image_array = np.array(image)

image_array = image_array.astype("float32") / 255.0

image_array = np.expand_dims(image_array, axis=-1)

image_array = np.expand_dims(image_array, axis=0)

# ==========================================================
# Predict
# ==========================================================

prediction = model.predict(image_array, verbose=0)

predicted_class = np.argmax(prediction)

print("\nPrediction Scores")

print(prediction)

print("\nPredicted Class :", CLASS_NAMES[predicted_class])

# ==========================================================
# Display Image
# ==========================================================

plt.imshow(image, cmap="gray")

plt.title(CLASS_NAMES[predicted_class])

plt.axis("off")

plt.show()