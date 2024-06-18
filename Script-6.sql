/*
   조건식
   
   case 표현식 문법
      case 
      	when 조건 then 반환할 표현식
      	when 조건2 then 반환할 표현식2
      	else 반환할 표현식3
      end
      
   case 표현식 장점
   	  - sql 표준(sql 92) 임. 대부분의 데이터베이스 제품에 구현되어 있음.
   	  - select, insert, update, delete 에서 사용 가능.
*/

/* 
 * 고객정보 조회. 활성화 고객, 비활성화 고객을 구분해서 출력.
 * 
 * customer.active : 1 : 활성화 고객(active)
 * 					 0 : 비활성화 고객(inactive)
 * */

select first_name , last_name , 
	case /* 조건식 start */
		when active = 1 then 'ACTIVE'
		else 'INACTIVE'
	end active_type  /* 조건식 end */
  from customer c ;

/*
 * 활성화 고객에 대해서는 대여횟수가 출력이 되도록 하고,
 * 비활성화 고객에 대해서는 대여횟수가 0 이 출력이 되도록 SQL 작성.
 * 
 * first_name, last_name, 대여횟수 로 출력이 되도록 함.
 * 단,  case 표현식을 사용.
 * 
 * 사용 테이블 : customer, rental
 * 대여 횟수 계산 : active = 0, 0 으로 출력
 *               active = 1, retal table 상관관계 조건 => 대여횟수
 * Main query : customer table 지정.
 * Sub query  : 스칼라 sub query 내에 대여 횟수 계산 처리
 * 
 * */
 
 select c.first_name, c.last_name,
 	case 
 		when active = 0 then 0
 		else
 		    (
 		    	select count(*)
 		    	  from rental r 
 		    	 where r.customer_id = c.customer_id
 		    )
 	end tot_rental_cnt
   from customer c ;
 
 
 
 
 
 
 /*
  * 2005 년 5월, 6월, 7월 의 월별 영화 대여 횟수를 출력하는 SQL 작성.
  * 
  * 조회결과는 대여월, 대여횟수 로 출력이 되도록 하고,
  * 단, case 표현식을 사용한 경우와 사용하지 않은 경우 모두 SQL 로 작성.
  * 
  * 그리고, case 표현식을 사용하지 않은 경우 결과는 3행으로 출력되도록 하고,
  * case 표현식을 사용한 경우는 1행으로 5월, 6월, 7월 의 월별 영화 대여 횟수가 출력이 되도록 함.
  * 
  * 1. case 표현식을 사용하지 않은 경우
  * 2. case 표현식을 사용한 경우
  */
 
  /* 1. 
   *    결과각 3 rows 임.
   *    2번에서 1 rows 가 되도록...
   * */ 
  select monthname(rental_date), count(*) 
    from rental r 
   where rental_date between '2005-05-01' and '2005-08-01'
   group by monthname(rental_date); 
  
  /* 2. */
  /* 1단계 : 5월, 6월, 7월 에 대한 각 한건에 대한 대여정보*/
  select monthname(rental_date), 1
    from rental r 
   where rental_date between '2005-05-01' and '2005-08-01' ;
  
  /* 2단계 : 5월에 대한 대여정보만 sum이 되도록 */
  select 
    sum((
    	case when monthname(rental_date) = 'May' then 1 else 0 end) 
    ) may_rental
    from rental
   where rental_date between '2005-05-01' and '2005-08-01';
  
  /* 2단계 검증 : 5월 대여정보 row 수 : 1156 건 */
  select count(*)
    from rental r 
   where rental_date between '2005-05-01' and '2005-06-01';
  
  /* 3단계 : 6월, 7월 추가 */
  select 
    sum((
    	case when monthname(rental_date) = 'May' then 1 else 0 end) 
    ) may_rental,
    sum((
    	case when monthname(rental_date) = 'June' then 1 else 0 end) 
    ) june_rental,
    sum((
    	case when monthname(rental_date) = 'July' then 1 else 0 end) 
    ) july_rental
    from rental
   where rental_date between '2005-05-01' and '2005-08-01';
  
  
 
 /*
  * 영화의 재고 수량에 따라 품절, 부족, 여유, 충분 으로 분류되어 출력이 되도록 SQL 을 작성.
  * 출력은 영화 제목, 재고 수량에 따른 분류명으로 출력이 되도록 함.
  * case 표현식을 사용해서 SQL 작성.
  * 
  * 분류 기준은
  *   - 품절 : 재고수량 0
  *   - 부족 : 재고수량 1 or 2
  *   - 여유 : 재고수량 3 or 4
  *   - 충분 : 재고수량 5 이상
  * 
  */
 
 




