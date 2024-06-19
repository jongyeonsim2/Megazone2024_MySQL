
/* ==================== 스토어드 프로시저 ==================== */

-- shoppingmall 스키마 생성
CREATE database shoppingmall;

-- 스키마 지정
use shoppingmall;

-- 테스트용 테이블 : 도메인 테이블이 아님.
create table usertbl
(
userID varchar(8) not null primary key, -- 쇼핑몰 사용자 ID, 제약조건
name varchar(30) not null, -- 회원명
birthYear int not null, -- 출생년도
addr varchar(8) not null, -- 지역(경기, 서울, 경남....)
mobile1 varchar(3), -- 휴대폰의 국번(011, 017...)
mobile2 varchar(8), -- 휴대폰의 나머지 번호
height int, -- 신장
mdate date -- 회원 가입일
);

-- 회원 구매 테이블
create table buytbl
(
num int auto_increment not null primary key, -- 순번
userID varchar(8) not null, -- 회원 아이디
prodName varchar(8) not null, -- 구매한 제품명
groupName varchar(4), -- 제품 분류
price int not null, -- 단가
amount int not null, -- 수량
foreign key (userID) references usertbl(userID) -- 제약조건
);

INSERT INTO usertbl VALUES('LSG', '이승훈', 1987, '서울', '010', '1111111', 182, '2008-8-8');
INSERT INTO usertbl VALUES('KBS', '김범수', 1990, '경남', '010', '2222222', 173, '2012-4-4');
INSERT INTO usertbl VALUES('KKH', '김경호', 2000, '전남', '010', '3333333', 177, '2007-7-7');
INSERT INTO usertbl VALUES('JYP', '조용수', 2005, '경기', '010', '4444444', 166, '2009-4-4');
INSERT INTO usertbl VALUES('SSK', '하준경', 1979, '서울', NULL  , NULL      , 186, '2013-12-12');
INSERT INTO usertbl VALUES('LJB', '임재호', 1999, '서울', '010', '6666666', 182, '2009-9-9');
INSERT INTO usertbl VALUES('YJS', '윤호신', 1987, '경남', 010  , NULL      , 170, '2005-5-5');
INSERT INTO usertbl VALUES('EJW', '은지효', 1997, '경북', '010', '8888888', 174, '2014-3-3');
INSERT INTO usertbl VALUES('JKW', '조현우', 2002, '경기', '010', '9999999', 172, '2010-10-10');
INSERT INTO usertbl VALUES('BBK', '하준희', 2001, '서울', '010', '0000000', 176, '2013-5-5');


INSERT INTO buytbl VALUES(NULL, 'KBS', '운동화', NULL   , 30,   2);
INSERT INTO buytbl VALUES(NULL, 'KBS', '노트북', '전자', 1000, 1);
INSERT INTO buytbl VALUES(NULL, 'JYP', '모니터', '전자', 200,  1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '모니터', '전자', 200,  5);
INSERT INTO buytbl VALUES(NULL, 'KBS', '청바지', '의류', 50,   3);
INSERT INTO buytbl VALUES(NULL, 'BBK', '메모리', '전자', 80,  10);
INSERT INTO buytbl VALUES(NULL, 'SSK', '책'    , '서적', 15,   5);
INSERT INTO buytbl VALUES(NULL, 'EJW', '책'    , '서적', 15,   2);
INSERT INTO buytbl VALUES(NULL, 'EJW', '청바지', '의류', 50,   1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '운동화', NULL   , 30,   2);
INSERT INTO buytbl VALUES(NULL, 'EJW', '책'    , '서적', 15,   1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '운동화', NULL   , 30,   2);

select * from usertbl u ;
select * from buytbl u ;



/* ============ 스토어드 프로시저 ============ 
 * 
 * 개요
 *    - 쿼리문의 집합. 특별한 동작을 처리하기 위한 용도로 사용.
 *    - 재사용, 모듈화 개발이 됨.
 * 
 * 특징
 *    - 프로시저는 현장에 따라서 취사 선택 사항임.
 *    - 성능 향상.
 *      몇 백 라인의 SQL 문장이 문자열로 네트워크를 경유해서 서버로 전송하면,
 *      경우에 따라서(수 많은 유저, 수 많은 데이터) 네트워크 부하가 발생될 수 있음.
 * 
 *      이런 문제점에 대해서 필요한 기능에 따른 SQL 문장들을 서버에 보관해서,
 *      호출해서 사용하는 형태가 되면 네트워크의 부하를 낮추는데 도움이 될 수 있음.
 * 
 *      SQL 파싱, 실행계획 등의 전처리 작업이 캐싱된 상태임으로 재사용하게 되어,
 *      성능이 높아지게 됨.
 * 
 *    - 유지 관리가 편리
 *      JAVA 쪽에서 개발을 하지 않고, 필요한 기능을 데이터 베이스 서버에 두게 됨으로
 *      기존방법의 경우 관리 포인트가 두 군데임.( JAVA, 미들웨어 ,데이터베이스 )
 *      데이터베이스에 프로시저를 사용하게 되면, 관리포인트가 하나가 될 수 있음.
 * 
 *      JAVA 의 백엔드 단에 sql 을 작성해서 운영중인데, sql 문장에 칼럼을 추가,
 *      where 문장 수정이 발생하면, 수정 => 테스트 => 빌드 => 배포 등의
 *      작업이 수행해야 함.
 *       
 *      스토어드 프로시저를 사용하게 되면, java 단에서 수정해야 하는 부분이
 *      많이 줄어들게 됨. 데이터 베이스의 프로시저의 sql 만 수정하면 됨.
 * 
 *    - 모듈식 개발이 가능해짐.
 *      함수처럼 사용할 수 있기 때문에, 다른 프로시저에서도 호출해서 사용 가능.
 * 
 *    - 보안 강화.
 *      table 에 직접 접근 대신에 스토어드 프로시저을 통해서 접근하게 됨. 
 * 
 * 문법 
 *     create procedure 프로시저명 ( in , out ) in : 입력, out : 출력(결과)
 *     begin
 * 			sql...
 * 			조건문 ....
 * 			반복문 ....
 * 			함수 ...
 * 			프로시저 ....
 *     end;
 * 
 *     call 프로시저명( 매개변수 );
 * 
 * */




/* ============ 매개변수가 없는 프로시저 ============ */

drop procedure if exists userProc;

create procedure userProc()
begin
	select * from usertbl;
end;

call userProc(); 


/* ============ in 매개변수가 하나가 있는 프로시저 ============ */


drop procedure if exists userProc1;

create procedure userProc1( in userName varchar(10) )
begin
	select * from usertbl where name = userName;
end;

call userProc1('은지효'); 


/* ============ in 매개변수가 두 개가 있는 프로시저 ============ */

drop procedure if exists userProc2;

create procedure userProc2( in userBirthYear int,
							in userHeight int )
begin
	select * from usertbl 
	 where birthYear > userBirthYear
	   and height > userHeight;
end;

call userProc2(1970, 178); 


/* ============ in, out 매개변수가 두 개가 있는 프로시저 ============ */

drop procedure if exists userProc3;

create table if not exists testtbl 
(
	id int auto_increment primary key,
	txt varchar(10)
);

create procedure userProc3 (	in textValue varchar(10),
								out outValue int
							)
begin
	insert into testtbl values(null, textValue);
	select max(id) into outValue from testtbl;
end;

call userProc3 ('테스트값', @outValue);

select * from testtbl t ;

select @outValue;

call userProc3 ('테스트값2', @outValue);

select * from testtbl t ;

select @outValue;





/* ============ in 매개변수, if 조건절 이 있는 프로시저 ============ */

drop procedure if exists ifElseProc;

create procedure ifElseProc(in userName varchar(10))
begin
	declare address varchar(8); -- 프로시저의 지역변수
	
	select addr into address from usertbl
	 where name = userName;
	
	if (address = '서울' or address = '경기') then 
		select '수도권 거주';
	else
		select '지방 거주';
	end if;
end;


call ifElseProc('김경호'); -- 전남
call ifElseProc('하준경'); -- 서울





/* ============ in 매개변수, 반복문 이 있는 프로시저 ============ */

drop table if exists gugudanTBL;

create table gugudanTBL ( txt varchar(100) );

drop procedure if exists gugudanProc;


create procedure gugudanProc()
begin
    declare str varchar(100); -- 구구단 결과 식 ( 2 X 1 = 2 )
	declare dan int; -- 구구단의 단
    declare i int; -- 1 ~ 9
    set dan = 2; -- 2 단부터 시작.
    
    delete from gugudanTBL;
    
    while ( dan < 10) do -- 2 ~ 9 단 반복
		set str = '';
        set i = 1;
        while ( i < 10) do
			set str = concat( str, ' ', dan, 'X', i, '=', dan*i );
            set i = i + 1;
        end while;
        set dan = dan + 1;
        insert into gugudanTBL values(str);
    end while;
end ;


call gugudanProc();

select * from gugudanTBL;





/* ============ 동적(dynamic) SQL 이 있는 프로시저 ============ 
 * 
 * 상황에 따라 SQL 변경이 실시간으로 필요한 경우,
 * 동적 SQL 을 사용하여, 실시간으로 수정 및 실행해서 사용.
 * 
 * */

drop procedure if exists dynamicSqlProc;

create procedure dynamicSqlProc ( in tblName varchar(20) )
begin
	-- 매개변수로 받은 테이블명을 사용해서 sql 문자열을 생성.
	set @sqlQuery = concat('select * from ', tblName);

	prepare myQuery from @sqlQuery; -- 동적 sql 실행 준비
									-- syntax, 테이블 존재 유무, 생성 권한 체크...
	execute myQuery;-- 동적 sql 실행
end;

call dynamicSqlProc('usertbl');
call dynamicSqlProc('buytbl');




/* ============ 프로시저 - cursor 활용 ============ 
 * 
 * 가장 많이 사용되어지는 형태
 * 
 * 커서(cursor)
 *    테이블에서 여러 개의 행을 쿼리한 후 쿼리의 결과인 행 집합에서
 *    한 행씩 처리 하기 위한 방식임.
 * 
 * 커처 처리 단계
 *    커서 선언(declare) -> 커서 열기(open) -> 커서 fetch -> 커서 close
 *    커서 fetch : 가져온 한 row 에 대해 데이터 처리를 수행.
 * 
 * 실습 내용
 *    대량의 고객 정보를 업데이트 하기 위한 프로시저를 개발.
 * 
 *    고객 정보 테이블에 고객 등급 칼럼을 추가 후 등급 관리를 하려고 함.
 *    ( 최우수 고객(1500이상), 우수 고객(1000이상), 일반 고객(1이상), 유령 고객 )
 * 
 * */

-- 회원 테이블에 고객 등급 칼럼 추가
alter table usertbl add grade varchar(10);

drop procedure if exists gradeProc;

create procedure gradeProc ()
begin
	/* 변수 선언 */
	declare id varchar(10); -- 회원ID
	declare sumOfAmount int; -- 총 구매 금액
	declare userGrade varchar(10);

	/* 커서 제어 변수 선언 */
	declare endOfRow boolean default false;

	/* 커서 선언 */
	declare userCursor cursor for
		select u.userid, sum(b.price * amount)
		  from usertbl u 
		  	left outer join buytbl b 
		  	on u.userid = b.userid
		  group by u.userid;
		 
	/* 커서 핸들링 제어 설정 */
	declare continue handler
			for not found set endOfRow = true;
		
	/* 커서 OPEN */
	open userCursor;

	/* 반복문 선언 */
	grade_loop: loop
		
		/* 커서 fetch */
		fetch userCursor into id, sumOfAmount;
	
		if endOfRow then
			leave grade_loop;
		end if;
		
		case
			when(sumOfAmount >= 1500) then set userGrade = '최우수고객';
			when(sumOfAmount >= 1000) then set userGrade = '우수고객';
			when(sumOfAmount >= 1) then set userGrade = '일반고객';
			else set userGrade = '유령고객';
		end case;
		
		/* 고객 등급 평가 결과를 반영 */
		update usertbl 
		   set grade = userGrade
		 where userID = id;
	
	end loop grade_loop;
	
end;

call gradeProc();

select * from usertbl u ;





/* ============ 스토어드 function ============ */
/* 두 정수를 매개변수로 받아서 더한 결과값을 반환하는 함수 */
-- 전역 환경변수를 1 또는 on 으로 설정
set global log_bin_trust_function_creators = 1;

drop function if exists userFunc1;

create function userFunc1(val1 int, val2 int)
	returns int
begin
	return val1 + val2;
end;

select userFunc1(100, 200);



/* 태어난 년도를 매개변수로 받아서, 현재 나이를 계산 및 반환 함수 */
drop function if exists getAgeFunc;

create function getAgeFunc(varYear int)
	returns int
begin
	declare age int;
	set age = year(curdate()) - varYear;
	return age;
end;

select getAgeFunc(2000);

select userID , name, getAgeFunc(u.birthYear) as '현재 나이'
  from usertbl u ;














































