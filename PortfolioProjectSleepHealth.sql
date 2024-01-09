/* Sleep Health data exploration

Skills used: Data Cleaning: Updating table/adding columns/creating bins, Windows Functions, Aggregate Functions

*/
Select * 
From [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle 

--Data Cleaning: Merging 'Normal Weight' and 'Normal' under BMI_Category
Select Distinct(BMI_Category)
From [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle 

Update [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Set BMI_Category = 'Normal'
Where BMI_Category = 'Normal Weight'

--Data Cleaning: Merging 'Sales Representative' and 'Salesperson' under BMI_Category
Select Distinct(Occupation)
From [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle 

Update [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Set Occupation = 'Sales Representative'
Where Occupation = 'Salesperson'

--Data Cleaning: Creating bins for Quality_of_Sleep into new column Quality_of_Sleep_Bins
Alter Table [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle 
Add Quality_of_Sleep_Bins nvarchar(10)

Update [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Set Quality_of_Sleep_Bins = 'Very Poor'
Where Quality_of_Sleep in (1, 2)

Update [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Set Quality_of_Sleep_Bins = 'Poor'
Where Quality_of_Sleep in (3, 4)

Update [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Set Quality_of_Sleep_Bins = 'Average'
Where Quality_of_Sleep in (5,6)

Update [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Set Quality_of_Sleep_Bins = 'Good'
Where Quality_of_Sleep in (7,8)

Update [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Set Quality_of_Sleep_Bins = 'Very Good'
Where Quality_of_Sleep in (9,10)

--Data Cleaning: Creating bins for stress level
Select Distinct(Stress_Level)
From [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle 

Alter Table [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle 
Add Stress_Level_Bins nvarchar(20)

Update [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Set Stress_Level_Bins = 'Low Stress'
Where Stress_Level Between 1 and 3

Update [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Set Stress_Level_Bins = 'Moderate Stress'
Where Stress_Level Between 4 and 6

Update [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Set Stress_Level_Bins = 'High Stress'
Where Stress_Level Between 7 and 10

--Data Cleaning: Creating bins for Daily_Steps into new column Daily_Steps_Bins
Alter Table [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle 
Add Daily_Steps_Bins nvarchar(10)

Update [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Set Daily_Steps_Bins = 'Low'
Where Daily_Steps Between 1000 and 3900

Update [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Set Daily_Steps_Bins = 'Moderate'
Where Daily_Steps Between 4000 and 6900

Update [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Set Daily_Steps_Bins = 'High'
Where Daily_Steps Between 7000 and 10000

--Data Cleaning: Creating Bins for Physical_Activity Level into new column Physical_Activity_Level_Bins
Alter Table [Sleep Health Dataset].dbo.Sleep_Health_and_lifestyle
Add Physical_Activity_Level_Bins nvarchar(10)

Update [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Set Physical_Activity_Level_Bins = 'Low'
Where Physical_Activity_Level Between 10 and 39

Update [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Set Physical_Activity_Level_Bins = 'Moderate'
Where Physical_Activity_Level Between 40 and 69

Update [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Set Physical_Activity_Level_Bins = 'High'
Where Physical_Activity_Level Between 70 and 100

---Looking at how physical activity levels can affect quality of sleep---
Select Physical_Activity_Level_Bins, Quality_of_Sleep_Bins, Count(Physical_Activity_Level_Bins) as Count_of_Pollers
From [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Group By Physical_Activity_Level_Bins, Quality_of_Sleep_Bins
Order By 
	Case 
		When Physical_Activity_Level_Bins = 'Low' Then 0 
		When Physical_Activity_Level_Bins = 'Moderate' Then 1
		When Physical_Activity_Level_Bins = 'High' Then 2
		End Asc,
	Case
		When Quality_of_Sleep_Bins = 'Poor' Then 0
		When Quality_of_Sleep_Bins = 'Average' Then 1
		When Quality_of_Sleep_Bins = 'Good' Then 2
		When Quality_of_Sleep_Bins = 'Very Good' Then 3 
		End Asc

--Comparing quality of sleep and BMI
Select Quality_of_Sleep_Bins, BMI_Category, Count(Quality_of_Sleep_Bins) as Count_of_Pollers
From [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Group By Quality_of_Sleep_Bins, BMI_Category
Order by 
	Case 
		When Quality_of_Sleep_Bins = 'Very Poor' Then 0 
		When Quality_of_Sleep_Bins = 'Poor' Then 1
		When Quality_of_Sleep_Bins = 'Average' Then 2
		When Quality_of_Sleep_Bins = 'Good' Then 3
		When Quality_of_Sleep_Bins = 'Very Good' Then 4
		End Asc, 
BMI_Category Asc 

--Shows how physical activity affects the relationship between BMI and quality of sleep
Select Physical_Activity_Level_Bins, BMI_Category, Quality_of_Sleep_Bins, Count(Physical_Activity_Level_Bins) as Count_of_Pollers
From [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Group By Physical_Activity_Level_Bins, Quality_of_Sleep_Bins, BMI_Category
Order By 
	Case 
		When Physical_Activity_Level_Bins = 'Low' Then 0 
		When Physical_Activity_Level_Bins = 'Moderate' Then 1
		When Physical_Activity_Level_Bins = 'High' Then 2
		End Asc 

--Looking at relationship between sleep disorders and quality of sleep
Select Sleep_Disorder, Quality_of_Sleep_Bins, Count(Sleep_Disorder) as Count_of_Pollers
From [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Group by Sleep_Disorder, Quality_of_Sleep_Bins
Order by Sleep_Disorder,
	Case
		When Quality_of_Sleep_Bins = 'Poor' Then 0
		When Quality_of_Sleep_Bins = 'Average' Then 1
		When Quality_of_Sleep_Bins = 'Good' Then 2
		When Quality_of_Sleep_Bins = 'Very Good' Then 3 
		End Asc

--Shows how physical activity level affects the relationship between sleep disorders and quality of sleep
Select Sleep_Disorder, Quality_of_Sleep_Bins, Physical_Activity_Level_Bins, Count(Sleep_Disorder) as Count_of_Pollers
From [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Group by Sleep_Disorder, Physical_Activity_Level_Bins, Quality_of_Sleep_Bins
Order by Sleep_Disorder, 
	Case
		When Quality_of_Sleep_Bins = 'Poor' Then 0
		When Quality_of_Sleep_Bins = 'Average' Then 1
		When Quality_of_Sleep_Bins = 'Good' Then 2
		When Quality_of_Sleep_Bins = 'Very Good' Then 3 
		End Asc

---Quality of Sleep by gender---
--Showing even spread of male and female pollers 
Select Count(Case When Gender='Male' Then 1 End) as Male_Count, Count(Case When Gender = 'Female' Then 1 End) as Female_Count
From [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle

--Looking at distribution of quality of sleep by gender
Select Quality_of_Sleep_Bins, Count(Case When Gender='Male' Then 1 End) as Male_Count, Count(Case When Gender = 'Female' Then 1 End) as Female_Count, Count(Gender) as Total_Pollers_Count
From [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Group by Quality_of_Sleep_Bins
Order by 
	Case
		When Quality_of_Sleep_Bins = 'Poor' Then 0
		When Quality_of_Sleep_Bins = 'Average' Then 1
		When Quality_of_Sleep_Bins = 'Good' Then 2
		When Quality_of_Sleep_Bins = 'Very Good' Then 3 
		End Asc

--Looking at relationship between stress level and gender
Select Stress_Level_Bins, Gender, Count(Stress_Level_Bins) as Count_of_Pollers
From [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Group by Stress_Level_Bins, Gender
Order by Gender,
	Case 
		When Stress_Level_Bins = 'Low Stress' Then 0 
		When Stress_Level_Bins = 'Moderate Stress' Then 1
		When Stress_Level_Bins = 'High Stress' Then 2
		End Asc

--Showing relationship between level of stress and quality of sleep
Select Stress_Level_Bins, Quality_of_Sleep_Bins, Count(Stress_Level_Bins) as Count_of_Pollers
From [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Group by Quality_of_Sleep_Bins, Stress_Level_Bins
Order by 	
	Case 
		When Stress_Level_Bins = 'Low Stress' Then 0 
		When Stress_Level_Bins = 'Moderate Stress' Then 1
		When Stress_Level_Bins = 'High Stress' Then 2
		End Asc,
	Case
		When Quality_of_Sleep_Bins = 'Poor' Then 0
		When Quality_of_Sleep_Bins = 'Average' Then 1
		When Quality_of_Sleep_Bins = 'Good' Then 2
		When Quality_of_Sleep_Bins = 'Very Good' Then 3 
		End Asc

---Looking at relationship between occupation and quality of sleep in **top three populated occupations: nurse, doctor, engineer**
--Showing the top three populated occupations
Select Occupation, Count(Occupation) as Number_of_Pollers
From [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Group by Occupation
Order by Count(Occupation) Desc

--Showing relationship between stress level and quality of sleep 
Select Stress_Level_Bins, Quality_of_Sleep_Bins, Count(Stress_Level_Bins) as Number_of_Pollers
From [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Where Occupation = 'Nurse' OR Occupation = 'Doctor' OR Occupation = 'Engineer'
Group by Stress_Level_Bins, Quality_of_Sleep_Bins
Order by 	
	Case 
		When Stress_Level_Bins = 'Low Stress' Then 0 
		When Stress_Level_Bins = 'Moderate Stress' Then 1
		When Stress_Level_Bins = 'High Stress' Then 2
		End Asc,
	Case
		When Quality_of_Sleep_Bins = 'Poor' Then 0
		When Quality_of_Sleep_Bins = 'Average' Then 1
		When Quality_of_Sleep_Bins = 'Good' Then 2
		When Quality_of_Sleep_Bins = 'Very Good' Then 3 
		End Asc

--Looking at occupations and associated stress levels
Select Stress_Level_Bins, Occupation, Count(Stress_Level_Bins) as Number_of_Pollers
From [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Where Occupation = 'Nurse' OR Occupation = 'Doctor' OR Occupation = 'Engineer'
Group by Stress_Level_Bins, Occupation
Order by 	
	Case 
		When Stress_Level_Bins = 'Low Stress' Then 0 
		When Stress_Level_Bins = 'Moderate Stress' Then 1
		When Stress_Level_Bins = 'High Stress' Then 2
		End Asc,
Occupation

--Looking at relationship between occupation and quality of sleep
Select Occupation, Quality_of_Sleep_Bins, Count(Occupation) as Number_of_Pollers
From [Sleep Health Dataset].dbo.Sleep_health_and_lifestyle
Where Occupation = 'Nurse' OR Occupation = 'Doctor' OR Occupation = 'Engineer'
Group by Occupation, Quality_of_Sleep_Bins
Order by Occupation,
	Case
		When Quality_of_Sleep_Bins = 'Poor' Then 0
		When Quality_of_Sleep_Bins = 'Average' Then 1
		When Quality_of_Sleep_Bins = 'Good' Then 2
		When Quality_of_Sleep_Bins = 'Very Good' Then 3 
		End Asc