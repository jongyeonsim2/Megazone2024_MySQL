/* ================== 서브 쿼리 ====================== */

DESC customer;

/* 마지막으로 가입한 고객 정보
 * 
 * customer_id : smallint unsigned, auto_increment => 가장 큰 값 => 최근 가입 고객
 *  */

select customer_id, first_name , last_name 
  from customer c 
 where customer_id = ( select Max(customer_id) from customer c2 );
 

select /*+ INDEX_ASC(customer, customer_id ) */ customer_id
  from customer c 
limit 1;

select Max(customer_id) from customer;

select customer_id, first_name , last_name 
  from customer c 
 where customer_id = 599;
 
/* 
 * 'India' 국가 와 관계없는 모든 도시 조회.
 * 
 * city, country
 *  */ 

desc city; /* 국가별 도시 정보 */
desc country; /* 국가 정보 */

select city_id, city 
  from city c 
 where country_id <> (select country_id 
 						from country c2 
 						where c2.country = 'India');

/* in 연산자 subquery */
select city_id , city
  from city
  where country_id in (
  						select country_id 
  							from country c 
  							where country in ('Canada','Mexico')
  					);
  				
select city_id , city
  from city
  where country_id not in (
  						select country_id 
  							from country c 
  							where country in ('Canada','Mexico')
  					);
 					
/* DVD 대여시 실제 결제를 한 고객 정보 : 576 rows */
select first_name , last_name 
  from customer c 
 where customer_id not in (
 								select customer_id 
 								  from payment p 
 								 where amount = 0
 						);
 					
/* 무료 DVD를 대여한 고객 정보 : 23 rows */ 					
select first_name , last_name 
  from customer c 
 where customer_id in (
 								select customer_id 
 								  from payment p 
 								 where amount = 0
 						);
  				
  				
/* DVD 대여시 실제 결제를 한 고객 정보 : 576 rows 
 * 
 * all 연산자 : 서브쿼리에서 반환되는 여러개의 결과에서 모두 만족해야 함.
 * 
 * any 연산자 : 서브쿼리에서 반환되는 여러개의 결과중에서 한 가지만 만족해도 됨.
 * 
 * 
 * */	
select first_name , last_name 
  from customer c 
 where customer_id <> all (
 								select customer_id 
 								  from payment p 
 								 where amount = 0
 						);
  				
  				
/*
 * any 연산자
 * 
 * 볼리비아(Bolivia), 파라과이(Paraguay) 또는 칠레(Chile)의 모든 고객에 대한 
 * 총 영화 대여료를 초과하는 
 * 총 결제금액을 가진 모든 고객 정보를 조회
 * 
 * select customer_id, sum(amount)
 * 
 * payment, customer, address, city, country
 * 
 * */

select customer_id, sum(amount)
  from payment group by customer_id
 having sum(amount) > ALL (
			 select sum(p.amount)
			  from payment p 
			    inner join customer c 
			      on p.customer_id = c.customer_id 
			    inner join address a 
			      on c.address_id = a.address_id 
			    inner join city ct
			      on a.city_id = ct.city_id 
			    inner join country co
			      on ct.country_id = co.country_id 
			 where co.country in ('Bolivia','Paraguay','Chile')
			 group by co.country 
 					)	;		
 					
select customer_id, sum(amount)
  from payment group by customer_id
 having sum(amount) > 328.29;
 					

 	/* 'Bolivia' : 183.53, 'Paraguay' : 275.38, 'Chile' : 328.29  
 	 * 'Gambia' : 129.70, 'Greece' : 232.46
 	 * 
 	 * */
 					


select co.country, sum(p.amount)
			  from payment p 
			    inner join customer c 
			      on p.customer_id = c.customer_id 
			    inner join address a 
			      on c.address_id = a.address_id 
			    inner join city ct
			      on a.city_id = ct.city_id 
			    inner join country co
			      on ct.country_id = co.country_id 
			 where co.country in ('Gambia','Greece')
			 group by co.country ;




