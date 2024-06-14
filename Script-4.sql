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




