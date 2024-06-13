

/* ================== 필터링(조건절 활용) ================== */

/* 동등 조건 */
SELECT rental_date
  FROM rental
 where date(rental_date) = '2005-06-14';
/* rental_date 는 시간 정보까지 포함되어 날짜 형식으로 변환 */

/* 비동등 조건 */
SELECT rental_date
  FROM rental
 where date(rental_date) <> '2005-06-14';

/* 범위 조건 */
SELECT rental_date
  FROM rental
 where date(rental_date) < '2005-05-28';

SELECT rental_date
  FROM rental
 where rental_date <= '2005-06-16'
   and rental_date >= '2005-06-14';
  
SELECT rental_date
  FROM rental
 where rental_date between '2005-06-14' and  '2005-06-16';

/* payment : DVD 대여 정보 중에서 결제완 관련된 정보 */
select * from payment p ;

select customer_id, payment_date, amount 
  from payment
 where amount between 10.0 and 11.99;


/* in */
select title, rating 
  from film
 where rating = 'G' or rating = 'PG'; 


select title, rating 
  from film
 where rating in ('G', 'PG');


select rating 
  from film 
 where title like '%PET%';

select title, rating 
  from film
 where rating in (select rating 
  					from film 
 					where title like '%PET%');

/* not in */
select title, rating 
  from film
 where rating not in ('G', 'PG');
 				
/* 문자열 함수를 활용한 등가 조인 */
select last_name, left(last_name, 1)
  from customer
 where left(last_name, 1) = 'Q';

/* like 연산자 */
select last_name, first_name 
  from customer
 where last_name like '_A%S'; /* _ : 문자 한자리 */

/* 정규 표현식 : 고객의 last_name 가 Q 또는 Y 로 시작하는 고객 리스트 */
select last_name, first_name 
  from customer
 where last_name regexp '^[QY]';
 
 
/* null 조건 검색 : 반납되지 않은 대여 정보 조회 */
select *
  from rental
 where return_date is null; /* 정상적인 방법 */

select *
  from rental
 where return_date = null; /* 잘못된 방법 */
 
select *
  from rental
 where return_date is not null; /* 정상적인 방법 */



/* ================== 다중 테이블 활용 ================== 
 * 
 * 카테시안 product(데카르트 곱)
 * 
 * 2개 이상의 테이블을 사용해서 데이터를 조회시,
 * 두 테이블의 관계를 설정하지 않고 조회를 하면,
 * 서로 연결할 수 있는 조건으로 연결된 모든 데이터가 조회됨.
 * 
 * 일반적으로는 전혀 의미가 없지만,
 * 특별한 경우( 테스트 데이터, dummy 데이터 용 )는 사용 할 수 있음.
 * 
 * 따라서, 반드시 두 테이블간의 관계 설정을 해야 함.
 * 
 * 
 * 
 * */

/* self join 실습 용 table 및 데이터 
 * 
CREATE TABLE EMP
       (EMPNO int NOT NULL,
        ENAME VARCHAR(10),
        JOB VARCHAR(9),
        MGR int,
        HIREDATE DATE,
        SAL int,
        COMM int,
        DEPTNO int);

INSERT INTO EMP VALUES
        (7369, 'SMITH',  'CLERK',     7902,
        date('1980-12-17'),  800, NULL, 20);
INSERT INTO EMP VALUES
        (7499, 'ALLEN',  'SALESMAN',  7698,
        '1981-02-20', 1600,  300, 30);
INSERT INTO EMP VALUES
        (7934, 'MILLER', 'CLERK',     7782,
        '1982-01-23', 1300, NULL, 10);
INSERT INTO EMP VALUES
        (7521, 'WARD',   'SALESMAN',  7698,
        '1981-02-22', 1250,  500, 30);
INSERT INTO EMP VALUES
        (7566, 'JONES',  'MANAGER',   7839,
        '1981-04-02',  2975, NULL, 20);
INSERT INTO EMP VALUES
        (7654, 'MARTIN', 'SALESMAN',  7698,
        '1981-09-28', 1250, 1400, 30);
INSERT INTO EMP VALUES
        (7698, 'BLAKE',  'MANAGER',   7839,
        '1981-05-01',  2850, NULL, 30);
INSERT INTO EMP VALUES
        (7782, 'CLARK',  'MANAGER',   7839,
        '1981-06-09',  2450, NULL, 10);
INSERT INTO EMP VALUES
        (7788, 'SCOTT',  'ANALYST',   7566,
        '1982-12-09', 3000, NULL, 20);
INSERT INTO EMP VALUES
        (7839, 'KING',   'PRESIDENT', NULL,
        '1981-11-17', 5000, NULL, 10);
INSERT INTO EMP VALUES
        (7844, 'TURNER', 'SALESMAN',  7698,
        '1981-09-08',  1500, NULL, 30);
INSERT INTO EMP VALUES
        (7876, 'ADAMS',  'CLERK',     7788,
        '1983-01-12', 1100, NULL, 20);
INSERT INTO EMP VALUES
        (7900, 'JAMES',  'CLERK',     7698,
        '1981-12-03',   950, NULL, 30);
INSERT INTO EMP VALUES
        (7902, 'FORD',   'ANALYST',   7566,
        '1981-12-03',  3000, NULL, 20);
        
        
select count(*) from emp;  => 총 row 수 : 14 건 을 확인
        
 * 
 * */
 
 
 
/* 데카르트 곱 */ 
select count(*) from customer; /* 599 */
select count(*) from address; /* 603 */

select count(*) 
  from customer c join address a; /* 361,197 */

/* 한 번 해보세요. 
 * 599, 603, 361197 결과가 한 번의 SQL 실행으로 모두 조회가 되도록
 * */
select customer_cnt.cnt, address_cnt.cnt, cartesian_cnt.cnt
  from 
  	(select count(*) cnt from customer) customer_cnt,
  	(select count(*) cnt from address) address_cnt,
  	(select count(*) cnt
       from customer c join address a) cartesian_cnt;

/* 데카르트 곱을 회피 => 관계 설정을 하면 됨. => address_id 로 관계 설정 */
select c.first_name , c.last_name , a.address 
  from customer c join address a 
    on c.address_id = a.address_id ;
      
/* 실행하면 599 건이 확인됨.
 * 
 * 599 건은 현재 고객수는 599임.
 * 고객이 599 명인데, 아래의 문장을 실행해서,
 * 598 건 이 나온다면, 주소 마스터 테이블의 주소 정보에 문제가
 * 있다고 생각하고, 확인을 해야 함.
 * 
 *  */
select count(*)
  from customer c join address a 
    on c.address_id = a.address_id ;


/* ANSI(표준) join 문법 - SQL92 버전 */
select c.first_name , c.last_name , a.address 
  from customer c join address a 
    on c.address_id = a.address_id 
 where a.postal_code = 52137;

/* 비 ANSI(비표준) 
 * 
 * 비표준 SQL 에는 벤더 지향 SQL이 있음. => 고급 기능임.
 * */
select c.first_name , c.last_name , a.address 
  from customer c, address a
 where c.address_id = a.address_id; 

select c.first_name , c.last_name , a.address 
  from customer c, address a
 where c.address_id = a.address_id
   and a.postal_code = 52137; 
  
/*
 * 표준SQL 의 장점
 * - 조인 조건과 추가적인 필터 조건의 구분이 되어, 가독성이 높음.
 * - 조인 조건에 대한 누락될 가능성이 낮음.
 * - 표준 SQL 다른 벤더의 데이터베이스로의 이식성이 높음.
 * 
 * */


select count(*)
  from customer c, address a
 where c.address_id = a.address_id; 


/* 
 * 세 테이블 조인.
 * 
 * 고객명, 도시명 조회.
 * customer, city, address
 * 
 * 1. 표준 SQL 사용해서 3테이블 관계 맺도록 해서 SQL 작성.
 * 2. 서브쿼리를 활용.
 *    큰 틀에서는 마치 테이블 2개로 관계를 맺는것처럼 SQL 을 작성.
 * 3. 그래서, 둘 중 어느 sql 이 가독성이 좋은지 비교.
 * 4. 2번에서 서브쿼리로 사용한 SQL을 view 로 생성.
 *    서브쿼리 대신에 view 를 사용한 SQL 로 작성.
 * 
 * 패턴이 총 3가지임. 여기서 어떤 부분이 가독성과 유지보수성이 좋은지 비교.
 * 
 * */

select count(*) from customer c ;  /* 고객수가 599임. */

/* case 1 */
select c.first_name , c.last_name , ct.city /* count(*) */
  from customer c
  inner join address a
     on c.address_id = a.address_id
  inner join city ct 
     on a.city_id = ct.city_id;
    
    
/* case 2 */
select c.first_name, c.last_name, addr.address, addr.city  /* count(*) */ 
  from customer c 
 inner join (
 				select a.address_id, a.address, ct.city
 				  from address a 
 				 inner join city ct
 				    on a.city_id = ct.city_id
 			) addr
     on c.address_id = addr.address_id;
 
/* case 3 */
create view address_vw2 as
select a.address_id, a.address, ct.city
 				  from address a 
 				 inner join city ct
 				    on a.city_id = ct.city_id;
 				   
select * from address_vw2;

select c.first_name, c.last_name, addr.address, addr.city  /* count(*) */ 
  from customer c 
 inner join address_vw2 addr
     on c.address_id = addr.address_id;

select count(*)  
  from customer c 
 inner join address_vw2 addr
     on c.address_id = addr.address_id;


 				