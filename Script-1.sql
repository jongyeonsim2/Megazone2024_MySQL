
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

/* 고객의 이름을 합쳐서 출력 */
select concat(c.last_name, ', ', c.first_name)
  from customer c ;
 
/* 고객의 이름을 합쳐서 출력 - from 절에 select 절이 오도록 */

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


select  c.first_name , c.last_name ,
	r.rental_date , r.return_date 
  from customer c 
  	inner join rental r 
  	on c.customer_id = r.customer_id
  where c.first_name = 'MARY'
    and date(r.rental_date) = '2005-05-25'; 







 

