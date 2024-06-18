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
 * */
 




