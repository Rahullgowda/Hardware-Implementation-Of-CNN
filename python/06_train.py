"""
==============================================================
Project : Single Layer Hardware CNN

Author  : Rahul Gowda

File    : 06_train.py

Purpose :
Train the Single Layer Hardware CNN.

==============================================================
"""

# ==========================================================
# Import Libraries
# ==========================================================

import os
import tensorflow as tf
import matplotlib.pyplot as plt

from tensorflow.keras import Sequential
from tensorflow.keras.layers import (
    Input,
    Conv2D,
    ReLU,
    MaxPooling2D,
    Flatten,
    Dense,
    Rescaling
)

from tensorflow.keras.callbacks import (
    ModelCheckpoint,
    CSVLogger,
    EarlyStopping
)

# ==========================================================
# Dataset Paths
# ==========================================================

TRAIN_PATH = r"D:\single layer hardware cnn project\dataset\preprocessed\train"

TEST_PATH = r"D:\single layer hardware cnn project\dataset\preprocessed\test"

# ==========================================================
# Output Paths
# ==========================================================

MODEL_PATH = r"D:\single layer hardware cnn project\model"

RESULT_PATH = r"D:\single layer hardware cnn project\results"

os.makedirs(MODEL_PATH, exist_ok=True)
os.makedirs(RESULT_PATH, exist_ok=True)

# ==========================================================
# Training Settings
# ==========================================================

IMAGE_SIZE = (16,16)

BATCH_SIZE = 32

EPOCHS = 30

LEARNING_RATE = 0.001

# ==========================================================
# Load Training Dataset
# ==========================================================

train_dataset = tf.keras.utils.image_dataset_from_directory(

    TRAIN_PATH,

    image_size=IMAGE_SIZE,

    color_mode="grayscale",

    batch_size=BATCH_SIZE,

    shuffle=True

)

# ==========================================================
# Load Testing Dataset
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

normalization = Rescaling(1.0 / 255)

train_dataset = train_dataset.map(

    lambda images, labels:

    (normalization(images), labels)

)

test_dataset = test_dataset.map(

    lambda images, labels:

    (normalization(images), labels)

)

# ==========================================================
# Speed Up Dataset Loading
# ==========================================================

AUTOTUNE = tf.data.AUTOTUNE

train_dataset = train_dataset.prefetch(AUTOTUNE)

test_dataset = test_dataset.prefetch(AUTOTUNE)

print("\nDatasets Loaded Successfully.")
print("Training Ready.\n")

# ==========================================================
# Build CNN Model
# ==========================================================

model = Sequential(name="Single_Layer_Hardware_CNN")

# ----------------------------------------------------------
# Input Layer
# ----------------------------------------------------------

model.add(

    Input(

        shape=(16,16,1)

    )

)

# ----------------------------------------------------------
# Convolution Layer
# ----------------------------------------------------------

model.add(

    Conv2D(

        filters=4,

        kernel_size=(3,3),

        strides=(1,1),

        padding="valid",

        activation=None,

        use_bias=True,

        name="Convolution"

    )

)

# ----------------------------------------------------------
# ReLU Layer
# ----------------------------------------------------------

model.add(

    ReLU(

        name="ReLU"

    )

)

# ----------------------------------------------------------
# Max Pool Layer
# ----------------------------------------------------------

model.add(

    MaxPooling2D(

        pool_size=(2,2),

        strides=(2,2),

        name="MaxPool"

    )

)

# ----------------------------------------------------------
# Flatten Layer
# ----------------------------------------------------------

model.add(

    Flatten(

        name="Flatten"

    )

)

# ----------------------------------------------------------
# Fully Connected Layer
# ----------------------------------------------------------

model.add(

    Dense(

        units=3,

        activation=None,

        use_bias=True,

        name="FullyConnected"

    )

)

# ==========================================================
# Display Model Summary
# ==========================================================

print("\n")
model.summary()

# ==========================================================
# Compile Model
# ==========================================================

model.compile(

    optimizer=tf.keras.optimizers.Adam(

        learning_rate=LEARNING_RATE

    ),

    loss=tf.keras.losses.SparseCategoricalCrossentropy(

        from_logits=True

    ),

    metrics=["accuracy"]

)

# ==========================================================
# Save Best Model
# ==========================================================

best_model = ModelCheckpoint(

    filepath=os.path.join(

        MODEL_PATH,

        "best_model.keras"

    ),

    monitor="val_accuracy",

    save_best_only=True,

    mode="max",

    verbose=1

)

# ==========================================================
# Save Best Weights
# ==========================================================

best_weights = ModelCheckpoint(

    filepath=os.path.join(

        MODEL_PATH,

        "best_weights.weights.h5"

    ),

    monitor="val_accuracy",

    save_best_only=True,

    save_weights_only=True,

    mode="max",

    verbose=1

)

# ==========================================================
# Save Training History
# ==========================================================

csv_logger = CSVLogger(

    os.path.join(

        RESULT_PATH,

        "training_history.csv"

    )

)

# ==========================================================
# Early Stopping
# ==========================================================

early_stop = EarlyStopping(

    monitor="val_accuracy",

    patience=5,

    restore_best_weights=True,

    verbose=1

)

print("\nModel Compiled Successfully.")
print("Ready to Start Training.\n")

# ==========================================================
# Train Model
# ==========================================================

history = model.fit(

    train_dataset,

    validation_data=test_dataset,

    epochs=EPOCHS,

    callbacks=[

        best_model,

        best_weights,

        csv_logger,

        early_stop

    ]

)

# ==========================================================
# Evaluate Model
# ==========================================================

print("\n")
print("=" * 60)
print("MODEL EVALUATION")
print("=" * 60)

loss, accuracy = model.evaluate(

    test_dataset,

    verbose=1

)

print(f"\nTest Loss     : {loss:.4f}")
print(f"Test Accuracy : {accuracy*100:.2f}%")

# ==========================================================
# Save Accuracy Graph
# ==========================================================

plt.figure(figsize=(8,5))

plt.plot(

    history.history["accuracy"],

    label="Training Accuracy",

    linewidth=2

)

plt.plot(

    history.history["val_accuracy"],

    label="Validation Accuracy",

    linewidth=2

)

plt.title("Training vs Validation Accuracy")

plt.xlabel("Epoch")

plt.ylabel("Accuracy")

plt.grid(True)

plt.legend()

plt.savefig(

    os.path.join(

        RESULT_PATH,

        "accuracy_graph.png"

    )

)

plt.close()

# ==========================================================
# Save Loss Graph
# ==========================================================

plt.figure(figsize=(8,5))

plt.plot(

    history.history["loss"],

    label="Training Loss",

    linewidth=2

)

plt.plot(

    history.history["val_loss"],

    label="Validation Loss",

    linewidth=2

)

plt.title("Training vs Validation Loss")

plt.xlabel("Epoch")

plt.ylabel("Loss")

plt.grid(True)

plt.legend()

plt.savefig(

    os.path.join(

        RESULT_PATH,

        "loss_graph.png"

    )

)

plt.close()

# ==========================================================
# Training Completed
# ==========================================================

print("\n")
print("=" * 60)
print("TRAINING COMPLETED SUCCESSFULLY")
print("=" * 60)

print("\nFiles Saved:")

print(f"\nBest Model      : {os.path.join(MODEL_PATH,'best_model.keras')}")
print(f"Best Weights    : {os.path.join(MODEL_PATH,'best_weights.weights.h5')}")
print(f"Training History: {os.path.join(RESULT_PATH,'training_history.csv')}")
print(f"Accuracy Graph  : {os.path.join(RESULT_PATH,'accuracy_graph.png')}")
print(f"Loss Graph      : {os.path.join(RESULT_PATH,'loss_graph.png')}")

print("\nFinal Test Accuracy : {:.2f}%".format(accuracy * 100))

print("\nSingle Layer Hardware CNN Training Finished Successfully.")