/* 

Cleaning data in SQL queries

*/

Select *
From [PortfolioProject]..[NashvilleHousing]

-- Standardize Date Format

Select SaleDate, Convert(Date,SaleDate)
From [PortfolioProject]..[NashvilleHousing]

Update [PortfolioProject]..[NashvilleHousing]
Set SaleDate = Convert(Date,SaleDate)

-- Populate Property Address data 

Update [PortfolioProject]..[NashvilleHousing]
Set PropertyAddress = null
Where PropertyAddress = ' '

Select *
From [PortfolioProject]..[NashvilleHousing]
Order By ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
From [PortfolioProject]..[NashvilleHousing] a
Join [PortfolioProject]..[NashvilleHousing] b
On a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress) 
From [PortfolioProject]..[NashvilleHousing] a
Join [PortfolioProject]..[NashvilleHousing] b
On a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into individual columns (Address, City, State) 
-- Property Address 

Select PropertyAddress
From [PortfolioProject]..[NashvilleHousing]

Select PropertyAddress,
Substring(PropertyAddress, 1, Charindex(',', PropertyAddress) -1) as Address,
Substring(PropertyAddress, Charindex(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
From [PortfolioProject]..[NashvilleHousing]

Alter table [PortfolioProject]..[NashvilleHousing]
Add PropertySplitAddress Nvarchar(255)

Update [PortfolioProject]..[NashvilleHousing]
Set PropertySplitAddress = Substring(PropertyAddress, 1, Charindex(',', PropertyAddress) -1)

Alter table [PortfolioProject]..[NashvilleHousing]
Add PropertySplitCity Nvarchar(255)

Update [PortfolioProject]..[NashvilleHousing]
Set PropertySplitCity = Substring(PropertyAddress, Charindex(',', PropertyAddress) +1, LEN(PropertyAddress)) 

-- Owner Address

Select OwnerAddress
From [PortfolioProject]..[NashvilleHousing]

Select 
ParseName(Replace(OwnerAddress, ',', '.'), 3) as address
,ParseName(Replace(OwnerAddress, ',', '.'), 2) as city
,ParseName(Replace(OwnerAddress, ',', '.'), 1) as state
From [PortfolioProject]..[NashvilleHousing]

Alter table [PortfolioProject]..[NashvilleHousing]
Add OwnerSplitAddress Nvarchar(255)

Update [PortfolioProject]..[NashvilleHousing]
Set OwnerSplitAddress = ParseName(Replace(OwnerAddress, ',', '.'), 3)

Alter table [PortfolioProject]..[NashvilleHousing]
Add OwnerSplitCity Nvarchar(255)

Update [PortfolioProject]..[NashvilleHousing]
Set OwnerSplitCity = ParseName(Replace(OwnerAddress, ',', '.'), 2)

Alter table [PortfolioProject]..[NashvilleHousing]
Add OwnerSplitState Nvarchar(255)

Update [PortfolioProject]..[NashvilleHousing]
Set OwnerSplitState = ParseName(Replace(OwnerAddress, ',', '.'), 1)

-- Change Y and N to Yes and No in "SoldasVacant" field

Select Distinct SoldAsVacant, Count(SoldAsVacant)
From [PortfolioProject]..[NashvilleHousing]
Group by SoldAsVacant
Order by 2

Select SoldasVacant, 
Case When SoldasVacant = 'Y' Then 'Yes'
	When SoldasVacant = 'N' Then 'No'
	Else SoldAsVacant 
	End
From [PortfolioProject]..[NashvilleHousing]

Update [PortfolioProject]..[NashvilleHousing]
Set SoldasVacant = Case When SoldasVacant = 'Y' Then 'Yes'
	When SoldasVacant = 'N' Then 'No'
	Else SoldAsVacant 
	End

-- Remove Duplicates

With RowNumCTE as(
Select *, 
	Row_Number() Over (
	Partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference 
	Order by UniqueID
	) row_num
From [PortfolioProject]..[NashvilleHousing]
)
Delete
From RowNumCTE
Where row_num > 1

-- Delete Unused Columns

Select * 
From [PortfolioProject]..[NashvilleHousing]

Alter Table [PortfolioProject]..[NashvilleHousing]
Drop Column PropertyAddress, OwnerAddress, TaxDistrict
