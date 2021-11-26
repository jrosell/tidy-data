# Tidy Data in Python and R

In this repository you will find common examples of how to tidy data using Python pandas and R Tidyverse.

## A few definitions
- Variable: A measurement or an attribute. Height, weight, sex, etc.
- Value: The actual measurement or attribute. 152 cm, 80 kg, female, etc.
- Observation: All values measure on the same unit. Each person.

## Defining tidy data
The structure Wickham defines as tidy has the following attributes:
- Each variable forms a column and contains values
- Each observation forms a row
- Each type of observational unit forms a table

An example of a messy dataset:
|                                | Treatment A | Treatment B |
|--------------------------------|-------------|-------------|
| John Smith                     | -           | 2           |
| Jane Doe                       | 16          | 11          |
| Mary Johnson                   | 3           | 1           |
|                                |             |             |

An example of a tidy dataset:
| Name                           | Treatment   | Result      |
|--------------------------------|-------------|-------------|
| John Smith                     | a           | -           |
| Jane Doe                       | a           | 16          |
| Mary Johnson                   | a           | 3           |
| John Smith                     | b           | 2           |
| Jane Doe                       | b           | 11          |
| Mary Johnson                   | b           | 1           |

##  Tidying messy datasets 

Through the following examples extracted from Wickham’s paper, we’ll wrangle messy datasets into the tidy format. The goal here is not to analyze the datasets but rather prepare them in a standardized way prior to the analysis. These are the five types of messy datasets we’ll tackle:

- Column headers are values, not variable names.
- Multiple variables are stored in one column.
- Variables are stored in both rows and columns.
- Multiple types of observational units are stored in the same table.
- A single observational unit is stored in multiple tables.

### Python pandas

See:
- pandas/column-headers-are-values-not-variable-names.py
- pandas/multiple-tables-on-one-table.py
- pandas/multiple-variables-stored-in-one-column.py
- pandas/variables-are-stored-in-both-rows-and-columns.py
- pandas/one-type-in-multiple-tables.py


### R Tidyverse

WORK IN PROGRESS
