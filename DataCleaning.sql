SELECT *
From PortfolioProjectDataCleaning..NashvilleHousing 

-- Standardise Date Format

SELECT SaleDate, Convert(Date, SaleDate) 
From PortfolioProjectDataCleaning..NashvilleHousing

UPDATE NashvilleHousing 
Set SaleDate = Convert(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing 
SET SaleDateConverted = Convert(Date, SaleDate)


-- Populate Property Address Data

SELECT *
FROM PortfolioProjectDataCleaning..NashvilleHousing 
Where PropertyAddress is NULL

SELECT *
From NashvilleHousing 
ORDER by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a   
JOIN NashvilleHousing b 
    on a.ParcelID = b.ParcelID
    AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is NULL


UPDATE a 
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a   
JOIN NashvilleHousing b 
    on a.ParcelID = b.ParcelID
    AND a.[UniqueID] <> b.[UniqueID] 
Where a.PropertyAddress is NULL


-- Breaking out address into individual columns

SELECT PropertyAddress
From NashvilleHousing  
ORDER by ParcelID

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
From NashvilleHousing 

Alter TABLE NashvilleHousing
Add PropertySplitAddress NVARCHAR(255)
UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 
Alter TABLE NashvilleHousing
Add PropertySplitCity NVARCHAR(255)
UPDATE NashvilleHousing   
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) 


Select OwnerAddress
From NashvilleHousing 

SELECT
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From NashvilleHousing  

Alter TABLE NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255)
UPDATE NashvilleHousing  
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter TABLE NashvilleHousing
Add OwnerSplitCity NVARCHAR(255),
UPDATE NashvilleHousing  
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter TABLE NashvilleHousing
Add OwnerSplitState NVARCHAR(255),
UPDATE NashvilleHousing  
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

SELECT *
From NashvilleHousing  


-- Change Y and N to Yes to No in sold as vacant

SELECT Distinct(SoldAsVacant),Count(SoldAsVacant)
From NashvilleHousing
Group By SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
        When SoldAsVacant = 'N' Then 'No'
        ELSE SoldAsVacant
        END
From NashvilleHousing 

UPDATE NashvilleHousing
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
        When SoldAsVacant = 'N' Then 'No'
        ELSE SoldAsVacant
        END
From NashvilleHousing



-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
    ROW_NUMBER() Over(
        PARTITION BY ParcelID,
                    PropertyAddress,
                    SalePrice,
                    SaleDate,
                    LegalReference
                    Order by UniqueID
    ) row_num
From NashvilleHousing
--Order by ParcelID
)
-- Delete  
From RowNumCTE
Where row_num > 1
Order by ParcelID