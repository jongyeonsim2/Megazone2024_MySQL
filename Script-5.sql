/* ================== 서브 쿼리 ====================== */

/*
 * 데이터베이스의 내부 구조
 * 
 * 1. 데이터 캐시( 정리필요. )
 *    1.1 위치
 *       데이터베이스의 공유 메모리 내에 존재
 *    1.2 용도
 *       DB서버프로세서가 SQL클라이언트의 select 요청에 대한 데이터가 메모리에
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
 *       데이터베이스의 고유 메모리 내에 존재
 *    2.2 용도
 *       딕셔너리 캐시는 주로 SQL 의 실행에 필요한 메타 정보를 보관함.
 *       라이브러리 캐시는 실행 계획 등의 SQL 정보가 저장됨.
 * 
 *       SQL 문에는 구체적인 처리방법이 적혀 있지 않기 때문에 데이터베이스가
 *       처리 방법(실행 계획)을 스스로 생성해야할 필요가 없음. 따라서,
 *       실행 계획의 좋고 나쁨에 따라 성능이 크게 변할 수 있음.
 *       ( Oracle 기준 : rule based, cost based
 *         10 버전 부터는 cost based 만 있음. 어떤 경로를 타면 저비용으로 탐색이 되나?
 *       )
 * 
 *       단순한 예로 1,000 만건의 데이터가 있는 table A 와 100 만건의 데이터가 있는
 *       table B 가 있고, table A 에 value 칼럼에 값은 99% 가 1 로 저장되어 있는
 *       상태.
 *  
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
  
  
  
  
  
  
  
  
  
 							
