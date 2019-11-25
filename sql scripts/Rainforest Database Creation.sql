USE master
GO

DROP DATABASE IF EXISTS Rainforest

CREATE DATABASE Rainforest
USE Rainforest
GO

CREATE TABLE TUser(
	email VARCHAR(100) NOT NULL,
	first_name VARCHAR(100) NOT NULL,
	sur_name VARCHAR(100) NOT NULL,
	"address" VARCHAR(100) NOT NULL,
	zip_code CHAR(4) NOT NULL,
	city VARCHAR(100) NOT NULL,
	phone_no CHAR(8) NOT NULL,
	total_paid DECIMAL NOT NULL,
	PRIMARY KEY(email)
	);

CREATE TABLE TProduct(
	product_id INT IDENTITY NOT NULL,
	"name" VARCHAR(100) NOT NULL,
	"description" TEXT NOT NULL,
	unit_price DECIMAL NOT NULL,
	average_rating numeric(3,2)
	PRIMARY KEY(product_id)
	);

CREATE TABLE TRating(
	product_id INT NOT NULL,
	email VARCHAR(100) NOT NULL,
	rating NUMERIC(1,0) NOT NULL,
	comment TEXT,
	PRIMARY KEY(product_id, email),
	FOREIGN KEY(product_id) REFERENCES TProduct,
	FOREIGN KEY(email) REFERENCES TUser
	);

CREATE TABLE TCreditCard(
	--check credit card length IN DENMARK
	credit_no VARCHAR(19) NOT NULL,
	email VARCHAR(100) NOT NULL,
	cardholder_name VARCHAR(200),
	expiration DATE NOT NULL,
	CCV NUMERIC(3,0) NOT NULL,
	PRIMARY KEY(credit_no),
	FOREIGN KEY(email) REFERENCES TUser
	);

CREATE TABLE TInvoice(
	invoice_id INT IDENTITY NOT NULL,
	"date" DATE NOT NULL,
	vat NUMERIC(2,0) NOT NULL,
	total_price DECIMAL NOT NULL,
	email VARCHAR(100) NOT NULL,
	card_no VARCHAR(19) NOT NULL,
	PRIMARY KEY(invoice_id),
	FOREIGN KEY(email) REFERENCES TUser,
	FOREIGN KEY(card_no) REFERENCES TCreditCard
	);

CREATE TABLE TInvoice_line(
	invoice_line_id INT IDENTITY NOT NULL,
	product_id INT NOT NULL,
	invoice_id INT NOT NULL,
	price DECIMAL NOT NULL,
	quantity INT NOT NULL,
	PRIMARY KEY(invoice_line_id),
	FOREIGN KEY(product_id) REFERENCES TProduct,
	FOREIGN KEY(invoice_id) REFERENCES TInvoice
	);