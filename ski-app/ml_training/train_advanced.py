import csv
import random
import numpy as np
import tensorflow as tf
from sklearn.model_selection import train_test_split
from tensorflow.keras.utils import to_categorical
import os

print("Generating 15,000 records of pediatric data...")
rows = 15000
data_path = "advanced_dataset.csv"

with open(data_path, "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow([
        "time", "sleep", "feed_gap", "feed_behav", "diaper", 
        "cry", "discomfort", "temp", "breathing", "activity", "reason"
    ])

    for _ in range(rows):
        t = random.randint(0, 3)
        slp = random.randint(0, 2)
        fg = random.randint(0, 2)
        fb = random.randint(0, 2)
        dp = random.randint(0, 2)
        cry = random.randint(0, 2)
        disc = random.randint(0, 2)
        tmp = random.randint(0, 2)
        brth = random.randint(0, 2)
        act = random.randint(0, 2)

        reason = 6 # Default: General Discomfort

        # Pediatric Logic
        if brth == 2 or (brth == 1 and act == 2):
            reason = 5 # Respiratory Distress (Emergency)
        elif tmp == 2 or (tmp == 1 and act == 2):
            reason = 4 # Sick / Fever
        elif disc == 1 and cry >= 1:
            reason = 3 # Gas / Colic
        elif fg == 2 and fb == 0:
            reason = 0 # Hungry
        elif dp == 2:
            reason = 2 # Diaper Change
        elif slp == 2 and cry >= 1:
            reason = 1 # Sleepy / Overstimulated

        writer.writerow([t, slp, fg, fb, dp, cry, disc, tmp, brth, act, reason])

import pandas as pd
print("Training Advanced Deep Learning Model...")
df = pd.read_csv(data_path)
X = df.drop("reason", axis=1).values
y = to_categorical(df["reason"].values, 7)

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

model = tf.keras.Sequential([
    tf.keras.layers.Dense(64, activation="relu", input_shape=(10,)),
    tf.keras.layers.Dropout(0.2),
    tf.keras.layers.Dense(32, activation="relu"),
    tf.keras.layers.Dense(16, activation="relu"),
    tf.keras.layers.Dense(7, activation="softmax")
])

model.compile(optimizer="adam", loss="categorical_crossentropy", metrics=["accuracy"])
model.fit(X_train, y_train, epochs=40, batch_size=32, verbose=0)

loss, acc = model.evaluate(X_test, y_test, verbose=0)
print(f"Model Accuracy: {acc * 100:.2f}%")

converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

model_out_path = os.path.join(r"C:\Users\anand\smart_parent_assistant\ski-api\ml_api\ml_models", "child_reason_advanced.tflite")
with open(model_out_path, "wb") as f:
    f.write(tflite_model)
print(f"? Advanced Model Saved to {model_out_path}")
