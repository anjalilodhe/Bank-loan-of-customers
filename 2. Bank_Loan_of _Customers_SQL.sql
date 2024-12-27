use sql_project;

select * from finance_1 limit10;
select * from finance_2 limit10;


select * from finance_1 left join finance_2 on finance_1.id = finance_2.id ;


-- KPI 1 Year wise loan amount Stats ----------------------------------------------------------------------
 
 
 
create view  KPI1 as 
	select issue_d,loan_amnt 
		from finance_1 left join finance_2 on finance_1.id = finance_2.id ;

select year(issue_d) as Year_, sum(loan_amnt) as loan_amount 
	from kpi1 
		group by Year_ order by Year_;
        
        

-- KPI 2 Grade and sub grade wise revol_bal-----------------------------------------------------------------



create view KPI2 as 
	select grade, sub_grade, revol_bal 
		from finance_1 left join finance_2 on finance_1.id = finance_2.id ;

select grade, sub_grade, sum(revol_bal) revol_balance 
	from kpi2 
		group by grade,sub_grade 
			order by grade,sub_grade;
            
            
--  stored procedure grade wise

call grade_wise_revolbal("A");

--  stored grade & sub grade wise

call gradesubgrade_wise_revolbal("A","A1");



-- KPI 3 Total Payment for Verified Status Vs Total Payment for Non Verified Status -------------------------------------



create view KPI3 as 
select verification_status, total_pymnt
	from finance_1 left join finance_2 on finance_1.id = finance_2.id ;

select verification_status, truncate(sum(total_pymnt),0) as total_payment 
	from kpi3 
		group by verification_status 
			having verification_status <> 'Source Verified' ;
            
            
            




-- KPI 4    State wise and month wise loan status ----------------------------------------------------------------------------------------------------------------



create view KPI4 as 
	select issue_d,addr_state,loan_status,loan_amnt 
		from finance_1 left join finance_2 on finance_1.id = finance_2.id ;


select addr_state as state, month(issue_d) as months,loan_status,sum(loan_amnt) as loan_amt
	from KPI4 
		group by state, months,loan_status 
			order by state,months,loan_status;
            
            
call state_month_wise_loanstatus ("AK");



-- KPI 5 Home ownership Vs last payment date stats -----------------------------------------------



create view KPI5 as select last_pymnt_d , home_ownership , last_pymnt_amnt 
from finance_1 left join finance_2 on finance_1.id = finance_2.id ;

select year(last_pymnt_d) as Year_,home_ownership,sum(last_pymnt_amnt)  as Amount
	from kpi5
		group by Year_,home_ownership 
			having  Year_ is not null  
				order by Year_ ;
            
call year_wise_homeownership(2010);



----------------------###  KPI - 06 Grade wise Rate_of_Interest :-


SELECT grade, ROUND(AVG(int_rate) * 100, 2) AS Rate_of_Interest
		FROM finance_1
			GROUP BY grade
				ORDER BY grade;



----------------------###  KPI - 07  Top 10 Purpose with Loan_Amount :-


SELECT purpose, SUM(loan_amnt) as Loan_amt
	FROM finance_1
		GROUP BY purpose
			ORDER BY Loan_amt DESC
				LIMIT 10;


