import csv

def read_csv_rows(filename):
	with open('./TableUpdates/newClusterDefaultJars.txt', 'w') as file:
		with open(filename, 'r', newline='', encoding='utf-8') as csvfile:
			csvreader = csv.reader(csvfile)
			for i, row in enumerate(csvreader):
				if i == 0:
					continue
				call = f"""
call ADD_FLOW_DEFAULT_JAR_SETS(
	@set_id := 1,
	@artifact_id := \'{row[1]}\',
	@version := \'{row[2]}\',
	@path := \'{row[3]}\',
	@full_name := \'{row[4]}\',
	@status := 1,
	@description := \'new cluster jar for {row[1]}\',
	@user_name := \'eklavya.k\'
);

"""
				file.write(call);

			
read_csv_rows('./TableUpdates/newClusterDefaultJars.csv')


