import csv
import random

rows = 10000

with open("dataset.csv","w",newline="") as f:

    writer = csv.writer(f)

    writer.writerow([
        "sleep_quality",
        "feeding_gap",
        "crying_intensity",
        "visible_discomfort",
        "body_temperature",
        "reason"
    ])

    for i in range(rows):

        sleep = random.randint(0,2)
        feed = random.randint(0,2)
        cry = random.randint(0,2)
        discomfort = random.randint(0,2)
        temp = random.randint(0,2)

        reason = 5

        if feed == 2:
            reason = 0
        elif sleep == 2:
            reason = 1
        elif discomfort == 1:
            reason = 2
        elif discomfort == 2:
            reason = 3
        elif temp == 1:
            reason = 4
        else:
            reason = 5

        writer.writerow([sleep,feed,cry,discomfort,temp,reason])

print("Dataset generated with 10000 rows")