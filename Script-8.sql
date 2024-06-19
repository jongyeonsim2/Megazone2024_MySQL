
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
