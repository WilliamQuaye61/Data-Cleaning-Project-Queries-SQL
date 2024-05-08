select * 
from club_member_info$

-- CHECKING FOR DUPLICATES

With Duplicate_Cte as
(
select full_name,age,full_address,membership_date, ROW_NUMBER() over (partition by full_name order by full_name) as ROWnum
from club_member_info$
)

select * 
from Duplicate_cte
where Rownum >1

--TRIMMING FULL NAME TO REMOVE UNWANTED SPACES FROM FULL NAME

update club_member_info$
set full_name = TRIM(full_name) ;

--SPLITTING NAMES INTO FIRST AND LAST NAME

select full_name, SUBSTRING(full_name,1,CHARINDEX(' ',full_name)) first_name,
substring(full_name,CHARINDEX(' ',full_name),LEN(full_name)) last_name
from club_member_info$ ;

--ADDING AND UPDATING FIRST NAME AND LAST NAME COLUMN

alter table club_member_info$
add First_name nvarchar(50);

update club_member_info$
set first_name =  Upper(SUBSTRING(first_name,1,1))+Lower(SUBSTRING(first_name,2,LEN(first_name)));

alter table club_member_info$
add Last_name nvarchar(50);


update club_member_info$
set Last_name = substring(full_name,CHARINDEX(' ',full_name),LEN(full_name));

--CHANNGING FIRST NAME AND LAST NAME INT0 PROPER FORM

select Replace(First_name,'?',' ')
from club_member_info$
where First_name like '?%'

select First_name, Upper(SUBSTRING(first_name,1,1))+Lower(SUBSTRING(first_name,2,LEN(first_name)))
from club_member_info$;

update club_member_info$
set first_name =  Upper(SUBSTRING(first_name,1,1))+Lower(SUBSTRING(first_name,2,LEN(first_name)));

select Last_name, Upper(SUBSTRING(Last_name,CHARINDEX(' ',last_name),1))+Lower(SUBSTRING(Last_name,2,LEN(Last_name)))
from club_member_info$;

update club_member_info$
set Last_name = TRIM(Upper(SUBSTRING(Last_name,CHARINDEX(' ',last_name),1))+Lower(SUBSTRING(Last_name,2,LEN(Last_name))));


-- ADDING PROPER FULL NAME COLUMN

alter table club_member_info$
add Clean_full_Name nvarchar(50);

update club_member_info$
set clean_full_name = First_Name + ' ' + Last_name;

--ADDING ADDRESS STREET, CITY AND STATE


alter table club_member_info$
add Address_Street nvarchar(50);

alter table club_member_info$
add Address_City nvarchar(50);

alter table club_member_info$
add Address_State nvarchar(50);


select PARSENAME(Replace(full_address,',','.'),3),
         PARSENAME(Replace(full_address,',','.'),2),
		 PARSENAME(Replace(full_address,',','.'),1)
from club_member_info$;

--UPDATING ADDRESS STREET,STATE AND CITY

update club_member_info$
set address_street = PARSENAME(Replace(full_address,',','.'),3);

update club_member_info$
set address_city = PARSENAME(Replace(full_address,',','.'),2);

update club_member_info$
set address_state = PARSENAME(Replace(full_address,',','.'),1);

select Clean_full_Name, REPLACE(Clean_full_Name,'?',' ')
from club_member_info$

--UPDATING MARITAL STATUS INTO PROPER FORM
Select Marital_Status,Upper(SUBSTRING(Marital_Status,1,1))+ Lower(SUBSTRING(Marital_Status,2,LEN(Marital_Status)))
from club_member_info$

update club_member_info$
set Marital_Status = Upper(SUBSTRING(Marital_Status,1,1))+ Lower(SUBSTRING(Marital_Status,2,LEN(Marital_Status)))

--RENAMING COLUMN NAMES

EXEC sp_rename 'club_member_info$.martial_status', 'Marital_Status'--, 'COLUMN';

EXEC sp_rename 'club_member_info$.age', 'Age'











