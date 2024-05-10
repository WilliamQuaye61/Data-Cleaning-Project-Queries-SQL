SELECT * 
FROM club_member_info$

-- CHECKING FOR DUPLICATES

WITH Duplicate_Cte AS
(
SELECT full_name,age,full_address,membership_date, ROW_NUMBER() over (partition by full_name order by full_name) as ROWnum
FROM club_member_info$
)

SELECT * 
FROM Duplicate_cte
WHERE Rownum >1

--TRIMMING FULL NAME TO REMOVE UNWANTED SPACES FROM FULL NAME

UPDATE club_member_info$
SET full_name = TRIM(full_name) ;

--SPLITTING NAMES INTO FIRST AND LAST NAME

SELECT full_name, SUBSTRING(full_name,1,CHARINDEX(' ',full_name)) first_name,
substring(full_name,CHARINDEX(' ',full_name),LEN(full_name)) last_name
FROM club_member_info$ ;

--ADDING AND UPDATING FIRST NAME AND LAST NAME COLUMN

ALTER TABLE club_member_info$
ADD First_name nvarchar(50);

UPDATE club_member_info$
SET first_name =  Upper(SUBSTRING(first_name,1,1))+Lower(SUBSTRING(first_name,2,LEN(first_name)));

ALTER TABLE club_member_info$
ADD Last_name nvarchar(50);


UPDATE club_member_info$
SET Last_name = substring(full_name,CHARINDEX(' ',full_name),LEN(full_name));

--CHANNGING FIRST NAME AND LAST NAME INT0 PROPER FORM

SELECT Replace(First_name,'?',' ')
FROM club_member_info$
WHERE First_name LIKE '?%'

SELECT First_name, Upper(SUBSTRING(first_name,1,1))+Lower(SUBSTRING(first_name,2,LEN(first_name)))
FROM club_member_info$;

UPDATE club_member_info$
SET first_name =  Upper(SUBSTRING(first_name,1,1))+Lower(SUBSTRING(first_name,2,LEN(first_name)));

SELECT Last_name, Upper(SUBSTRING(Last_name,CHARINDEX(' ',last_name),1))+Lower(SUBSTRING(Last_name,2,LEN(Last_name)))
FROM club_member_info$;

UPDATE club_member_info$
SET Last_name = TRIM(Upper(SUBSTRING(Last_name,CHARINDEX(' ',last_name),1))+Lower(SUBSTRING(Last_name,2,LEN(Last_name))));


-- ADDING PROPER FULL NAME COLUMN

ALTER TABLE club_member_info$
ADD Clean_full_Name nvarchar(50);

UPDATE club_member_info$
SET clean_full_name = First_Name + ' ' + Last_name;

--ADDING ADDRESS STREET, CITY AND STATE


ALTER TABLE club_member_info$
add Address_Street nvarchar(50);

ALTER TABLE club_member_info$
ADD Address_City nvarchar(50);

ALTER TABLE club_member_info$
ADD Address_State nvarchar(50);


SELECT PARSENAME(Replace(full_address,',','.'),3),
         PARSENAME(Replace(full_address,',','.'),2),
		 PARSENAME(Replace(full_address,',','.'),1)
FROM club_member_info$;

--UPDATING ADDRESS STREET,STATE AND CITY

UPDATE club_member_info$
SET address_street = PARSENAME(Replace(full_address,',','.'),3);

UPDATE club_member_info$
SET address_city = PARSENAME(Replace(full_address,',','.'),2);

UPDATE club_member_info$
SET address_state = PARSENAME(Replace(full_address,',','.'),1);

SELECT Clean_full_Name, REPLACE(Clean_full_Name,'?',' ')
FROM club_member_info$

--UPDATING MARITAL STATUS INTO PROPER FORM
SELECT Marital_Status,Upper(SUBSTRING(Marital_Status,1,1))+ Lower(SUBSTRING(Marital_Status,2,LEN(Marital_Status)))
FROM club_member_info$

UPDATE club_member_info$
SET Marital_Status = Upper(SUBSTRING(Marital_Status,1,1))+ Lower(SUBSTRING(Marital_Status,2,LEN(Marital_Status)))

--RENAMING COLUMN NAMES

EXEC sp_rename 'club_member_info$.martial_status', 'Marital_Status'--, 'COLUMN';

EXEC sp_rename 'club_member_info$.age', 'Age'











