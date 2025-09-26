# Census Bureau APIs

- Details of data (tables, descriptions, codes, etc): https://api.census.gov/data.html
- List of available APIs: https://www.census.gov/data/developers/data-sets.html

## ACS

- Search for these phrases in above link for 2023 year:
  - "ACS 5-Year Detailed Tables"
    - Metadata: https://api.census.gov/data/2023/acs/acs5
    - Variables: https://api.census.gov/data/2023/acs/acs5/variables.json
    - 64,000 variables!
    - Numbers about almost everything imaginable
    

  - "ACS 5-Year Comparison Profiles"
    - Metadata and links to more metadata: https://api.census.gov/data/2023/acs/acs5/cprofile
    - Link to the list of variables: https://api.census.gov/data/2023/acs/acs5/cprofile/variables.json
      - Two related codes: 2023 and 2018 (hence, the comparison profile)
        - e.g., `CP05_2018_048E`, `CP05_2023_048E`
    - Most (all?) codes return type is float, which is a percentage
    - This makes comparison easier I guess
    - E.g., both above codes return a float - 1.2 and 1.3 respectively

  - "ACS 5-Year Data Profiles"
    - https://api.census.gov/data/2023/acs/acs5/profile

  - "2023 American Community Survey: 5-Year Estimates - Public Use Microdata
    Sample"
    - https://api.census.gov/data/2023/acs/acs5/pums
    - Weird description: area partitioning state into contiguous etc..
    
  - "ACS 1-Year"
    - Data profile: https://api.census.gov/data/2023/acs/acs1/profile
    - etc (CP also exists)
    
### ACS Codes Can Change

- ACS code for the same data point (e.g., "Asian Indian population") can change across years
- This can happen anytime a table is reordered
- Solution:
  - For a given year, first make a call to its `variables.json`
    file e.g., https://api.census.gov/data/2023/acs/acs1/profile/variables.json
  - Search that JSON for the label you are interested in (e.g., `Estimate!!RACE!!Total population!!Asian!!Asian Indian`).
  - From that entry, get the corresponding variable code (e.g., `DP05_0048E`)
  - Use that code in your actual data query for that year

### ACS 1-Year Data Sets

- For year over year comparison, app could query the population of the area, and if it is 
  greater than 65,000, the app could safely assume that ACS1 exists for it
  
  
### ACS 5-Year Survey Frequency 

- A new 5-year data set is released every single year.

- Think of it like a rolling average. The Census Bureau is continuously collecting survey data every month.
  Each year, they release new data product that pools the previous 60 months (5 years) of responses.

For example:

- The 2022 ACS 5-Year Estimates contain data collected from January 1, 2018, to December 31, 2022.

- The 2023 ACS 5-Year Estimates contain data collected from January 1, 2019, to December 31, 2023.

So, while each dataset represents a five-year period, a fresh dataset with a slightly shifted five-year window
comes out annually. This provides the most reliable and up-to-date information for small geographic areas.


### ACS 5-Year Codes From 2023 Survey

- List of all data profile variables: https://api.census.gov/data/2023/acs/acs5/profile/variables.json

#### Overview 

- DP05_0001E
  - Total population
  - label: "Estimate!!SEX AND AGE!!Total population"
  
- DP05_0018E
  - Median Age (years)
  - label: "Estimate!!SEX AND AGE!!Total population!!Median age (years)"
  
- DP03_0062E
  - Median household income
  - label: "Estimate!!INCOME AND BENEFITS (IN 2023 INFLATION-ADJUSTED DOLLARS)!!Total households!!Median household income (dollars)"
  
- DP02_0067PE
  - High school graduate or higher
  - label: "Percent!!EDUCATIONAL ATTAINMENT!!Population 25 years and over!!High school graduate or higher"
  
- DP03_0119PE
  - Poverty rate
  - label: "Percent!!PERCENTAGE OF FAMILIES AND PEOPLE WHOSE INCOME IN THE PAST 12 MONTHS IS BELOW THE POVERTY LEVEL!!All families"
  
- DP04_0046PE
  - Owner-occupied housing units
  - label: "Percent!!HOUSING TENURE!!Occupied housing units!!Owner-occupied"
  
- DP03_0025E
  - Avg commute time
  - label: "Estimate!!COMMUTING TO WORK!!Workers 16 years and over!!Mean travel time to work (minutes)"
  
- DP04_0089E
  - Median Home Value
  - label: "Estimate!!VALUE!!Owner-occupied units!!Median (dollars)"
  
- DP03_0009PE
 - Unemployment rate
 - label: "Percent!!EMPLOYMENT STATUS!!Civilian labor force!!Unemployment Rate"
 
 
#### Social

#### Economic

#### Demographic

#### Housing

