#Handling Transit Data Process:

1. Import Data as CSV file into SSMS.
	-Manully:
		a. Create XML file to reference in SQL
		b. Create SQL Query to CREATE TABLE, and INSERT INTO data into that table using the XML file, and data.csv file.
	-For Smaller files, use Import Wizard

2. Clean Data - remove duplicates

3. Join Ridership data with Scheduals and provide Trip Ids accordingly

4. Do R stuff to it.

5. Put it in pivot tables in Excel to make pretty graphs.
