/* ================== 서브 쿼리 ====================== */

/*
 * 데이터베이스의 내부 구조
 * 
 * 1. 데이터 캐시( 정리필요. )
 *    1.1 위치
 *       데이터베이스의 공유 메모리 내에 존재
 *    1.2 용도
 *       DB서버프로세스가 SQL클라이언트의 select 요청에 대한 데이터가 메모리에
 *       없는 경우 속도가 느린 디스크에서 읽어올 수 밖에 없으므로 그만큼
 *       SQL의 처리가 느려지게 됨. ( DISK I/O 가 발생함으로 속도가 느려지게 됨. )
 * 
 *       따라서, 한 번 조회된 데이터는 데이터 캐시에 저장해두고 재활용하려고 함.
 *       내부 알고리즘에 의해서, 캐시가 갱신됨.
 *    1.3 검색 결과 반환 단계( 이해를 돕기 위해 간단하게 설명. )
 *       - SQL 클라이언트가 select 문을 DB 서버로 문자열 전송.
 *       - DB 서버 프로세스가 메모리(데이터 캐시, 버퍼 캐시)에 데이터가 있는지 확인.
 *       - 캐시된 데이터가 없으면, 디스크에서 직접 읽어와서, 메모리에 캐싱함.
 *       - 결과 반환.
 * 
 * 2. 딕셔너리 캐시, 라이브러리 캐시 ( 참고, SQL 성능이라는 부분이 이런 거구나... )
 *    2.1 위치
 *       데이터베이스의 공유 메모리 내에 존재
 *    2.2 용도
 *       딕셔너리 캐시는 주로 SQL 의 실행에 필요한 메타 정보를 보관함.
 *       라이브러리 캐시는 실행 계획 등의 SQL 정보가 저장됨.
 * 
 *       SQL 문에는 구체적인 처리방법이 적혀 있지 않기 때문에 데이터베이스가
 *       처리 방법(실행 계획)을 스스로 생성해야할 필요가 있음. 따라서,
 *       실행 계획의 좋고 나쁨에 따라 성능이 크게 변할 수 있음.
 *       ( Oracle 기준 : rule based, cost based
 *         10 버전 부터는 cost based 만 있음. 어떤 경로를 타면 저비용으로 탐색이 되나?
 *       )
 * 
 *       단순한 예로 1,000 만건의 데이터가 있는 table A 와 100 만건의 데이터가 있는
 *       table B 가 있고, table A 에 value 칼럼에 값은 99% 가 1 로 저장되어 있는
 *       상태.
 *  
 *       select * from A
 *        inner join B
 *           on A.id = B.id
 *        where A.value = 1 and B.value = 1;
 * 
 *       - table A -> table B( cost 가 높다. )
 *         최악의 경우 1000 만 번의 디스크 I/O 가 발생할 수 있음.
 * 
 *       - table B -> table A( cost 가 낮다. )
 *         B.value = 1 인 데이터에 대한 I/O 만 발생할 수 있음.
 *    2.3 실행계획의 수립에 필요한 정보
 *       옵티마이저가 실행 계획을 세우기 위해서 3가지의 정보를 활용해서,
 *       비용을 계산하여 최적의 실행 계획을 세우게 됨.
 * 
 *       - SQL 문의 정보
 *         어떤 테이블의 어떤 데이터인지, 어떤 검색조건인지, 테이블 간의 관계는....
 *       - 초기화 파라미터
 *         세션에서 사용할 수 있는 메모리의 크기, 단일 I/O로 읽어올 수 있는 블록 수....
 *         ( cost 비용 산출시 필요한 정보. )
 *       - 옵티마이저 통계( 시계열 정보 )
 *         테이블 통계, 컬럼 통계( 데이터 값, 데이터 분포도 등 )
 *         인덱스 통계( 인덱스 깊이 등 ), 시스템 통계( I/O, CPU, 메모리 등 )
 * 
 * 
 * 
 */




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


/* 다중 열 서브쿼리 : 반환되는 결과가 다중 열인 서브쿼리 */
			
select actor_id, film_id
  from film_actor
 where ( actor_id, film_id ) in (
 									/* 카테시안 프러덕트 : cross join */
 									select a.actor_id, f.film_id
 									  from actor a 
 									    cross join film f 
 									 where a.last_name = 'MONROE'
 									   and f.rating = 'PG'
 								);

 							
/* 상관 서브쿼리 
 * 
 * 메인 쿼리에서 사용한 데이터를 sub query 에서 사용하고 
 * sub query 의 결과값을 다시 메인 쿼리로 반환하는 방식 => 성능이 낮음.
 * => 비상관 서브쿼리에는 서브쿼리가 독립적으로 실행이 됨. 
 * 
 * */
 		
/* 아래의 상관관계 sql 의 동작 순서 
 * 
 * 1. Main sql 에서 customer_id 를 모두 구함. 599 명의 고객의 ID를 조회.
 * 2. customer_id 를 sub query에 제공. 
 *    sub query 가 한 번씩 실행이되도록 customer_id 를 제공.
 * 3. sub query 에서 제공받은 customer_id 로 실행.
 * 4. sub query 의 결과를 Main query 로 반환
 * 5. Main query 20 번 대여 횟수가 동일한지 확인.
 * 
 * 따라서, 상관 sub query는 599(고객수) 번 실행되고, 
 * query 를 실행할 때마다 지정된 고객의 총 대여횟수가 반환됨.
 * 
 * */ 							
select c.customer_id , c.first_name , c.last_name 
  from customer c 
 where 20 = (
 				select count(*) 
 				  from rental r 
 				 where r.customer_id = c.customer_id 
 			);
 		
select count(*) from rental r where r.customer_id = 191;
 		
/* 상관관계 Query 를 사용해서  SQL 을 작성.
 * 
 * 대여 총 지불액이 180 달러에서 240 달러 사이인 모든 고객 리스트
 *  */ 							

select c.first_name, c.last_name 
  from customer c 
 where 
   (
   		select sum(p.amount)
   		  from payment p 
   		 where p.customer_id = c.customer_id 
   )/* 상관관계 sub query 가 599 번 실행, 599 번 반환 */
   between 180 and 240;

/* exists 연산자 
 * 
 * exists 연산자 다음에 sub query 가 위치하고,
 * 그 sub query 의 결과가 row 수에 관계없이 
 * 결과 존재 자체만 확인하고자 하는 경우에 사용.
 * 
 * */

/* 2005-05-25 일 이전에 한 편 이상의 영화를 대여한 모든 고객  */
select c.customer_id , c.first_name , c.last_name 
  from customer c 
 where exists 
    (
    	select 1 /* SQL 처리 속도 향상을 위함. */
    	  from rental r 
    	 where r.customer_id = c.customer_id 
    	   and date(r.rental_date) < '2005-05-25'
    );
    
  
select r.rental_id 
  from rental r 
 where r.customer_id = 130
   and date(r.rental_date) < '2005-05-25';
  
  
/*
 * 상관관계 SUB QUERY 사용.
 * R 등급 영화에 출연한 적이 한 번도 없는 모든 배우명을 검색.
 * 
 * - 영화 배우 한 명만을 생각해보는 것으로 논리적으로 생각해봄.
 *   A 영화배우, 10편에 출연. => 10편 영화가 R 등급 영화에 출연 여부.
 * 
 *   Main                    Sub
 *   
 *   영화배우 테이블에 영화배우가 100명이라면, 위의 처리 방법을 100 번 수행.
 * 
 *   => 상관관계 쿼리
 *      Main query에서 조회된 데이터를 Sub Query에서 조건 사용하고,
 *     Sub Query 결과를 Main query 로 반환.
 * 
 * 
 * 지금 예제는 상관관계를 사용하면 좋은 경우.
 * 
 * */  
select a.first_name, a.last_name
  from actor a /* 배우 데이터를 Sub Query의 검색조건으로 사용. */
 where not exists /* Sub Query 로 R 등급으로 조회 */
 (
 	select 1
 	  from film_actor fa 
 	 inner join film f on f.film_id = fa.film_id
 	 where fa.actor_id = a.actor_id /* Main query 의 데이터 */
 	   and f.rating = 'R'
 );
  
        

        
  
/*
 * SUB QUERY 사용.
 * 고객별 고객정보(first_name, last_name), 대여횟수, 대여결체총액 을 조회.
 * 
 * 고객별 고객정보(first_name, last_name) : 고객 정보. => 고객 정보 전용 SQL
 * 대여횟수, 대여결체총액 : 대여 정보. => 대여 정보 전용 SQL
 * 
 * 향후에 함수 또는 프로시저 (function, procedure 등)  가 될 후보군이 보이게 됨. 
 * 
 * inner join 문에 사용되는 SUB QUERY
 * 대여횟수, 대여결체총액 는 집계 함수
 * 
 */
select c.first_name , c.last_name , 
		payInfo.rentals_cnt, payInfo.payments_tot
  from customer c  /*  고객정보 전용  */
    inner join
      (
      	 select customer_id , count(*) rentals_cnt,
      	 		sum(amount) payments_tot
      	   from payment p 
      	  group by customer_id 
      ) payInfo /* 대여 정보 전용 SQL */
     on c.customer_id = payInfo.customer_id;





  
/* 난이도가 있음.
 * 대여 결제 총액 기준으로 크게 3개 그룹의 고객을 분류
 * 낮은 결제 고객 : 0 ~ 74.99
 * 중간 결제 고객 : 75 ~ 149.99
 * 높은 결제 고객 : 150 ~ 9,999,999.99
 * 
 * 고객 정보 테이블
 * 
 * 결제 기준 분류 테이블
 * 낮은 결제 고객 : 0(low_limit) ~ 74.99(high_limit)
 * 중간 결제 고객 : 75(low_limit) ~ 149.99(high_limit)
 * 높은 결제 고객 : 150(low_limit) ~ 9,999,999.99(high_limit)
 * 
 * 
 * => 분류 테이블 처럼 생각해야 함. 하지만, 실제 테이블이 아님.
 *    => 마치 테이블 처럼 되도록만 하면, 관계만 맺어주게 되면 해결.
 *       => 마스트 코드 및 분류 테이블이 될 후보군이 보이게 됨.
 * 
 * 상기의 기준으로 해당 그룹에 속하는 고객수를 조회.
 */
  
/* 1. 논리적인 테이블이 되도록 해야 함. */

select 1, 'ABC'    
union all    
select 2, 'DEF'
union all
select 3, 'GHI';

select 'small', 0 low_limit, 74.99 high_limit
union all
select 'average', 75 low_limit, 149.99 high_limit
union all
select 'heavy', 150 low_limit, 9999999.99 high_limit;

/* 2.
 * 
 * 논리적인 테이블과의 관계를 설정
 * 논리적인 테이블이 inner join 에 들어가고,
 * 관계를 맺어주면 됨.
 *  */
select payGroupInfo.name, count(*) num_cus
  from 
      (
      	 select customer_id , count(*) rentals_cnt,
      	 		sum(amount) payments_tot
      	   from payment p 
      	  group by customer_id 
      ) payInfo  /* 고객 정보 + 결제 정보 */
    inner join 
		(
			select 'small' name, 0 low_limit, 74.99 high_limit
			union all
			select 'average' name, 75 low_limit, 149.99 high_limit
			union all
			select 'heavy' name, 150 low_limit, 9999999.99 high_limit
		) payGroupInfo /* 결제 분류 논리 테이블 */   
    on payInfo.payments_tot between  low_limit  and high_limit
    group by payGroupInfo.name;


/* SQL을 작성하되, 가독성 높은 SQL 로 작성할 것.
 * 
 * 고객정보(first, last name, 도시명), 총 대여 지불 금액, 총 대여 횟수
 * 를 조회하는 SQL을 작성.
 *  */

/* 공통화 작업을 하진 않은 SQL
 * 
 * : 조회를 table 을 기준으로만 직접 조인해서 사용
 * 
 * 
 * 테이블 간의 조인의 목적성이 잘 보이지 않음.
 * 따라서, 코드를 좀 읽어서, 분석이 필요.
 * 
 * 통계적인 정보의 조회를 위해서 테이블간의 조인 부분을 공통화하면 어떨까?
 *  */   
select c.first_name , c.last_name , ct.city ,
		sum(p.amount) pay_tot , count(*) rental_tot_cnt
  from payment p 
 inner join customer c 
    on p.customer_id = c.customer_id 
 inner join address a 
    on c.address_id = a.address_id 
 inner join city ct
    on a.city_id = ct.city_id 
 group by c.first_name , c.last_name , ct.city ;
   

/* 통계 정보 기능만 별도의 SQL 로 작성 : 공통화 작업 */
select customer_id , 
		sum(p.amount) pay_tot , count(*) rental_tot_cnt
  from payment p 
 group by customer_id ;


   
/*
 * 공통화 작업을 한 SQL
 * : Sub Query 를 작성해서 다시 조인해서 사용.
 * 
 */   
select c.first_name , c.last_name , ct.city ,
		payInfo.pay_tot , payInfo.rental_tot_cnt
  from (
		select customer_id , 
				sum(p.amount) pay_tot , count(*) rental_tot_cnt
		  from payment p 
		 group by customer_id /* view 의 후보군 */
  ) payInfo
 inner join customer c 
    on payInfo.customer_id = c.customer_id 
 inner join address a 
    on c.address_id = a.address_id 
 inner join city ct
    on a.city_id = ct.city_id ;
  
  
/* 공통 테이블 표현식 : CTE, with 절 
 * CTE : Common Table Expression
 * 
 * 서브쿼리가 몇 십줄씩 되는 경우( 서브쿼리의 규모가 큰 경우 )
 * 실제 수행해야 할 Main Query 와 Sub Query를 구분할때 유용함.
 * */
   
   
   
/* CTE 를 사용하면 좋은 경우.
 * 
 * 성이 'S'로 시작하는 배우가 출연하는 PG 등급 영화 대여로 발생한
 * 총 수익(대여료)을 조회 
 * 
 * 영화 배우명(first_name, last_name), 총 수익 으로 조회.
 * */
   

WITH actors_s AS
      (SELECT actor_id, first_name, last_name
       FROM actor
       WHERE last_name LIKE 'S%'
      ),
      actors_s_pg AS
      (SELECT s.actor_id, s.first_name, s.last_name,
         f.film_id, f.title
       FROM actors_s s
         INNER JOIN film_actor fa
         ON s.actor_id = fa.actor_id
         INNER JOIN film f
         ON f.film_id = fa.film_id
       WHERE f.rating = 'PG'
      ),
      actors_s_pg_income AS
      (SELECT spg.first_name, spg.last_name, p.amount
       FROM actors_s_pg spg
         INNER JOIN inventory i
         ON i.film_id = spg.film_id
         INNER JOIN rental r
         ON i.inventory_id = r.inventory_id
         INNER JOIN payment p
         ON r.rental_id = p.rental_id
      ) -- end of With clause
     SELECT spg_income.first_name, spg_income.last_name,
       sum(spg_income.amount) tot_revenue
     FROM actors_s_pg_income spg_income
     GROUP BY spg_income.first_name, spg_income.last_name
     ORDER BY 3 desc;
   
   
   
   
   
   
/* 영화 배우를 조회. 영화 배우 ID, 영화 배우명(first_name, last_name) 
 * 
 * 단, 정렬 조건은 영화 배우가 출연한 영화수로 내림차순 정렬이 되도록 하고,
 * 정렬 조건을 Sub Query로 작성할 것.
 * */
   
   
   
/* 대여 가능한 DVD 영화 리스트를 조회.
 * film id, 제목, 재고수 가 조회도록 SQL 작성. 
 * 
 * 단, 모든 영화가 빠짐없이 조회가 되도록 해야 함.
 * */
  
   
   
/* 대여 가능한 DVD 영화 리스트를 조회.
 * film id, 제목, 재고번호, 대여일 이 조회도록 SQL 작성. 
 * 
 * 단, 모든 영화가 빠짐없이 조회가 되도록 해야 하고,
 *   film id 는 13, 14, 15 로 한정. 
 * */
  
 							
