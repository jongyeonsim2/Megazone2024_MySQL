/* ================== 집합 연산 ====================== */

/*
 * 1. 합집합
 *    union 연산 : 중복 제거
 *    union all 연산 : 중복 제거하지 않고, 원래 데이터 그대로 사용.
 * 
 *    A union B
 *    A union all B
 * 
 * 2. 교집합
 *    interset 연산
 * 
 *    A interset B
 * 
 * 3. 차집합
 *    except 연산
 * 
 *    A except B
 * 
 * 4. 조합 연산
 *    union, interset, except 를 조합해서 사용
 * 
 *    (A union B) except (A intersect B)
 *    (A except B) union (B except A)
 * 
 * 5. 집합 연산시 고려사항
 *    대상이 테이블임으로 칼럼의 개수, 칼럼의 데이터 타입을 고려.
 * 
 *    - 두 데이터셋 모두 같은 수의 열을 가져야 함.
 *    - 두 데이터 셋의 각 열의 자료형은 서로 동일해야 함.
 * 
 * 
 */

SELECT 1 num, 'abc' str
union
select 2 num, 'xyz' str;

/* 합집합 - 중복 제거 */
SELECT 1 num, 'abc' str
union
select 1 num, 'abc' str;

/* 합집합 - 중복 제거 처리 하지 않음. */
SELECT 1 num, 'abc' str
union all
select 1 num, 'abc' str;


desc customer;

desc actor;

/* 합집합 
 * 
 * 1. 데이터 출처를 구분할 필요.
 * 2. 다중 복합 집합 연산시, 집합 연산 전후의 count(*) 값을 비교.
 * */

/* 결과가 698 rows 
 * 
 * 동명이인이 존재. => union all 을 사용해야 함.
 * */
select 'customer' typ, first_name, last_name from customer c /* 599명 */
union
select 'actor' typ, first_name, last_name from actor a ; /* 200명 */

/* 결과가 699 rows */
select 'customer' typ, first_name, last_name from customer c /* 599명 */
union all
select 'actor' typ, first_name, last_name from actor a ; /* 200명 */


select c.first_name , c.last_name 
  from customer c 
 where c.first_name like 'J%' and c.last_name like 'D%'
union all
select a.first_name , a.last_name 
  from actor a 
 where a.first_name like 'J%' and a.last_name like 'D%';


 
 /* 교집합 - intersect */
 select c.first_name , c.last_name 
  from customer c 
 where c.first_name like 'J%' and c.last_name like 'D%'
intersect
select a.first_name , a.last_name 
  from actor a 
 where a.first_name like 'J%' and a.last_name like 'D%';




 /* 차집합 - except 
  * 
  * 똑같은 테이블 두 개를 서로 순서를 변경할 경우, 결과가 다름.
  * 
  * */
 select c.first_name , c.last_name 
  from customer c 
 where c.first_name like 'J%' and c.last_name like 'D%'
except
select a.first_name , a.last_name 
  from actor a 
 where a.first_name like 'J%' and a.last_name like 'D%';


select a.first_name , a.last_name 
  from actor a 
 where a.first_name like 'J%' and a.last_name like 'D%'
except
 select c.first_name , c.last_name 
  from customer c 
 where c.first_name like 'J%' and c.last_name like 'D%';


/* 집합 연산의 정렬 */
select c.first_name fname, c.last_name lname
  from customer c 
 where c.first_name like 'J%' and c.last_name like 'D%'
union all
select a.first_name , a.last_name 
  from actor a 
 where a.first_name like 'J%' and a.last_name like 'D%'
 order by lname, fname;











 