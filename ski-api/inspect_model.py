from tensorflow import lite as tflite
import os

model_path = os.path.join('ml_api', 'ml_models', 'child_reason.tflite')
interpreter = tflite.Interpreter(model_path=model_path)
interpreter.allocate_tensors()

print('\n?? --- MODEL INPUT EXPECTATIONS ---')
for i, detail in enumerate(interpreter.get_input_details()):
    print(f"Input {i}: Shape {detail['shape']}, Data Type {detail['dtype']}")

print('\n?? --- MODEL OUTPUT FORMAT ---')
for i, detail in enumerate(interpreter.get_output_details()):
    print(f"Output {i}: Shape {detail['shape']}, Data Type {detail['dtype']}\n")
