from __future__ import print_function
import sys

filename = sys.argv[1]

id_output = "ID"
gender_output = "gender"

with open(filename, 'r') as f:
    for line in f:
        id, gender = line.strip().split('\t')
        id = id.split('-')[-1]
        if gender == "MALE":
            gender = 0
        elif gender == "FEMALE":
            gender = 1
        id_output += "\t" + str(id)
        gender_output += "\t" + str(gender)

print(id_output)
print(gender_output)
