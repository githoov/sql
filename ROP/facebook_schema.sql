CREATE TABLE user(
  id INT NOT NULL AUTO_INCREMENT
  , first_name VARCHAR(20)
  , last_name VARCHAR(20)
  , created_date DATE
  , profile_id INT NOT NULL
  , PRIMARY KEY(`id`)  
);

INSERT INTO user
VALUES(1, 'John', 'Spiel', '2012-01-11', 1209);

INSERT INTO user
VALUES(2, 'Mike', 'Johnson', '2013-08-02', 1210);

INSERT INTO user
VALUES(3, 'Scott', 'Hoover', '2014-01-01', 1211);

INSERT INTO user
VALUES(4, 'Mike', 'Xu', '2014-01-01', 1212);

INSERT INTO user
VALUES(5, 'Nathan', 'Finn', '2014-01-02', 1213);

INSERT INTO user
VALUES(6, 'John', 'Doe', '2014-01-03', 1214);


CREATE TABLE profile(
  id INT NOT NULL AUTO_INCREMENT
  , about_me VARCHAR(200)
  , quote VARCHAR(200)
  , birthday DATE
  , high_school VARCHAR(60)
  , college VARCHAR(60)
  , current_city VARCHAR(20)
  , state VARCHAR(2)
  , occupation VARCHAR(20)
  , workplace_id INT NOT NULL
  , income INT
  , PRIMARY KEY(`id`)
);

INSERT INTO profile
VALUES(1209, 'I am a made up man, but I might feel too.', "Don't quote me on that."
	   , '1990-05-14', 'Central LA High School', 'University of California, Los Angeles'
	   , 'Los Angeles', 'CA', 'Editor', 11, 45000);

INSERT INTO profile
VALUES(1210, 'I like computer science and teaching.', 'Algebraic!'
	   , '1982-05-27', 'Central Rochester High School', 'New York University'
	   , 'Santa Cruz', 'CA', 'Professor', 13, 60000);

INSERT INTO profile
VALUES(1211, 'I write SQL like a boss.', 'Youth culture forever!'
       , '1983-08-30', 'Santa Cruz High School', 'University of California, Berkeley'
       , 'Santa Cruz', 'CA', 'Analyst', 12, 30000);

INSERT INTO profile
VALUES(1212, 'I build things with computers.', 'Enchiridion!', 
       '1987-04-21', 'Mission High School', 'University of California, Santa Cruz'
       , 'Santa Cruz', 'CA', 'Analyst', 12, 41000);

INSERT INTO profile
VALUES(1213, 'I make money using existing money.', 'Sweeeeeet!', 
       '1987-10-24', 'Cicero High School', 'Columbia University'
       , 'Chicago', 'IL', 'Hedge Fund Manager', 14, 67000);

INSERT INTO profile
VALUES(1214, 'I am a standard dude.', 'Stuff', 
       '1988-09-24', 'Red Bluff Community High School', 'Northwestern University'
       , 'Evanston', 'IL', 'Hedge Fund Analyst', 14, 52000);

CREATE TABLE workplace(
  id INT NOT NULL AUTO_INCREMENT
  , company_name VARCHAR(60)
  , city VARCHAR(20)
  , state VARCHAR(2)
  , PRIMARY KEY(`id`)  
);

INSERT INTO workplace
VALUES(11, 'Spiel Publishing', 'Van Nuys', 'CA');

INSERT INTO workplace
VALUES(12, 'Looker', 'Santa Cruz', 'CA');

INSERT INTO workplace
VALUES(13, 'University of California, Santa Cruz', 'Santa Cruz', 'CA');

INSERT INTO workplace
VALUES(14, 'Finn-Brehnan', 'Chicago', 'IL');


CREATE TABLE status(
  id INT NOT NULL AUTO_INCREMENT
  , created_date DATE
  , status_message VARCHAR(300)
  , user_id INT NOT NULL
  , PRIMARY KEY(`id`)  
);

INSERT INTO status
VALUES(1, '2013-02-01', "Yesterday I had lunch at a sandwich shop, but it wasn't good.", 1);

INSERT INTO status
VALUES(2, '2013-04-04', "Dude, what's with the sandwichs in this town!?", 1);

INSERT INTO status
VALUES(3, '2014-01-01', "I don't get why I need to tell the world everything.", 3);

INSERT INTO status
VALUES(4, '2014-01-02', "I get it now!", 3);

INSERT INTO status
VALUES(5, '2014-01-01', "Late for work again.", 4);

INSERT INTO status
VALUES(6, '2014-01-02', "Two days in a row.", 4);

INSERT INTO status
VALUES(7, '2014-01-12', "I'm not feeling well. Send me good thoughts.", 5);


CREATE TABLE alt_user(
  id INT NOT NULL AUTO_INCREMENT
  , first_name VARCHAR(20)
  , last_name VARCHAR(20)
  , created_date DATE
  , profile_id INT NOT NULL
  , PRIMARY KEY(`id`)  
);

INSERT INTO alt_user
VALUES(1, 'John', 'Spiel', '2012-01-11', 1209);

INSERT INTO alt_user
VALUES(2, 'Mike', 'Johnson', '2013-08-02', 1210);

INSERT INTO alt_user
VALUES(3, 'Scott', 'Hoover', '2014-01-01', 1211);