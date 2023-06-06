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


