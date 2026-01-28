import joblib
import pandas as pd

# Load model
model = joblib.load("child_reason_model.pkl")
encoder = joblib.load("label_encoder.pkl")

# Example input (same order as dataset)
sample = pd.DataFrame([[0, 3, 0, 2, 1, 0]],
    columns=["age_group","feeding_gap","sleep_ok","cry_level","discomfort","temp"])

prediction = model.predict(sample)
result = encoder.inverse_transform(prediction)

print("Predicted reason:", result[0])