
/*=================  쿼리 입문 =================*/


select first_name, last_name
  from customer c 
 where last_name = 'MARTINEZ';


select first_name, last_name
  from customer c
 where c.last_name like "%Z%";

/* 영화 장르 */
select * from category c ;

/* 영화의 제작된 언어 */
select * from `language` l ;

select upper(name), name from `language` l ;

select user(), database();

select actor_id from film_actor fa order by actor_id ;

select actor_id from film_actor fa order by actor_id desc;

select * from customer c ;

/*
 * 테이블 유형( from 절에 올 수 있는 대상 )
 * 
 * 영구 테이블 : create table 문으로 생성된 것.
 * 파생 테이블 : 서브 쿼리에서 반환된 결과가 메모리에 보관된 것.
 * 			서브 쿼리 : select sql 안에 select sql 이 있는 형태.
 * 임시 테이블 : 메모리에 저장된 휘발성 데이터.
 * 가상 테이블 : create view 문으로 생성된 것.
 * 
 */

/* 고객의 이름을 합쳐서 출력 */
select concat(c.last_name, ', ', c.first_name)
  from customer c ;
 
/* 고객의 이름을 합쳐서 출력 - from 절에 select 절이 오도록 */
/* 파생 테이블 */
 select concat(cust.last_name, ',', cust.first_name) 
       , cust.email
 from
   	(
   		select c.first_name , c.last_name , c.email 
   		from customer c 
  		where c.first_name = 'JESSIE'
   	) cust; 


/* 중복 제거 출력 */
select distinct(actor_id) from film_actor fa ;


/* table 생성시, select 활용 - 테이블 생성과 동시에 데이터도 입력 */
/* 임시 테이블 */
create temporary table actors_j
(
	actor_id smallint(5),
	first_name varchar(45),
	last_name varchar(45)
);

select * from actors_j;

insert into actors_j
select actor_id, first_name, last_name
  from actor
 where last_name like 'J%';


/* 가상 테이블 */
/* 뷰 생성 */
create view cust_vw as
select customer_id, first_name, last_name, active
  from customer;
 
select * from cust_vw;

/* join - table 2개 이상 연결해서 조회 
 * 대상 테이블 : customer, rental
 * */

select * from customer c ;
select * from rental r ;

/* 등가 조인(equi join) : 교집합 */
/* 고객별 DVD 대여 현황 정보를 조회 */
select  c.first_name , c.last_name ,
	r.rental_date , r.return_date 
  from customer c /* 고객 테이블 */
  	inner join rental r /* DVD 대여 테이블 */
  	on c.customer_id = r.customer_id
  where c.first_name = 'MARY'
    and date(r.rental_date) = '2005-05-25';

/* where 절 - 조건 절 */
/* film table : 출시되어 대여할 수 있는 DVD(영화) 
 * 
 * rating : 등급
 * rental_duration : 최소 대여 기간 
 *    인기가 높으면, 대여기간이 짧음.
 * 
 * */
select * from film;

/* 등급이 G 이면서, 장기간 대여(7일 이상) 가능한 영화 */
select title
from film
where film.rating = 'G'
  and rental_duration >= 7;
 
/* 등급이 G 이면서, 장기간 대여(7일 이상) 가능한 영화  또는
 * 등급이 PG-13 이면서, 단기 대여(4일 미만, 3일 이하) 가능한 영화 
 * */
select title
from film
where ( film.rating = 'G' and rental_duration >= 7 ) or 
		( film.rating = 'PG-13' and rental_duration < 4 );
 

select count(*)
from film
where ( film.rating = 'G' and rental_duration >= 7 ) or 
		( film.rating = 'PG-13' and rental_duration < 4 );
	
/*
 * 고객별(그룹핑) 대여 횟수()를 계산한 다음 대여 횟수가 40회 이상인 고객 리스트를 작성.
 * 횟수 : count(*)
 * */
select c.first_name , c.last_name, count(*)
  from customer c 
   inner join rental r 
   on c.customer_id  = r.customer_id 
   group by c.first_name , c.last_name /* 고객별 */
   having count(*) >= 40;
	
	
/*
 * 고객별(그룹핑) 대여 횟수()를 계산한 다음 대여 횟수가 40회 이상인 고객 리스트를 작성.
 * 정렬 추가(오름차순) 고객명(  last_name, first_name  )
 * */
 select c.first_name , c.last_name, count(*)
  from customer c 
   inner join rental r 
   on c.customer_id  = r.customer_id 
   group by c.first_name , c.last_name /* 고객별 */
   having count(*) >= 40
   order by c.first_name , c.last_name;

/*
 * 고객명, 대여일 로 조회가 되도록 하고,
 * 정렬 추가 : 최근에 대여한 고객순으로 조회가 되도록 SQL 작성.
 * */	
 select c.first_name , c.last_name, r.rental_date 
  from customer c 
   inner join rental r 
   on c.customer_id  = r.customer_id
   order by r.rental_date desc;
  
 select c.first_name , c.last_name, r.rental_date 
  from customer c 
   inner join rental r 
   on c.customer_id  = r.customer_id
   order by 3 desc;
  
  
  