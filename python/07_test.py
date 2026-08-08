"""
==============================================================
Project : Single Layer Hardware CNN

Author  : Rahul Gowda

File    : 07_test.py

Purpose :
Test the saved CNN model.

==============================================================
"""

# ==========================================================
# Import Libraries
# ==========================================================

import tensorflow as tf

# ==========================================================
# Dataset Path
# ==========================================================

TEST_PATH = r"D:\single layer hardware cnn project\dataset\preprocessed\test"

MODEL_PATH = r"D:\single layer hardware cnn project\model\best_model.keras"

IMAGE_SIZE = (16,16)

BATCH_SIZE = 32

# ==========================================================
# Load Test Dataset
# ==========================================================

test_dataset = tf.keras.utils.image_dataset_from_directory(

    TEST_PATH,

    image_size=IMAGE_SIZE,

    color_mode="grayscale",

    batch_size=BATCH_SIZE,

    shuffle=False

)

# ==========================================================
# Normalize Images
# ==========================================================

normalization = tf.keras.layers.Rescaling(1./255)

test_dataset = test_dataset.map(

    lambda images, labels:

    (normalization(images), labels)

)

AUTOTUNE = tf.data.AUTOTUNE

test_dataset = test_dataset.prefetch(AUTOTUNE)

# ==========================================================
# Load Model
# ==========================================================

model = tf.keras.models.load_model(

    MODEL_PATH

)

# ==========================================================
# Evaluate
# ==========================================================

loss, accuracy = model.evaluate(

    test_dataset,

    verbose=1

)

print("\n====================================")

print(f"Test Loss     : {loss:.4f}")

print(f"Test Accuracy : {accuracy*100:.2f}%")

print("====================================")