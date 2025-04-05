# Regenerates the README.md based on the data from project_info.csv
import csv

readme_intro = '''This repository stores the results of my personal projects done in SQL.'''

# Converts a list of entries into a markdown table row
def array_to_tablerow(array):
    row = "| "
    for entry in array:
        row += entry + " | "
    return row

if __name__ == "__main__":
    with open("projects_info.csv", newline='') as csvfile:
        csvreader = csv.reader(csvfile)
        csv_rows = []
        for line in csvreader:
            csv_rows.append(line)

    csv_rows.insert(1, ["---" for i in csv_rows[0]]) # Insert something to represent the header separator line
    markdown_table = ""
    for one_row in csv_rows:
        markdown_table += array_to_tablerow(one_row) + "\n"
    readme_intro += "\n\n" + markdown_table

    with open("README.md", "w") as readmefile:
        readmefile.write(readme_intro)


        
        
    
    
    
