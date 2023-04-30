/* 

Data Cleaning in SQL

*/


--Confirming that complete dataset has been uploaded from Nashville Housing spreadsheet.

SELECT 
 *
FROM 
 Portfolio_Project.dbo.Nashville_Housing


--Standardize 'SaleDate' column by converting date-time format to date format

SELECT 
 SaleDate, 
 CONVERT(Date, SaleDate)
FROM 
 Portfolio_Project.dbo.Nashville_Housing
 

--Add a new column in dataset and update the 'sale date' values to new column 'Sale_Date_Converted' to date format.

ALTER TABLE 
 Nashville_Housing
ADD 
 Sale_Date_Converted Date;

UPDATE 
 Nashville_Housing
SET 
 Sale_Date_Converted = CONVERT(Date, SaleDate)


--Now check the converted format of new column. This must appear in YYYY-MM-DD

SELECT 
 Sale_Date_Converted
FROM 
 Portfolio_Project.dbo.Nashville_Housing 


--Identifying the rows where property address column contain NULL values.

SELECT 
 PropertyAddress
FROM 
 Portfolio_Project.dbo.Nashville_Housing 
WHERE 
 PropertyAddress is null 


--Checking 'Property Address' against 'Parcel ID' 
--This query displays that in many of the rows the parcel id is same against the same property address.

SELECT 
 ParcelID, PropertyAddress
FROM 
 Portfolio_Project.dbo.Nashville_Housing
ORDER BY 
 ParcelID 


--Using parcel id as reference point to check the missing values in 'property_address' by joining the table to itself
--If parcel ID NH1 matches with NH2, but unique ID is distinct then populate the address value of Parcel ID NH1(where there is a null value) with the address in parcel ID NH2(where there is no null value).

SELECT 
 NH1.ParcelID, NH1.PropertyAddress, NH2.ParcelID, NH2.PropertyAddress
FROM 
 Portfolio_Project.dbo.Nashville_Housing NH1
JOIN 
 Portfolio_Project.dbo.Nashville_Housing NH2
 ON NH1.ParcelID = NH2.ParcelID
 AND NH1.UniqueID <> NH2.UniqueID
WHERE 
 NH1.PropertyAddress is null


--Now lets update alias NH1 with property address values from alias NH2.

UPDATE 
 NH1
SET 
 PropertyAddress = ISNULL(NH1.PropertyAddress, NH2.PropertyAddress)
FROM 
 Portfolio_Project.dbo.Nashville_Housing NH1
JOIN 
 Portfolio_Project.dbo.Nashville_Housing NH2
 ON NH1.ParcelID = NH2.ParcelID
 AND NH1.UniqueID <> NH2.UniqueID
WHERE 
 NH1.PropertyAddress is null 


--Create two new columns in dataset for splitting Address and City separately from 'property address' column

ALTER TABLE 
 Nashville_Housing
ADD
 Property_Split_Address Nvarchar(255)

ALTER TABLE 
 Nashville_Housing
ADD 
 Property_Split_City Nvarchar(255)


--Split the 'property address' and update the values in two different columns

UPDATE 
 Nashville_Housing
SET 
 Property_Split_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1)

UPDATE 
 Nashville_Housing
SET 
 Property_Split_City = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress))


--Check the dataset for update.

SELECT 
 Top 10 Property_Split_Address, Property_Split_City
FROM 
 Portfolio_Project.dbo.Nashville_Housing


--Create three new columns in dataset for splitting Address, City and State separately from 'Owner address' column

ALTER TABLE 
 Nashville_Housing
ADD 
 Owner_Split_Address nvarchar(255), 
 Owner_Split_City nvarchar(255),
 Owner_Split_State nvarchar(255)


--Split the 'Owner address' and update the values in the columns we have created in above query

UPDATE
 Nashville_Housing
SET 
 Owner_Split_Address = PARSENAME(REPLACE(OwnerAddress, ',' ,'.' ),3), 
 Owner_Split_City = PARSENAME(REPLACE(OwnerAddress, ',' , '.' ),2),
 Owner_Split_State = PARSENAME(REPLACE(OwnerAddress, ',' , '.' ),1)


--Checking the values for column 'Sold as vacant'
--The query show that there are four label values instead of two. (Y,N,Yes,No)

SELECT 
 DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
FROM 
 Portfolio_Project.dbo.Nashville_Housing 
GROUP BY 
 SoldAsVacant 
ORDER BY 
 2 


--Changing the Y,N to Yes and No respectively in Sold as vacant column

UPDATE 
 Nashville_Housing
SET 
 SoldAsVacant = CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END


--Removing the rows having duplicate values based on PropertyAddress, SaleDate, SalePrice, LegalReference
--First checking it by using CTE and windows functions to partition them 

WITH 
 Row_Num_CTE AS (
SELECT 
 * ,
	ROW_NUMBER() OVER 
	(
	PARTITION BY 
		ParcelID, 
		PropertyAddress, 
		SaleDate, 
		SalePrice, 
		LegalReference
	ORDER BY 
	UniqueID
	) AS row_num
FROM 
 Portfolio_Project.dbo.Nashville_Housing
)
SELECT 
 *
FROM 
 Row_Num_CTE
WHERE 
 row_num > 1 
ORDER BY 
 PropertyAddress 


--Now actually deleting the duplicate rows

WITH 
 Row_Num_CTE AS (
 SELECT * ,
	ROW_NUMBER() OVER 
	(
	PARTITION BY 
		ParcelID, 
		PropertyAddress, 
		SaleDate, 
		SalePrice, 
		LegalReference
	ORDER BY
	UniqueID
	) AS row_num
FROM
 Portfolio_Project.dbo.Nashville_Housing
)
DELETE 
FROM 
 Row_Num_CTE
WHERE 
 row_num > 1 


--Deleting unrequired columns to make data more clean

ALTER TABLE 
 Nashville_Housing
DROP COLUMN 
 SaleDate, OwnerAddress, TaxDistrict, PropertyAddress

SELECT 
 *
FROM 
 Portfolio_Project.dbo.Nashville_Housing