# Regenerates the README.md based on the data from project_info.csv
import csv

# Converts a list of entries into a markdown table row
def list_to_mdrow(rowlist):
    row = "| "
    for entry in rowlist:
        row += entry + " | "
    return row

def csv_to_mdtable(path_to_csv):
    with open("projects_info.csv", newline='') as csvfile:
        csvreader = csv.reader(csvfile)
        csv_rows = []
        for line in csvreader:
            csv_rows.append(line)

    csv_rows.insert(1, ["---" for i in csv_rows[0]]) # Insert something to represent the header separator line
    markdown_table = ""
    for one_row in csv_rows:
        markdown_table += list_to_mdrow(one_row) + "\n"
    return markdown_table


if __name__ == "__main__":
    path_to_csv = 'projects_info.csv'
    with open("readme_template.txt", newline='') as readme_template:
        readme_text = readme_template.read()
    
    markdown_table = csv_to_mdtable(path_to_csv)
    readme_text = readme_text.replace(f"({path_to_csv})", markdown_table)
    print(readme_text)
    with open("README.md", "w", newline='') as readme_file:
        readme_file.write(readme_text)


        
        
    
    
    
