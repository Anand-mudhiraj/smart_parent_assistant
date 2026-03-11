import os
import numpy as np

try:
    import tflite_runtime.interpreter as tflite
except ImportError:
    from tensorflow import lite as tflite

MODEL_PATH = os.path.join(os.path.dirname(__file__), 'ml_models', 'child_reason.tflite')

# NOTE: Update these 6 categories to match what you actually trained in your Python script!
REASON_CLASSES = {
    0: "Hunger or Thirst",
    1: "Fatigue or Lack of Sleep",
    2: "Overstimulation",
    3: "Seeking Attention or Connection",
    4: "Testing Boundaries / Independence",
    5: "Physical Discomfort or Illness"
}

def load_model():
    interpreter = tflite.Interpreter(model_path=MODEL_PATH)
    interpreter.allocate_tensors()
    return interpreter

def preprocess_input(input_data):
    # The model expects exactly 5 numbers. 
    # Example: you might extract age, situation_id, emotion_id, etc. from 'input_data'
    
    # Placeholder: We will pass an array of 5 zeros if we don't get the right data yet
    # TODO: Replace this with your actual logic from dataset_generator.py!
    feature_1 = float(input_data.get('feature_1', 0.0))
    feature_2 = float(input_data.get('feature_2', 0.0))
    feature_3 = float(input_data.get('feature_3', 0.0))
    feature_4 = float(input_data.get('feature_4', 0.0))
    feature_5 = float(input_data.get('feature_5', 0.0))

    # Convert to the required [1, 5] float32 shape
    tensor_input = np.array([[feature_1, feature_2, feature_3, feature_4, feature_5]], dtype=np.float32)
    return tensor_input

def predict_reason(input_data):
    interpreter = load_model()
    
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    
    # 1. Convert the incoming JSON into the [1, 5] mathematical shape
    input_tensor = preprocess_input(input_data)
    
    # 2. Feed the numbers into the model
    interpreter.set_tensor(input_details[0]['index'], input_tensor)
    interpreter.invoke()
    
    # 3. Get the 6 output probabilities
    output_data = interpreter.get_tensor(output_details[0]['index'])
    predictions = output_data[0] 
    
    # 4. Find the index with the highest probability
    winning_index = int(np.argmax(predictions))
    confidence_score = float(predictions[winning_index])
    
    # 5. Translate the index back to English
    predicted_reason = REASON_CLASSES.get(winning_index, "Unknown Reason")
    
    return {
        "prediction": predicted_reason,
        "confidence_percentage": round(confidence_score * 100, 2),
        "class_id": winning_index
    }
