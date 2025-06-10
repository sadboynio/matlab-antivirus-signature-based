import json
import os
import subprocess

input_folder = 'testfiles'
output_file = 'tlshtestfiles.json'
hashes = []

for filename in os.listdir(input_folder):
    filepath = os.path.join(input_folder, filename)
    if os.path.isfile(filepath):
        output = subprocess.check_output(["./tlsh-master/bin/tlsh", "-f", filepath], text=True).strip()
        string = output[0:71]
        hashes.append({'filename': filename, 'tlsh': string.upper()})

with open(output_file, 'w') as outfile:
    json.dump(hashes, outfile, indent=4)
