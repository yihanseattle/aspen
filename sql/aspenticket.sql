drop schema `hoticket` ;
CREATE SCHEMA `hoticket` ;

CREATE TABLE `hoticket`.`movie` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `release_time` DATE NULL DEFAULT '2016-01-01',
  `rating` FLOAT NULL DEFAULT 0.0,
  `length` INT NULL DEFAULT 0,
  `genre` VARCHAR(100) NULL DEFAULT 'null',
  `img_url` VARCHAR(1000) NULL,
  `synopsis` VARCHAR(10000) NULL DEFAULT 'this is a movie!',
  `trailer_url` VARCHAR(1000) NULL,
  PRIMARY KEY (`id`));
  

  
  CREATE TABLE `hoticket`.`theatre` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(250) NULL DEFAULT 'theatre',
  `city` VARCHAR(45) NULL DEFAULT 'null',
  `state` VARCHAR(45) NULL DEFAULT 'null',
  `zipcode` INT NULL DEFAULT NULL,
  `address` VARCHAR(250) NULL DEFAULT 'null',
  `phone_number` VARCHAR(13) NULL DEFAULT 'null',
  `supported` INT NULL DEFAULT 0,
  PRIMARY KEY (`id`));
  
  CREATE TABLE `hoticket`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(250) NOT NULL,
  `first_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NULL,
  `password` VARCHAR(20) NOT NULL,
  `user_name` VARCHAR(45) NOT NULL,
  `role` INT NOT NULL DEFAULT 0 COMMENT '0:customer\n1:admin\n2:manager\n3:movie chain',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC));



CREATE TABLE `hoticket`.`customer` (
  `id` INT NOT NULL,
  `birthday` DATE NULL,
  `gender` INT NULL COMMENT '0:male\n1:female\n2:other',
  `zipcode` INT NULL,
  `genres` VARCHAR(250) NULL,
FOREIGN KEY (`id`)
    REFERENCES `hoticket`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

CREATE TABLE `hoticket`.`billing_account` (
  `id` INT NOT NULL AUTO_INCREMENT,
   `customer_id` INT NOT NULL,
  `card_number` VARCHAR(45) NOT NULL,
  `card_holder` VARCHAR(45) NOT NULL,
  `card_type` VARCHAR(20) NOT NULL,
  `cvs` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`customer_id`)
    REFERENCES `hoticket`.`customer` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);


CREATE TABLE `hoticket`.`billing_address` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `customer_id` INT NOT NULL,
  `address` VARCHAR(100) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `state` VARCHAR(45) NOT NULL,
  `zipcode` INT NOT NULL,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`customer_id`)
    REFERENCES `hoticket`.`customer` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);


CREATE TABLE `hoticket`.`showing` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `theatre_id` INT NOT NULL,
  `movie_id` INT NOT NULL,
  `date` DATE NOT NULL,
  `category` VARCHAR(45) NOT NULL,
  `start_time` TIME NOT NULL,
  `ticket_number` INT NOT NULL,
  PRIMARY KEY (`id`),
    FOREIGN KEY (`theatre_id`)
    REFERENCES `hoticket`.`theatre` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (`movie_id`)
    REFERENCES `hoticket`.`movie` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);


CREATE TABLE `hoticket`.`pay_history` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `ticket_number` INT NOT NULL,
  `date` DATETIME NOT NULL,
  `showing_id` INT NOT NULL,
  `billing_account_id` INT NOT NULL,
  `billing_address_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`showing_id`)
    REFERENCES `hoticket`.`showing` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (`billing_account_id`)
    REFERENCES `hoticket`.`billing_account` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (`billing_address_id`)
    REFERENCES `hoticket`.`billing_address` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);
    
    
  CREATE TABLE `hoticket`.`guest_billing_account` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(250) NOT NULL,
  `card_number` VARCHAR(45) NOT NULL,
  `card_holder` VARCHAR(45) NOT NULL,
  `card_type` VARCHAR(20) NOT NULL,
  `cvs` INT NOT NULL,
  PRIMARY KEY (`id`));


CREATE TABLE `hoticket`.`guest_billing_address` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(250) NOT NULL,
  `address` VARCHAR(100) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `state` VARCHAR(45) NOT NULL,
  `zipcode` INT NOT NULL,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`));

CREATE TABLE `hoticket`.`guest_pay_history` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `ticket_number` INT NOT NULL,
  `date` DATETIME NOT NULL,
  `showing_id` INT NOT NULL,
  `guest_billing_account_id` INT NOT NULL,
  `guest_billing_address_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`showing_id`)
    REFERENCES `hoticket`.`showing` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (`guest_billing_account_id`)
    REFERENCES `hoticket`.`guest_billing_account` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (`guest_billing_address_id`)
    REFERENCES `hoticket`.`guest_billing_address` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);  




CREATE TABLE `hoticket`.`employee` (
  `id` INT NOT NULL,
  `hourly_rate` INT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id`)
    REFERENCES `hoticket`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);





CREATE TABLE `hoticket`.`favorite_theatre` (
  `user_id` INT NOT NULL,
  `theatre_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `theatre_id`),
    FOREIGN KEY (`user_id`)
    REFERENCES `hoticket`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (`theatre_id`)
    REFERENCES `hoticket`.`theatre` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

CREATE TABLE `hoticket`.`favorite_movie` (
  `user_id` INT NOT NULL,
  `movie_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `movie_id`),
    FOREIGN KEY (`user_id`)
    REFERENCES `hoticket`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (`movie_id`)
    REFERENCES `hoticket`.`movie` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);


CREATE TABLE `hoticket`.`price_table` (
  `theatre_id` INT NOT NULL,
  `movie_id` INT NOT NULL,
  `category` INT NOT NULL,
  `price` INT NOT NULL DEFAULT 10,
  PRIMARY KEY (`theatre_id`, `movie_id`, `category`),
    FOREIGN KEY (`movie_id`)
    REFERENCES `hoticket`.`movie` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (`theatre_id`)
    REFERENCES `hoticket`.`theatre` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

CREATE TABLE `hoticket`.`rating` (
  `user_id` INT NOT NULL,
  `movie_id` INT NOT NULL,
  `rating_score` INT NOT NULL DEFAULT 0 COMMENT '0-5',
  `comment` VARCHAR(500) NOT NULL DEFAULT 'This is an awesome movie',
  PRIMARY KEY (`user_id`, `movie_id`),
    FOREIGN KEY (`user_id`)
    REFERENCES `hoticket`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (`movie_id`)
    REFERENCES `hoticket`.`movie` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);


