import pandas as pd
import tensorflow as tf
from sklearn.preprocessing import LabelEncoder
from tensorflow.keras.utils import to_categorical

df = pd.read_csv("dataset.csv")

X = df.drop("label", axis=1).values.astype("float32")
y = df["label"].values

# ✅ SAME normalization Flutter must use
X[:, 0] /= 2.0   # ageGroup (0–2)
X[:, 1] /= 3.0   # feedingGap (0–3)
X[:, 3] /= 3.0   # cryLevel (0–3)

encoder = LabelEncoder()
y_enc = encoder.fit_transform(y)
y_cat = to_categorical(y_enc)

model = tf.keras.Sequential([
    tf.keras.layers.Dense(64, activation="relu", input_shape=(6,)),
    tf.keras.layers.Dense(64, activation="relu"),
    tf.keras.layers.Dense(5, activation="softmax")
])

model.compile(
    optimizer="adam",
    loss="categorical_crossentropy",
    metrics=["accuracy"]
)

model.fit(X, y_cat, epochs=50, batch_size=32)

model.export("child_reason_model")

# Export TFLite
converter = tf.lite.TFLiteConverter.from_saved_model("child_reason_model")
tflite_model = converter.convert()

with open("child_reason.tflite", "wb") as f:
    f.write(tflite_model)

with open("labels.txt", "w") as f:
    for label in encoder.classes_:
        f.write(label + "\n")

print("✅ MODEL RETRAINED & EXPORTED")