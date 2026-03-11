import os
import numpy as np
from supabase import create_client, Client

# Initialize Supabase client
supabase_url = os.environ.get('SUPABASE_URL')
supabase_key = os.environ.get('SUPABASE_KEY')

# Only initialize if keys are present (prevents local crashes if .env is missing)
supabase: Client = None
if supabase_url and supabase_key:
    supabase = create_client(supabase_url, supabase_key)

try:
    import ai_edge_litert.interpreter as tflite
except ImportError:
    from tensorflow import lite as tflite

MODEL_PATH = os.path.join(os.path.dirname(__file__), 'ml_models', 'child_reason.tflite')

REASON_CLASSES = {
    0: "Hunger or Thirst", 1: "Fatigue or Lack of Sleep",
    2: "Overstimulation", 3: "Seeking Attention or Connection",
    4: "Testing Boundaries / Independence", 5: "Physical Discomfort or Illness"
}

def load_model():
    interpreter = tflite.Interpreter(model_path=MODEL_PATH)
    interpreter.allocate_tensors()
    return interpreter

def preprocess_input(input_data):
    f1 = float(input_data.get('feature_1', 0.0))
    f2 = float(input_data.get('feature_2', 0.0))
    f3 = float(input_data.get('feature_3', 0.0))
    f4 = float(input_data.get('feature_4', 0.0))
    f5 = float(input_data.get('feature_5', 0.0))
    return np.array([[f1, f2, f3, f4, f5]], dtype=np.float32)

def predict_reason(input_data):
    interpreter = load_model()
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    
    input_tensor = preprocess_input(input_data)
    interpreter.set_tensor(input_details[0]['index'], input_tensor)
    interpreter.invoke()
    
    predictions = interpreter.get_tensor(output_details[0]['index'])[0]
    winning_index = int(np.argmax(predictions))
    confidence_score = float(predictions[winning_index])
    predicted_reason = REASON_CLASSES.get(winning_index, "Unknown Reason")
    
    # --- NEW: Log to Supabase ---
    if supabase:
        try:
            supabase.table('ai_predictions').insert({
                "feature_1": float(input_tensor[0][0]),
                "feature_2": float(input_tensor[0][1]),
                "feature_3": float(input_tensor[0][2]),
                "feature_4": float(input_tensor[0][3]),
                "feature_5": float(input_tensor[0][4]),
                "predicted_reason": predicted_reason,
                "confidence": confidence_score
            }).execute()
        except Exception as e:
            print(f"Supabase logging failed: {e}")
            
    return {
        "prediction": predicted_reason,
        "confidence_percentage": round(confidence_score * 100, 2),
        "class_id": winning_index
    }
