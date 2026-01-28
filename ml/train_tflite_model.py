import pandas as pd
import tensorflow as tf
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
import numpy as np

# Load dataset
df = pd.read_csv("dataset.csv")

X = df.drop("result", axis=1)
y = df["result"]

# Encode labels
encoder = LabelEncoder()
y_encoded = encoder.fit_transform(y)

# Save label mapping
np.save("labels.npy", encoder.classes_)

# Train-test split
X_train, X_test, y_train, y_test = train_test_split(
    X, y_encoded, test_size=0.2, random_state=42
)

# Build neural network
model = tf.keras.Sequential([
    tf.keras.layers.Dense(32, activation='relu', input_shape=(6,)),
    tf.keras.layers.Dense(16, activation='relu'),
    tf.keras.layers.Dense(len(encoder.classes_), activation='softmax')
])

model.compile(
    optimizer='adam',
    loss='sparse_categorical_crossentropy',
    metrics=['accuracy']
)

# Train
model.fit(X_train, y_train, epochs=30, batch_size=16)

# Convert to TFLite
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

with open("child_reason.tflite", "wb") as f:
    f.write(tflite_model)

print("✅ TFLite model created successfully")