SELECT * FROM customer_details$ ;

-- CALCULATING TOTAL CUSTOMERS

SELECT COUNT(DISTINCT [Customer ID]) as Total_customers
from customer_details$ ;


-- AVERAGE AGE OF CUSTOMERS

SELECT Round(AVG(Age),0) as Average_age
FROM customer_details$ ;

--COUNTING TOTAL NUMBER OF MALE AND FEMALE CUSTOMERS

SELECT Gender, COUNT(Gender) as Total_Number
FROM customer_details$
GROUP BY Gender ;

--CATEGORY OF PRODUCT PURCHASED THE MOST BY EACH GENDER

SELECT Gender,Category,COUNT(category) as Total_number
FROM customer_details$
GROUP BY Gender,Category
ORDER BY Gender,Total_number DESC ;

--CATEGORY OF PRODUCTS PURCHASED MOST PER SEASON

SELECT Season,COUNT(category) Total
FROM customer_details$
GROUP BY Season
ORDER BY Total DESC ;

--TOP 10 MOST ITEMS PURCHASED

SELECT TOP 10 [Item Purchased],COUNT([item Purchased]) Total
FROM customer_details$
GROUP BY [Item Purchased]
ORDER BY Total DESC ;

--TOTAL NUMBER OF CUSTOMERS WHO HAD DISCOUNT OR NOT

SELECT [Discount Applied], COUNT(*) as Total ,(count (*) * 100/((select count(*) from customer_details$))) as Percentage_
FROM customer_details$
GROUP BY [Discount Applied] ;

--FINDING MOST USED SHIPPING TYPE

SELECT [Shipping Type],COUNT([Shipping Type]) Total ,COUNT(*) * 100/(SELECT COUNT(*) FROM customer_details$) as Percentage_
from customer_details$
--where [shipping Type] <> 'Free shipping'
GROUP BY [Shipping Type]
ORDER BY Total DESC ;

--MOST USED PAYMENT METHODS

SELECT [Payment Method],COUNT([Payment Method]) Total
FROM customer_details$
GROUP BY [Payment Method]
ORDER BY Total Desc ;

--FREQUENCY OF PURCHASES

SELECT [Frequency of Purchases],COUNT([Frequency of Purchases]) Total
FROM customer_details$
GROUP BY [Frequency of Purchases]
ORDER BY Total DESC ;

--UPDATING SIZE COLUMN TO FULL NAMES

SELECT DISTINCT size from customer_details$

SELECT size, CASE
                 when size = 'L' THEN 'Large'
				 when size = 'S' THEN 'Small'
				 when size = 'M' THEN 'Medium'
				 when size = 'XL' THEN 'Xlarge'
				 Else null
				 End
FROM customer_details$ ;

UPDATE customer_details$
SET Size =  CASE
                 when size = 'L' THEN 'Large'
				 when size = 'S' THEN 'Small'
				 when size = 'M' THEN 'Medium'
				 when size = 'XL' THEN 'Xlarge'
				 Else null
				 End ;

--CHANGING INTERACTION TYPE INTO PROPER FORM

SELECT *--,Upper(SUBSTRING([interaction type],1,1)) + Substring([interaction type],2,Len([interaction type]))
FROM ['Sales Data$']

UPDATE ['Sales Data$']
SET [Interaction type] = Upper(SUBSTRING([interaction type],1,1)) + Substring([interaction type],2,Len([interaction type]))


SELECT *
FROM customer_details$ C
JOIN ['Sales Data$'] S
on c.[Customer ID] = s.[user id]

-- TOTAL AMOUNT SPENT BY CUSTOMERS ON

SELECT [Customer ID],Price, quantity,([Purchase Amount (USD)] * Quantity) as Total_Price
FROM customer_details$ C
JOIN ['Sales Data$'] S
ON c.[Customer ID] = s.[user id]

--CALCULATING TOTAL REVENUE

SELECT sum([Purchase Amount (USD)] * Quantity) as Revenue
FROM customer_details$ C
JOIN ['Sales Data$'] S
on c.[Customer ID] = s.[user id] ;

--REVENUE FOR PER MONTH

SELECT MONTH(Date) as Month_, sum([Purchase Amount (USD)] * Quantity) as Revenue
FROM customer_details$ C
join ['Sales Data$'] S
on c.[Customer ID] = s.[user id]
GROUP BY MONTH(Date)
ORDER BY Revenue DESC ;

--REVENUE PER QUARTER

SELECT Datepart(QUARTER,Date) Quarter__,sum([Purchase Amount (USD)] * Quantity) as Revenue
FROM customer_details$ C
JOIN ['Sales Data$'] S
on c.[Customer ID] = s.[user id]
GROUP BY Datepart(QUARTER,Date)
ORDER BY Revenue desc ;

--REVENUE FOR LAST 5 MONTHS OF YEAR

SELECT sum([Purchase Amount (USD)] * Quantity) as Revenue
FROM customer_details$ C
join ['Sales Data$'] S
on c.[Customer ID] = s.[user id]
WHERE Date >= DATEADD(Month,-5,(Select Max(Date) from ['Sales Data$']) ;

-- MOST INTERACTION WITH PRODUCT

SELECT [Interaction type],COUNT( [Interaction type]) Total
FROM customer_details$ C
join ['Sales Data$'] S
on c.[Customer ID] = s.[user id]
WHERE [Interaction type] is not null
GROUP BY [Interaction type]
ORDER BY Total DESC ;


SELECT Top 1 [Item Purchased],Location,COUNT([Item Purchased]) Total_Sold
FROM customer_details$ C
join ['Sales Data$'] S
on c.[Customer ID] = s.[user id]
WHERE season = 'Winter' and Location = 'New York'
GROUP BY [Item Purchased],Location
ORDER BY Total_Sold DESC ;






















