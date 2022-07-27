/* 

Cleaning Data Using SQl Queries.

*/

Select *
From PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------
--Standardizing SALEDATE Column  -->DATE Format

/*
-- USIng CAST
Select SaleDate,CAST(SaleDate as DATE)
From PortfolioProject.dbo.NashvilleHousing
*/


Select SaleDate,CONVERT(DATE, SaleDate)
From PortfolioProject.dbo.NashvilleHousing


Alter TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(DATE, SaleDate)



--------------------------------------------------------------------------------------------------------------------

-- Property Adress Data


Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is NULL 
Order By ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress is NULL


Update a
SET PropertyAddress =  ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress is NULL


----------------------------------------------------------------------------------

-- Breaking Out PropertyAddress into Individual Columns -->Adddress, City, State


Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) As Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) As Address

From PortfolioProject.dbo.NashvilleHousing

--Adding NEW Column PropertySplitAddress and then Update 
ALTER Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255)

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

--Adding NEW Column PropertySplitCity and then Update
ALTER Table NashvilleHousing
Add PropertySplitCity nvarchar(255)

Update NashvilleHousing
SET  PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing



Select 
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)

From PortfolioProject.dbo.NashvilleHousing


ALTER Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255)

Update NashvilleHousing
SET  OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3)


ALTER Table NashvilleHousing
Add  OwnerSplitCity Nvarchar(255)

Update NashvilleHousing
SET  OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2)


ALTER Table NashvilleHousing
Add  OwnerSplitState Nvarchar(255)

Update NashvilleHousing
SET  OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)


----------------------------------------------------------------------------------------------------------------------

-- Change Y and N to YES and NO for column : SoldAsVacant

/*
Select SoldAsVacant, COUNT(*) as quantity
From PortfolioProject.dbo.NashvilleHousing
Group BY SoldAsVacant
Order By 2 DESC
*/

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group BY SoldAsVacant
Order By 2 DESC



Select SoldAsVacant,
	CASE When SoldAsVacant = 'Y' Then 'YES'
		 When SoldAsVacant = 'N'  Then 'NO'
		 Else SoldAsVacant
	END
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'YES'
						When SoldAsVacant = 'N'  Then 'NO'
						Else SoldAsVacant
					END


-------------------------------------------------------------------------------------------------------------------

-- Delete Unused columns

Select *
From PortfolioProject.dbo.NashvilleHousing


Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate