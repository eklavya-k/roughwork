import re

input_file_path = './TableUpdates/newclusterjars.txt'

jar_directory = 'Data_deps'

output_file_path = './output.txt'

with open(output_file_path, 'w') as output_file:
	with open(input_file_path, 'r') as input_file:
		for line in input_file:
			jar_path = line.strip()
			jar_name = jar_path[49:]
			jar = jar_name[:len(jar_name)-4]

			id = 0
			for i, c in enumerate(jar):
				if i == 0:
					continue
				if jar[i - 1] == '-' and '0' <= c <= '9':
					id = i
					break
			if id == 0:
				output_file.write(f"manually decide for {jar_name}\n")
			else:
				output_file.write(f"{jar}      {jar[:id - 1]}      {jar[id:]}\n")

print(f'Processing complete. Results are saved in {output_file_path}.')
