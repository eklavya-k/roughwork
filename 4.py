jar_paths = './TableUpdates/newClusterJars.txt'
jar_details = './TableUpdates/newClusterTable.txt'

paths = []
details = []

with open(jar_paths) as file:
	for line in file:
		paths.append(line.rstrip("\n"))

artifacts = set()
with open(jar_details) as file:
     for i, line in enumerate(file):
          row = line.strip().rstrip("\n").split("      ")
          if len(row) < 3:
               print(row)
               continue
          details.append([i + 1, row[1].strip(), row[2].strip(), paths[i].strip(), row[0].strip() + '.jar'])
          if row[1].strip() in artifacts:
               print(f"duplicate entry of artifact {row[1].strip()}")
          artifacts.add(row[1].strip())

print(len(artifacts), len(details))

import csv

columns = ['id', 'artifact_id', 'version', 'path', 'full_name']

with open('./TableUpdates/newClusterDefaultJars.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(columns)
    writer.writerows(details)

print("Data written to newClusterDefaultJars.csv")
