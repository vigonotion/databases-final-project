CREATE DATABASE Rainforest
GO
USE Rainforest
GO


CREATE TABLE TCity(
	cZip_code CHAR(4) NOT NULL,
	cCity VARCHAR(100) NOT NULL,
	PRIMARY KEY(cZip_code)
)

CREATE TABLE TUser(
	iUser_id int IDENTITY NOT NULL,
	cEmail VARCHAR(100) NOT NULL,
	cFirst_name VARCHAR(100) NOT NULL,
	cLast_name VARCHAR(100) NOT NULL,
	cAddress VARCHAR(100) NOT NULL,
	cZip_code CHAR(4) NOT NULL,
	cPhone_no CHAR(8) NOT NULL,
	fTotal_paid MONEY NOT NULL,
	PRIMARY KEY(cEmail),
	FOREIGN KEY(cZip_code) REFERENCES TCity
	);


CREATE TABLE TProduct(
	iProduct_id INT IDENTITY NOT NULL,
	cName VARCHAR(100) NOT NULL,
	cDescription varchar(1400) NOT NULL,
	fUnit_price SMALLMONEY NOT NULL,
	fAverage_rating numeric(3,2)
	PRIMARY KEY(iProduct_id)
	);

CREATE TABLE TRating(
	iProduct_id INT NOT NULL,
	cEmail VARCHAR(100) NOT NULL,
	iRating NUMERIC(1,0) NOT NULL,
	cComment VARCHAR(1400),
	PRIMARY KEY(iProduct_id, cEmail),
	FOREIGN KEY(iProduct_id) REFERENCES TProduct,
	FOREIGN KEY(cEmail) REFERENCES TUser
	);

CREATE TABLE TCreditCard(
	--check credit card length IN DENMARK
	cCredit_card_no CHAR(16) NOT NULL,
	cEmail VARCHAR(100) NOT NULL,
	cCardholder_name VARCHAR(200),
	cExpiration DATE NOT NULL,
	cCCV NUMERIC(3,0) NOT NULL,
	PRIMARY KEY(cCredit_card_no),
	FOREIGN KEY(cEmail) REFERENCES TUser
	);

CREATE TABLE TInvoice(
	iInvoice_id INT IDENTITY NOT NULL,
	dDate DATETIME2 NOT NULL,
	iVat NUMERIC(2,0) NOT NULL,
	fTotal_price MONEY NOT NULL,
	cEmail VARCHAR(100) NOT NULL,
	cCredit_card_no CHAR(16) NOT NULL,
	PRIMARY KEY(iInvoice_id),
	FOREIGN KEY(cEmail) REFERENCES TUser,
	FOREIGN KEY(cCredit_card_no) REFERENCES TCreditCard
	);

CREATE TABLE TInvoice_line(
	iInvoice_line_id INT IDENTITY NOT NULL,
	iProduct_id INT NOT NULL,
	iInvoice_id INT NOT NULL,
	fPrice SMALLMONEY NOT NULL,
	iQuantity INT NOT NULL,
	PRIMARY KEY(iInvoice_line_id),
	FOREIGN KEY(iProduct_id) REFERENCES TProduct,
	FOREIGN KEY(iInvoice_id) REFERENCES TInvoice
	);