import pandas as pd
import tensorflow as tf
from sklearn.model_selection import train_test_split
from tensorflow.keras.utils import to_categorical

# Load dataset
data = pd.read_csv("dataset.csv")

X = data.drop("reason",axis=1).values
y = data["reason"].values

y = to_categorical(y,6)

X_train,X_test,y_train,y_test = train_test_split(
    X,y,test_size=0.2,random_state=42
)

model = tf.keras.Sequential([
    tf.keras.layers.Dense(32,activation="relu",input_shape=(5,)),
    tf.keras.layers.Dense(16,activation="relu"),
    tf.keras.layers.Dense(8,activation="relu"),
    tf.keras.layers.Dense(6,activation="softmax")
])

model.compile(
    optimizer="adam",
    loss="categorical_crossentropy",
    metrics=["accuracy"]
)

model.fit(
    X_train,
    y_train,
    epochs=30,
    batch_size=32
)

loss,acc = model.evaluate(X_test,y_test)

print("Accuracy:",acc)

# Convert to TensorFlow Lite
converter = tf.lite.TFLiteConverter.from_keras_model(model)

tflite_model = converter.convert()

with open("child_reason.tflite","wb") as f:
    f.write(tflite_model)

print("TFLite model saved")