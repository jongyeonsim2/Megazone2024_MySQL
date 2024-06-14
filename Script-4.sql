/* ================== 그룹화와 집계 ====================== */

/*
 * select 칼럼명
 *   from 테이블명
 *  group by 칼럼
 *  having 조건
 * 
 */


desc rental ;  /* 대여정보 데이터를 관리하는 테이블 */

select customer_id from rental r ;

/* 현재 고객수가 599 명, 대여정보도 599 건임 => 유휴 고객이 없는 상태. 
 * 하지만, 1번 만 빌리고, 2년동안 빌리지 않는 고객도 있을 수 있음.
 * 따라서, 유휴 고객에 대한 기준을 세워야 함.
 * */
select customer_id, count(*)
  from rental r 
 group by customer_id ;

/* 대여 횟수에 대한 내림차순 정렬 => 충성도가 높은 고객 순으로 조회 */
select customer_id, count(*)
  from rental r 
 group by customer_id 
 order by 2 desc;

/* 그룹핑 데이터에 그룹핑 조건 설정 => 초초충성고객 */
select customer_id, count(*)
  from rental r 
 group by customer_id 
 having count(*) >= 40;


desc payment ; /* DVD 대여 결제 내역 */

/* 집계함수 
 * 
 * 현재 사업의 ROI( Return Of Investment, 투자회수 ) 보임.
 * 전체 결제 내역에 대한 summary.
 * */
select max(amount) max_amt,
		min(amount) min_amt, /* 0 인경우가 있음. 무조건 횟수 확인. */
		avg(amount) avg_amt,
		sum(amount) tot_amt,
		count(*) num_paymnents /* 16,044 rows */
  from payment;

select count(*) from payment p 
  where amount = 0; /* 24 rows */

/*
 * 고객별 결제 내역에 대한 summary
 * 
 * 높은 결제 금액 => 최신 제품을 많이 빌림. => 대여 기간이 짮음 => 대여 회수가 높다면...?
 *             => AI 를 이 고객에게 추천 서비스가 되도록 해야 함.
 * */
  
select customer_id ,
		max(amount) max_amt,
		min(amount) min_amt, /*  */
		avg(amount) avg_amt,
		sum(amount) tot_amt,
		count(*) num_paymnents
  from payment p 
 group by customer_id ;
  
/* 대여 후 반환까지 걸린 최대 일수 */
select max(datediff(return_date, rental_date))
  from rental r ;
 
desc rental ;

/* 다중 그룹핑 */
/* 정규화 후에 생성된 테이블처럼 보여짐. 
 * 
 * select 에 사용될 칼럼을 선택하기 위해서 inner join 을 수행해야함.
 * */
desc film_actor; 

/* 영화 배우별 출연 횟수 */
select actor_id, count(*)
  from film_actor 
 group by actor_id;

/* 위의 sql 에 영화 등급 정보까지 조회 */
select fa.actor_id , f.rating , count(*)
  from film_actor fa 
    inner join film f 
      on fa.film_id = f.film_id 
   group by fa.actor_id , f.rating 
  order by 1,2;
   
/* 연도별 대여 수 
 * 
 * 예상 결과 :    2023   1000
 * 				2024    500
 * 
 * 문제점 : rental_date 의 유형 datetime => yyyy 가 되도록 해야함.	
 * */

desc rental ;

select extract(year from rental_date) year,
		count(*) rental_cnt
  from rental r 
 group by extract(year from rental_date);
 
/* 년도 추출 */
select  extract(year from rental_date)  from rental r ;
/* 월 추출 */
select  extract(month from rental_date)  from rental r ;
/* 년, 월 추출 */
select  extract(year_month from rental_date)  from rental r ;

select count(*) from rental r ;
  
/* 그룹필터 - 그룹핑 + 조건 검색 */
select fa.actor_id , f.rating , count(*)
  from film_actor fa 
    inner join film f 
      on fa.film_id = f.film_id 
   where f.rating in ('G','PG') /* 등급 조건 설정 */
   group by fa.actor_id , f.rating 
   having count(*) > 9
   order by 1,2;


