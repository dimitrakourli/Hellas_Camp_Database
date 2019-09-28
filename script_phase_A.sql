CREATE DATABASE HELLAS_CAMP; 

CREATE TABLE Camp_details(
	camp_id char(3) NOT NULL,
	camp_name varchar(20) NOT NULL,
	total_positions int NOT NULL,
	
	PRIMARY KEY(camp_id),	

	CONSTRAINT CHK_Camp_id1 CHECK (camp_id='APL' OR camp_id='DIS' OR camp_id='KIS'),
	CONSTRAINT CHK_Camp_name CHECK (camp_name='Apollonia' OR camp_name='Kissamos' OR camp_name='Dionysus'),
	CONSTRAINT CHK_total_positions CHECK (total_positions=70 OR total_positions=50 OR total_positions=100),
);

CREATE TABLE Position_details(
	position_categ char(1) NOT NULL,
	position_range int NOT NULL,
	position_cost float NOT NULL,

	PRIMARY KEY(position_categ),

	CONSTRAINT CHK_position_categ1 CHECK (position_categ='A' OR position_categ='B' OR position_categ='C'),
	CONSTRAINT CHK_position_range CHECK (position_range=10 OR position_range=20 OR position_range=30),
	CONSTRAINT CHK_position_cost CHECK (position_cost=5.00 OR position_cost=10.00 OR position_cost=15.00)
);

CREATE TABLE Payment_Info(
	pay_id char(2) NOT NULL,
	payment_mean varchar(20) NOT NULL,

	PRIMARY KEY(pay_id),

	CONSTRAINT CHK_pay_id1 CHECK (pay_id='CC' OR pay_id='CH' OR pay_id='CA'),
	CONSTRAINT CHK_payment_mean CHECK (payment_mean='Credit Card' OR payment_mean='Cheque' OR payment_mean='Cash')
);

CREATE TABLE Customer(
	customer_id int NOT NULL,
	customer_name varchar(20) NOT NULL,
	customer_surname varchar(20) NOT NULL,
	customer_phone varchar(20) NOT NULL,

	PRIMARY KEY(customer_id)
);

CREATE TABLE Employee(
	employee_id int NOT NULL,
	employee_name varchar(20) NOT NULL,
	employee_surname varchar(20) NOT NULL,

	PRIMARY KEY(employee_id)
);

CREATE TABLE Booking_details(
	booking_id int NOT NULL,
	booking_date Date NOT NULL,
	pay_id char(2) NOT NULL,
	customer_id int NOT NULL,
	employee_id int NOT NULL,

	PRIMARY KEY(booking_id),
	FOREIGN KEY(pay_id) REFERENCES Payment_Info(pay_id),
	FOREIGN KEY(customer_id) REFERENCES Customer(customer_id),
	FOREIGN KEY(employee_id) REFERENCES Employee(employee_id),

	CONSTRAINT CHK_pay_id2 CHECK (pay_id='CC' OR pay_id='CH' OR pay_id='CA')
);

CREATE TABLE Booking(
	booking_id int NOT NULL,
	camp_id char(3) NOT NULL,
	position_num int NOT NULL,
	position_categ char(1) NOT NULL,
	date_start Date NOT NULL,
	date_end Date NOT NULL,
	number_people int NOT NULL,

	PRIMARY KEY(booking_id,camp_id,position_num),
	FOREIGN KEY(camp_id) REFERENCES Camp_details(camp_id),
	FOREIGN KEY(position_categ) REFERENCES Position_details(position_categ),
	FOREIGN KEY(booking_id) REFERENCES Booking_details(booking_id),

	CONSTRAINT CHK_Camp_id2 CHECK (camp_id='APL' OR camp_id='DIS' OR camp_id='KIS'),
	CONSTRAINT CHK_position_categ2 CHECK (position_categ='A' OR position_categ='B' OR position_categ='C')
);