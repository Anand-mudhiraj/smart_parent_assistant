import random
import csv

ROWS_PER_CLASS = 2000   # 5 × 2000 = 10,000

labels = ["Happy", "Hungry", "Sleepy", "Discomfort", "Fever"]

rows = []

# 🟢 HAPPY
for _ in range(ROWS_PER_CLASS):
    rows.append([1, 0, 1, 0, 0, 0, "Happy"])

# 🟡 HUNGRY
for _ in range(ROWS_PER_CLASS):
    rows.append([1, 3, 1, 3, 0, 0, "Hungry"])

# 🔵 SLEEPY
for _ in range(ROWS_PER_CLASS):
    rows.append([1, 1, 0, 1, 0, 0, "Sleepy"])

# 🟠 DISCOMFORT
for _ in range(ROWS_PER_CLASS):
    rows.append([1, 1, 1, 3, 1, 0, "Discomfort"])

# 🔴 FEVER
for _ in range(ROWS_PER_CLASS):
    rows.append([1, 1, 1, 2, 0, 1, "Fever"])

random.shuffle(rows)

with open("dataset.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow([
        "ageGroup",
        "feedingGap",
        "sleepOk",
        "cryLevel",
        "discomfort",
        "temp",
        "label"
    ])
    writer.writerows(rows)

print("✅ CLEAN BALANCED dataset.csv generated (10,000 rows)")