

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



/* ================== 다중 테이블 활용 ================== */

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
 * 
 * */
 

 				