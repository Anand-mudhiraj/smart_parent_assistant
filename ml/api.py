from flask import Flask, request, jsonify
import joblib
import pandas as pd

app = Flask(__name__)

# Load model & encoder
model = joblib.load("child_reason_model.pkl")
encoder = joblib.load("label_encoder.pkl")

@app.route("/predict", methods=["POST"])
def predict():
    data = request.json

    sample = pd.DataFrame([[ 
        data["age_group"],
        data["feeding_gap"],
        data["sleep_ok"],
        data["cry_level"],
        data["discomfort"],
        data["temp"]
    ]], columns=[
        "age_group","feeding_gap","sleep_ok",
        "cry_level","discomfort","temp"
    ])

    prediction = model.predict(sample)
    result = encoder.inverse_transform(prediction)[0]

    return jsonify({"result": result})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)