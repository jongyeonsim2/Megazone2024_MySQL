
/* ==================== 스토어드 프로시저 ==================== */

-- shoppingmall 스키마 생성
CREATE database shoppingmall;

-- 스키마 지정
use shoppingmall;

-- 테스트용 테이블 : 도메인 테이블이 아님.
create table usettbl
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

)


