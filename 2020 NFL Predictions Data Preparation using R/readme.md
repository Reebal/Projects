2020 NFL Predictions Data Preparation:

This project focuses on the preparation and cleaning of a dataset related to NFL predictions for the year 2020 using R markdown. 
The dataset is sourced from Elo ratings and includes various statistics related to NFL teams and games.

Data Cleaning Steps:

The following steps were undertaken to clean and prepare the data for analysis:
1. Correcting data types: Identified and corrected the mismatched data types
2. Combining sheets: After correcting the data types, combined the 2 sheets into 1
3. Date formatting: Converted the date column to a proper date format and removed irrelevant dates.
4. Outlier detection: Removed a row with an unusual date (1905-07-12) as it is irrelevant in a 2020 NFL prediction dataset
5. Season correction: Ensured all season values are set to 2020.
6. Handled missing values and outliers (positive and negative) in the rest of the columns
- The playoff column was addressed by labeling missing values as NA.
- Removed the neutral column due to irrelevance.
- Handled missing values in the team1 and team2 columns by imputing based on corresponding quarterback data.
- Corrected abbreviations for teams (e.g., OAKLAND to OAK).
7. Final Checks: Conducted summary statistics and tables to ensure all values are consistent and correctly filled.
8. Exported the cleaned dataset
  
Files Included:

- data_prep_nfl.Rmd: RMarkdown file containing the data preparation code.
- data_prep_nfl.html: Rendered output file from the RMarkdown analysis.
- data_prep_nfl.knit.pdf: Output file in pdf format
- nfl_elo_latest.xlsx: Original dataset containing NFL predictions.
- cleaned_dataset.csv: Final cleaned dataset ready for analysis.
