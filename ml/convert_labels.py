# convert_labels.py
import numpy as np

labels = np.load("labels.npy")

with open("labels.txt", "w") as f:
    for label in labels:
        f.write(label + "\n")

print("✅ labels.txt created")