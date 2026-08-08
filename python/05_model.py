"""
==============================================================
Project : Single Layer Hardware CNN

Author  : Rahul Gowda

File    : 05_model.py

Purpose :
Create the CNN Architecture.

==============================================================
"""

# ==========================================================
# Import Libraries
# ==========================================================

from tensorflow.keras import Sequential
from tensorflow.keras.layers import (
    Input,
    Conv2D,
    ReLU,
    MaxPooling2D,
    Flatten,
    Dense
)

# ==========================================================
# Build CNN Model
# ==========================================================

def build_model():

    model = Sequential(name="Single_Layer_Hardware_CNN")

    # ------------------------------------------------------
    # Input Layer
    # ------------------------------------------------------

    model.add(
        Input(shape=(16,16,1), name="Input")
    )

    # ------------------------------------------------------
    # Convolution Layer
    # ------------------------------------------------------

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

    # ------------------------------------------------------
    # ReLU Layer
    # ------------------------------------------------------

    model.add(
        ReLU(name="ReLU")
    )

    # ------------------------------------------------------
    # Max Pool Layer
    # ------------------------------------------------------

    model.add(
        MaxPooling2D(
            pool_size=(2,2),
            strides=(2,2),
            name="MaxPool"
        )
    )

    # ------------------------------------------------------
    # Flatten Layer
    # ------------------------------------------------------

    model.add(
        Flatten(name="Flatten")
    )

    # ------------------------------------------------------
    # Fully Connected Layer
    # ------------------------------------------------------

    model.add(
        Dense(
            units=3,
            activation=None,
            use_bias=True,
            name="FullyConnected"
        )
    )

    return model


# ==========================================================
# Main
# ==========================================================

if __name__ == "__main__":

    model = build_model()

    model.summary()