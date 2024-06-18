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
 * */







