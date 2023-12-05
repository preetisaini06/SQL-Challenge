
-------------------------------------------- Question Answer --------------------------------------------------------------
/*
1. How many pubs are located in each country??
2. What is the total sales amount for each pub, including the beverage price and quantity sold?
3. Which pub has the highest average rating?
4. What are the top 5 beverages by sales quantity across all pubs?
5. How many sales transactions occurred on each date?
6. Find the name of someone that had cocktails and which pub they had it in.
7. What is the average price per unit for each category of beverages, excluding the category 'Spirit'?
8. Which pubs have a rating higher than the average rating of all pubs?
9. What is the running total of sales amount for each pub, ordered by the transaction date?
10. For each country, what is the average price per unit of beverages in each category, and what is the overall average price per unit of beverages across all categories?
11. For each pub, what is the percentage contribution of each category of beverages to the total sales amount, and what is the pub's overall sales amount?
*/

/* 1. How many pubs are located in each country? */

select country, count(*) as count_of_pub from pubs
group by 1


/* 2. What is the total sales amount for each pub, including the beverage price and quantity sold? 

Method 1 : */
select pub_name, sum(s.quantity * b.price_per_unit) as total_sale from pubs as pb
join sales as s using(pub_id)
join beverages as b using(beverage_id)
group by 1
order by 2 desc
                                       OR

/* Methos 2 : */
select pub_name, sum(s.quantity * b.price_per_unit) as total_sale from pubs as pb
join sales as s on pb.pub_id = s.pub_id
join beverages as b on s.beverage_id = b.beverage_id
group by 1
order by 2 desc

/* 3. Which pub has the highest average rating? */

select pb.pub_name, round(avg(cast(r.rating as numeric)),1) as avg_rating from pubs as pb
join ratings as r on pb.pub_id = r.pub_id
group by pb.pub_name
order by 2 desc
limit 1


/* 4. What are the top 5 beverages by sales quantity across all pubs? */

select b.beverage_name,count(s.quantity) as sale_quantity from beverages as b
join sales as s on b.beverage_id = s.beverage_id
group by 1
order by 2 desc
limit 5

/* 5. How many sales transactions occurred on each date? */

select transaction_date,count(*)as sales_count from sales
group by 1
order by 1

/* 6. Find the name of someone that had cocktails and which pub they had it in? */

select r.customer_name,pb.pub_name,b.category from beverages as b
join sales as s on b.beverage_id = s.beverage_id
join pubs as pb on s.pub_id = pb.pub_id
join ratings as r on pb.pub_id = r.pub_id
where category = 'Cocktail'
group by 1,2,3

/* 7. What is the average price per unit for each category of beverages, excluding the category 'Spirit'? */

select category, round(avg(price_per_unit),1) as avg_price
from beverages 
where category != 'Spirit'
group by 1



/* 8. Which pubs have a rating higher than the average rating of all pubs? */

select pub_name,round(avg(cast(r.rating as numeric)),1)as avg_rating from pubs as pb
join ratings as r on pb.pub_id = r.pub_id
group by 1
having avg(r.rating) > (select round(avg(cast(rating as numeric)),1) from ratings)


/* 9. What is the running total of sales amount for each pub, ordered by the transaction date? */


with total_sale as(
	select *,(s.quantity*b.price_per_unit) as sale from sales as s
	join beverages as b on s.beverage_id=b.beverage_id
)

select p.pub_name,ts.transaction_date,sum(ts.sale)as total_amount  from total_sale as ts
join pubs as p on ts.pub_id = p.pub_id
group by 1,2
order by 2 




/* 10. For each country, what is the average price per unit of beverages in each category, and what is the overall average price per unit of beverages across all categories? */



with avg_price_unit as(
	select p.country,b.category,round(avg(b.price_per_unit),2)as avg_amount from pubs as p
	join sales as s on p.pub_id = s.pub_id
	join beverages as b on s.beverage_id=b.beverage_id
	group by 1,2
),
overall_avg_price as (
	select p.country,round(avg(b.price_per_unit),2) as overall_amount from pubs as p
	join sales as s on p.pub_id = s.pub_id
	join beverages as b on s.beverage_id=b.beverage_id
	group by 1	
)
select avp.country,avp.category,avp.avg_amount,ovp.overall_amount from avg_price_unit as avp
join overall_avg_price as ovp on avp.country=ovp.country
order by 2



/* 11. For each pub, what is the percentage contribution of each category of beverages to the total sales amount, and what is the pub's overall sales amount?
*/

with individual_sales as (
	select p.pub_name,b.category,sum(b.price_per_unit*s.quantity) as sales_by_category from pubs as p
	join sales as s on p.pub_id = s.pub_id
	join beverages as b on s.beverage_id=b.beverage_id
	group by 1,2
),
total_sales as(
	select p.pub_name,sum(b.price_per_unit*s.quantity) as sales_by_pubname from pubs as p
	join sales as s on p.pub_id=s.pub_id
	join beverages as b on s.beverage_id=b.beverage_id
	group by 1
)

select i.pub_name,i.category,round((i.sales_by_category/ts.sales_by_pubname)*100,2) as percentage_contribution,ts.sales_by_pubname as overall_Sale_amount from individual_sales as i
join total_sales as ts on i.pub_name=ts.pub_name
order by 1

































































































































