![](images/cover-photo-5.jpg)

### INTRODUCTION:

The primary objective of this project is to effectively cleanse housing data pertaining to **Nashville** by using **SQL**. The dataset exhibits numerous instances of missing values, duplicated entries, empty cells, and extraneous columns. It is imperative to thoroughly cleanse the data in order to ensure its accuracy and consistency.

<br>

### ABOUT DATASET:

For this project, I have used [**Nashville Housing Data**]( https://www.kaggle.com/datasets/tmthyjames/nashville-housing-data) dataset, which has been published by Timothy James on Kaggle, completely open access under the [**CCO: Public Domain license**]( https://creativecommons.org/publicdomain/zero/1.0/). It consists of home value data for the city Nashville. 

**Citation:**

Timothy James (2017) – “Nashville Housing Data: Home value data for the booming Nashville market”. Published online at Kaggle.com. Retrieved from: 'https://www.kaggle.com/datasets/tmthyjames/nashville-housing-data' [Online Resource]

<br>

### DATA CHARACTERIZATION:

The dataset contains details of properties in the city of Nashville which includes:

**UniqueID:**  id number attributed to a buyer within the dataset.

**ParcelID:** code attributed to a land for tax purpose.

**LandUse:** shows the different uses of land.

**PropertyAddress:** the distinct address allocated to each property.

**SaleDate:** date when the land was sold.

**SalePrice:** the cost of land at which it has been sold.

**LegalReference:** citation is the practice of crediting and referring to authoritative documents and sources.

**SoldAsVacant:** vacancy at the time of sale.

**OwnerName:** name of land owner.

**OwnerAddress:** the distinct owner address.

**Acreage:** the size of an area of land in acres.

**TaxDistrict:** the district in which building is legally registered for tax purpose.

**LandValue:** the worth of the land.

**BuildingValue:** worth of a building.

**TotalValue:** combined value of land with building.

**YearBuilt:** the year in which the building was built.

**FullBath:** a bathroom that includes a shower, a bathtub, a sink, and a toilet.

**HalfBath:** a category of bathroom which includes only a sink and a toilet.

**Bedrooms:** the number of bedrooms in the property.

<br>

### INITIAL WORKING:

This project will include cleaning the data of Nashville housing properties, sold between January 2013 and December 2016. Further I have converted the dataset from CSV to Excel format and then import it on Microsoft SQL Server Management Studio. The excel file can be found in my Github repository.

<br>

### DATA CLEANING:

Below is the working that I have done in Microsoft SQL Server to clean the dataset.

<style type="text/css">
  .gist {width:100% !important;}
  .gist-file
  .gist-data {max-height: 500px;max-width: 100%;}
</style>

<script src="https://gist.github.com/nlaeeq/fa89b25b98ea405a0a8298c92098e007.js"></script>

<br>

### DATA CLEANING TASKS:

**Changing the date format:**

The format of the SaleDate column is in date-time format which needs to be converted to date format YYYY-MM-DD for standardization, as the time factor does not serve any purpose in our analysis.

**Identifying and Assigning values to NULL cells in PropertyAddress column:**

There are few values in the PropertyAddress column which are blank (NULL). However, every property must contain a unique address. Therefore the data needs to be populated in those rows.

**Changing the structure of PropertyAddress column:**

The values in PropertyAddress column consists of combination of address and city information in the same cell. It needs to be split into two separate columns. 

**Changing the structure of OwnerAddress column:**

The OwnerAddress values contains address, city and state. It needs to be separated into three distinct columns.

**Correcting the labels in SoldAsVacant column:**

The responses recorded in this column contain four labels. Yes, No, Y, N. In order to make data consistent I will be changing the Y and N to Yes and No respectively.

**Removing duplicate rows:**

The rows containing duplicate values have been removed on the basis of PropertyAddress, SaleDate, SalePrice and LegalReference.

**Deleting the unnecessary columns:**

There are some columns which do not serve any purpose in our analysis such as OwnerAddress, TaxDistrict, PropertyAddress. Therefore I am deleting them.

<br>

**Thank you for reading this project.**
