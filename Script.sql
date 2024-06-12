
show databases;

show tables;

/*
 * actor                     
actor_info                
address                   
category                  
city                      
country                   
customer                  
customer_list             
film                      
film_actor                
film_category             
film_list                 
film_text                 
inventory                 
language                  
nicer_but_slower_film_list
payment                   
rental                    
sales_by_film_category    
sales_by_store            
staff                     
staff_list                
store                     
 */


select * from film a ;

/* insert, update, delete => transaction 종료 => commit, rollabck */


/* person favorite_food 간의 관계 : 1:N */

/* table 생성 - PK 가 설정 */
create table person
(
	person_id smallint unsigned,
	fname varchar(20),
	lname varchar(20),
	eye_color enum('BR', 'BL', 'GR'),
	birth_date date,
	street varchar(20),
	city varchar(20),
	state varchar(20),
	country varchar(20),
	postal_code varchar(20),
	constraint pk_person primary key (person_id)
);

select * from sakila.person;

/* table 생성 - PK, FK 가 설정 */
create table favorite_food
(
	person_id smallint unsigned,
	food varchar(20),
	constraint pk_favorite_food primary key(person_id, food),
	constraint fk_favorite_food_person_id foreign key(person_id)
	references person(person_id)
);

select * from favorite_food ;

/* insert */
insert into person
(person_id, fname, lname, eye_color, birth_date)
values
(1, 'William', 'Turner', 'BR', '1990-05-15');

select * from person ;

insert into person
(person_id, fname, lname, eye_color, birth_date)
values
(2, 'Mike', 'Willson', 'BR', '1980-08-15');


select * from person ;





