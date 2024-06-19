/* View 
 * 
 * 1. 사용 목적
 *    - 데이터 보안
 *    - 사용자 친화적 SQL 이 되도록
 *    - 재사용성, 유지보수성
 *    - 복잡도를 낮추기 위해서
 * 
 * 2. View 생성 방법
 *    create view view_name( col1, col2 .... ) as
 *    select ( col1, col2 .... ) from table_name;
 * 
 * 3. View 에 대한 사용 권한 제어
 *    - 현재는 root 유저.
 *    - 스키마 별로 유저를 생성.
 *      스키마 별로 View 에 대한 사용 권한을 부여.
 *    
 *    - marketing user, insa user, other user 등으로 생성.
 *      customer_v 고객 table 뷰를 생성해서, other user 에게 접근 권한 부여.(grant)
 *      customer table 접근 권한 회수(revoke)
 * 
 *    - 경우에 따라서, 갱신 view 를 생성해서 제공해야 할 경우도 있음.
 * 
 * 
 * 
 */


/*
 * 고객 정보 table을 기준으로 view 를 생성.
 * 고객ID, first_name, last_name 항목은 그대로 다 보여지도록 하고,
 * 단, 이메일 주소는 부분 * 로 마킹해서 보여지도록 함.
 * 
 * 이메일 주소 마킹처리된 예 : MA*****.org
 * 
 *                        MAster0001.org
 * 
 * 문자열 처리 : substr()
 * */
SELECT concat(
		substr('MAster0001.org', 1, 2), 
		'******', 
		substr('MAster0001.org', -4) );
	
create view customer_vw
( customer_id, first_name, last_name, email )
as
select customer_id, first_name, last_name, 
		concat(
			substr(email, 1, 2), 
			'******', 
			substr(email, -4) ) email
  from customer c ;
 
select * from customer_vw;

drop view customer_vw;


 





/*
 * 목적 : 복잡성 낮추는 것임.
 * 
 * 각 영화 정보에 대해서 
 * film_id, title, description, rating 가 출력이 되고,
 * 추가적으로 각 영화에 대한 영화 카테고리, 영화 출연 배우의 수,
 * 총 재고수, 각 영화의 대여횟수가 조회되도록 view 를 생성.
 * 
 * film 의 기본 칼럼을 제외하고 나머지 4개의 데이터는 스칼라 sub query 임.
 * 그리고, 스칼라 sub query 연관 관계의 조건 설정이 필요.
 * 
 * */

/*
 *  공통화 작업, 가독성 높이고, 유지보수 향상이 되도록 => 스칼라 sub query
 * */
create view film_total_info
as
select f.film_id, f.title, f.description, f.rating,
  (
  	select c.name
  	  from category c 
  	 inner join film_category fc 
  	    on c.category_id = fc.category_id -- 일반적인 inner join, 결과 : multi rows
  	 where fc.film_id = f.film_id	-- 상관관계, 결과 : single row
  ) category_info, -- 영화에 대한 영화 카테고리 정보
  (
  	select count(*)
  	  from film_actor fa 
  	 where fa.film_id = f.film_id 
  ) actor_cnt, -- 영화 출연 배우의 수
  (
  	select count(*)
  	  from inventory i 
  	 where i.film_id = f.film_id 
  ) inventory_cnt, -- 총 재고수
  (
  	select count(*)
  	  from inventory i 
  	 inner join rental r 
  	    on i.inventory_id = r.inventory_id
  	 where i.film_id = f.film_id 
  ) rental_cnt -- 영화의 대여횟수
  from film f ;


 select * from film_total_info;




/*
 * 영화 카테고리별 총 대여량을 조회하는 View 를 생성.
 * 
 * */







