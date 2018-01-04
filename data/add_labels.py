"""
Preprocessing script. Prepend labels to csv files to be used by R.
Safe to run multiple times, label presence is checked before writing.
"""
import os

NUMBER_OF_EXPS = 3
LABELS = { "stats_best_units": "win;survivors",
           "stats_evolving":   "win;survivors;average;best;bestever" }

def handle_directory(directory):
        print("Preprocess", directory)
        for i in range(1, 4):
                for pair in LABELS.items():
                        filename = "{}_{}.csv".format(i, pair[0])
                        path = os.path.join(directory, filename)
                        new_content = ""
                        with open(path, 'r') as file:
                                first_line = file.readline()
                                if first_line == pair[1] + "\n":
                                        print(filename, "already preprocessed.")
                                        continue
                                else:
                                        new_content = pair[1] + "\n" + first_line + file.read()

                        with open(path, 'w') as file:
                                file.write(new_content)
                                print(filename, "done.")

root = os.path.dirname(__file__)
for elem in os.listdir(root):
        if os.path.isdir(elem):
                directory = os.path.join(root, elem)
                handle_directory(directory)
