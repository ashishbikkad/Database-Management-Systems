create database restaurant1;
use restaurant1; 

create table geoplaces2
(
PlaceId int,
latitude real,
longitude real,
the_geom_meter text,
Name varchar (100),
Address varchar (255),
city varchar (255),
country varchar (255),
fax varchar (100),
Zip int,
alcohol varchar (255),
smoking_area varchar (300),
dress_code varchar (200),
Accessibility varchar (150),
price varchar (150),
url varchar (200),
rambience varchar (200),
franchise varchar (200),
Area varchar (255),
Other_Services varchar (255));

create table Chefmozaccepts

(placeID int,
payment varchar (150));

create table Chefmozcuisine

(placeID int,
Rcuisine varchar (150));

create table Userprofile

(UserID varchar(100),
Latitude real,
Longitude real,
Smoker varchar (255),
Drive_Level varchar (200),
dress_preference varchar (200),
ambience varchar (200),
transport varchar (100),
marital_status varchar (100),
hijos varchar (100),
birth_year int,
interest varchar (250), 
personality varchar (250),
religion varchar (100),
activity varchar (100),
color varchar (100),
Weight int,
Budget varchar (100),
Height int);

create table chefmozhours4
(
PlaceID int,
Hours time,
Days varchar (100));

create table Chefmozparking
(
PlaceID int,
Parkinglot varchar (100));

create table rating_final
(
UserID varchar (100),
PlaceID int,
Rating int,
Food_Rating int,
Service_Rating int);


create table Usercuisine
(
UserID  varchar (100),
Rcuisine  varchar (150));

create table Userpayment
(
UserID varchar (100),
Upayment varchar (250));

#Question 1: - We need to find out the total visits to all restaurants under all alcohol categories available.
select * from geoplaces2;
select alcohol from geoplaces2 group by alcohol;
select count(PlaceID) from geoplaces2 where alcohol != 'No_Alcohol_served';

#Question 2: -Let's find out the average rating according to alcohol and price so that 
#we can understand the rating in respective price categories as well.
show tables;
select * from rating_final;
select * from geoplaces2;
select alcohol, g.price, avg(rf.rating) from geoplaces2 g join rating_final rf using (placeID) 
where alcohol != 'No_Alcohol_served' group by price ;

#Question 3:  Let’s write a query to quantify that what are the parking availability as 
#well in different alcohol categories along with the total number of restaurants.
select * from chefmozparking;
select g.PlaceID, name, parking_lot, alcohol from geoplaces2 g 
join chefmozparking cp on g.PlaceID = cp.PlaceID where alcohol != "No_Alcohol_served";

#Question 4: -Also take out the percentage of different cuisine in each alcohol type.
select name, alcohol, Rcuisine, percent_rank() over(partition by alcohol order by Rcuisine) percentage_cuisine
from geoplaces2 join chefmozcuisine
using(PlaceID)
where alcohol != "No_Alcohol_served";

#Questions 5: - let’s take out the average rating of each state.
select avg(rating), state from geoplaces2 g join rating_final rf 
on g.placeID = rf.placeID group by state;

#Questions 6: -' Tamaulipas' Is the lowest average rated state. 
#Quantify the reason why it is the lowest rated by providing the summary on the basis of State, alcohol, and Cuisine.
select placeid, state, rating, alcohol
from geoplaces2 join rating_final using(placeid)
where state = 'Tamaulipas'
group by state;
#on the basis of alcohol it has the least rating because no alcohol is served in Tamaulipas.

select state, rating, alcohol, food_rating
from geoplaces2 join rating_final using(placeid)
where state = 'Tamaulipas'
group by state;
#let us find which user in tamaulipas has given rating 0 and find why they have given low rating.

select * from userprofile where userid in
(select userid from rating_final where placeid = '132740');

#there are 8 users in Tamaulipas and all of them are students, and they vary from low to medium budget, which is why 
#Tamaulipas is the least rated place.

#Question 7:  - Find the average weight, food rating, and service rating of the customers who have visited KFC 
#and tried Mexican or Italian types of cuisine, and also their budget level is low.
#We encourage you to give it a try by not using joins.
show tables;
select * from chefmozcuisine;  ####cuisines, #placeID
select * from userprofile;   ##weight and budget, #userID
select * from geoplaces2 where name = 'KFC';  ####kfc, #placeID
select * from rating_final;  ###food rating and servicerating, #placeID #userID

select avg(weight) from userprofile where budget = 'low' 
union
(select concat_ws(";", food_rating,  service_rating  ) from rating_final where placeid in
(select placeid from chefmozcuisine where rcuisine = 'mexican' or rcuisine = 'italian'
union 
(select placeid from geoplaces2 where name = 'KFC')));


/*
(select avg(weight) from userprofile where budget = 'low' in 
(select userid from rating_final where placeid in
(select service_rating from rating_final where placeid in
(select food_rating from rating_final where placeid in
(select placeid from chefmozcuisine where rcuisine = 'mexican' or rcuisine = 'italian' in 
(select placeid from geoplaces2 where name = 'kfc'))))));
 */
 