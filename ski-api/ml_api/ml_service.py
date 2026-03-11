import os
import numpy as np
from supabase import create_client, Client

supabase_url = os.environ.get("SUPABASE_URL")
supabase_key = os.environ.get("SUPABASE_KEY")
supabase: Client = None

if supabase_url and supabase_key:
    try:
        supabase = create_client(supabase_url, supabase_key)
    except Exception as e:
        print(f"Supabase Init Error: {e}")

try:
    import ai_edge_litert.interpreter as tflite
except ImportError:
    from tensorflow import lite as tflite

MODEL_PATH = os.path.join(os.path.dirname(__file__), "ml_models", "child_reason_advanced.tflite")

REASON_CLASSES = {
    0: "Hungry", 1: "Sleepy / Overstimulated",
    2: "Diaper Change Needed", 3: "Gas / Colic Pain",
    4: "Sickness / Fever", 5: "Respiratory Distress", 6: "General Discomfort"
}

def predict_reason(input_data):
    interpreter = tflite.Interpreter(model_path=MODEL_PATH)
    interpreter.allocate_tensors()
    in_det = interpreter.get_input_details()[0]
    out_det = interpreter.get_output_details()[0]
    
    # Extract 10 features
    features = [float(input_data.get(f"f{i}", 0.0)) for i in range(1, 11)]
    input_tensor = np.array([features], dtype=np.float32)
    
    interpreter.set_tensor(in_det['index'], input_tensor)
    interpreter.invoke()
    
    preds = interpreter.get_tensor(out_det['index'])[0]
    win_idx = int(np.argmax(preds))
    conf = float(preds[win_idx])
    reason = REASON_CLASSES.get(win_idx, "Unknown")
    
    if supabase:
        try:
            supabase.table("ai_predictions").insert({
                "feature_1": features[0], "feature_2": features[1],
                "predicted_reason": reason, "confidence": conf
            }).execute()
        except: pass
            
    return { "prediction": reason, "confidence_percentage": round(conf * 100, 2), "class_id": win_idx }
