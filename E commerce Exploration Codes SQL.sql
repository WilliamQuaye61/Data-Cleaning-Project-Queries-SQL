select * from customer_details$ ;

-- CALCULATING TOTAL CUSTOMERS

select count(distinct [Customer ID]) as Total_customers
from customer_details$ ;


-- AVERAGE AGE OF CUSTOMERS

select Round(AVG(Age),0) as Average_age
from customer_details$ ;

--COUNTING TOTAL NUMBER OF MALE AND FEMALE CUSTOMERS

Select Gender, count(Gender) as Total_Number
from customer_details$
group by Gender ;

--CATEGORY OF PRODUCT PURCHASED THE MOST BY EACH GENDER

Select Gender,Category,count(category) as Total_number
from customer_details$
Group by Gender,Category
order by Gender,Total_number desc ;

--CATEGORY OF PRODUCTS PURCHASED MOST PER SEASON

select Season,count(category) Total
from customer_details$
group by Season
order by Total desc ;

--TOP 10 MOST ITEMS PURCHASED

select TOP 10 [Item Purchased],count([item Purchased]) Total
from customer_details$
Group by [Item Purchased]
order by Total desc ;

--TOTAL NUMBER OF CUSTOMERS WHO HAD DISCOUNT OR NOT

select [Discount Applied], COUNT(*) as Total ,(count (*) * 100/((select count(*) from customer_details$))) as Percentage_
from customer_details$
group by [Discount Applied] ;

--FINDING MOST USED SHIPPING TYPE

Select [Shipping Type],count([Shipping Type]) Total ,count(*) * 100/(select count(*) from customer_details$) as Percentage_
from customer_details$
--where [shipping Type] <> 'Free shipping'
group by [Shipping Type]
order by Total desc ;

--MOST USED PAYMENT METHODS

Select [Payment Method],COUNT([Payment Method]) Total
from customer_details$
group by [Payment Method]
order by Total Desc ;

--FREQUENCY OF PURCHASES

Select [Frequency of Purchases],COUNT([Frequency of Purchases]) Total
from customer_details$
group by [Frequency of Purchases]
order by Total desc ;

--UPDATING SIZE COLUMN TO FULL NAMES

Select distinct size from customer_details$

Select size, Case
                 when size = 'L' THEN 'Large'
				 when size = 'S' THEN 'Small'
				 when size = 'M' THEN 'Medium'
				 when size = 'XL' THEN 'Xlarge'
				 Else null
				 End
from customer_details$ ;

update customer_details$
set Size =  Case
                 when size = 'L' THEN 'Large'
				 when size = 'S' THEN 'Small'
				 when size = 'M' THEN 'Medium'
				 when size = 'XL' THEN 'Xlarge'
				 Else null
				 End ;

--CHANGING INTERACTION TYPE INTO PROPER FORM

Select *--,Upper(SUBSTRING([interaction type],1,1)) + Substring([interaction type],2,Len([interaction type]))
FROM ['Sales Data$']

Update ['Sales Data$']
set [Interaction type] = Upper(SUBSTRING([interaction type],1,1)) + Substring([interaction type],2,Len([interaction type]))


select *
from customer_details$ C
join ['Sales Data$'] S
on c.[Customer ID] = s.[user id]

-- TOTAL AMOUNT SPENT BY CUSTOMERS ON

select [Customer ID],Price, quantity,([Purchase Amount (USD)] * Quantity) as Total_Price
from customer_details$ C
join ['Sales Data$'] S
on c.[Customer ID] = s.[user id]

--CALCULATING TOTAL REVENUE

select sum([Purchase Amount (USD)] * Quantity) as Revenue
from customer_details$ C
join ['Sales Data$'] S
on c.[Customer ID] = s.[user id] ;

--REVENUE FOR PER MONTH

select MONTH(Date) as Month_, sum([Purchase Amount (USD)] * Quantity) as Revenue
from customer_details$ C
join ['Sales Data$'] S
on c.[Customer ID] = s.[user id]
Group by MONTH(Date)
order by Revenue desc ;

--REVENUE PER QUARTER

select Datepart(QUARTER,Date) Quarter__,sum([Purchase Amount (USD)] * Quantity) as Revenue
from customer_details$ C
join ['Sales Data$'] S
on c.[Customer ID] = s.[user id]
Group by Datepart(QUARTER,Date)
order by Revenue desc ;

--REVENUE FOR LAST 5 MONTHS OF YEAR

select sum([Purchase Amount (USD)] * Quantity) as Revenue
from customer_details$ C
join ['Sales Data$'] S
on c.[Customer ID] = s.[user id]
Where Date >= DATEADD(Month,-5,(Select Max(Date) from ['Sales Data$']) ;

-- MOST INTERACTION WITH PRODUCT

select [Interaction type],COUNT( [Interaction type]) Total
from customer_details$ C
join ['Sales Data$'] S
on c.[Customer ID] = s.[user id]
Where [Interaction type] is not null
Group by [Interaction type]
order by Total desc


select Top 1 [Item Purchased],Location,COUNT([Item Purchased]) Total_Sold
from customer_details$ C
join ['Sales Data$'] S
on c.[Customer ID] = s.[user id]
where season = 'Winter' and Location = 'New York'
Group by [Item Purchased],Location
order by Total_Sold desc






















