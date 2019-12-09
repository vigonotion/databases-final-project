CREATE DATABASE Rainforest
GO
USE Rainforest
GO


CREATE TABLE TCity(
	cZipCode CHAR(4) NOT NULL,
	cCity VARCHAR(100) NOT NULL,
	PRIMARY KEY(cZipCode)	
)

CREATE TABLE TUser(
	iUserId int IDENTITY NOT NULL,
	cEmail VARCHAR(100) UNIQUE NOT NULL,
	cFirstName VARCHAR(100) NOT NULL,
	cLastName VARCHAR(100) NOT NULL,
	cAddress VARCHAR(100) NOT NULL,
	cZipCode CHAR(4) NOT NULL,
	cPhoneNo CHAR(8) NOT NULL,
	fTotalPaid MONEY,
	PRIMARY KEY(iUserId),
	FOREIGN KEY(cZipCode) REFERENCES TCity
	);


CREATE TABLE TProduct(
	iProductId INT IDENTITY NOT NULL,
	cName VARCHAR(100) NOT NULL,
	cDescription varchar(1400) NOT NULL,
	fUnitPrice SMALLMONEY NOT NULL,
	iQuantity INT,
	fAverageRating numeric(3,2),
	PRIMARY KEY(iProductId)
	);

CREATE TABLE TRating(
	iProductId INT NOT NULL,
	iUserId int NOT NULL,
	iRating NUMERIC(1,0),
	cComment VARCHAR(1400),
	PRIMARY KEY(iProductId, iUserId),
	FOREIGN KEY(iProductId) REFERENCES TProduct,
	FOREIGN KEY(iUserId) REFERENCES TUser
	);

CREATE TABLE TCreditCard(
	--check credit card length IN DENMARK
	cCreditCardNo CHAR(16) NOT NULL,
	iUserId int NOT NULL,
	cCardholderName VARCHAR(200),
	cExpiration DATE NOT NULL,
	cCCV NUMERIC(3,0) NOT NULL,
	PRIMARY KEY(cCreditCardNo),
	FOREIGN KEY(iUserId) REFERENCES TUser
	);

CREATE TABLE TInvoice(
	iInvoiceId INT IDENTITY NOT NULL,
	dDate DATETIME2 NOT NULL,
	iVat NUMERIC(2,0) NOT NULL,
	fTotalPrice MONEY NOT NULL,
	iUserId int NOT NULL,
	cCreditCardNo CHAR(16) NOT NULL,
	PRIMARY KEY(iInvoiceId),
	FOREIGN KEY(iUserId) REFERENCES TUser,
	FOREIGN KEY(cCreditCardNo) REFERENCES TCreditCard
	);

CREATE TABLE TInvoiceLine(
	iInvoiceLineId INT IDENTITY NOT NULL,
	iProductId INT NOT NULL,
	iInvoiceId INT NOT NULL,
	fPrice SMALLMONEY NOT NULL,
	iQuantity INT NOT NULL,
	PRIMARY KEY(iInvoiceLineId),
	FOREIGN KEY(iProductId) REFERENCES TProduct,
	FOREIGN KEY(iInvoiceId) REFERENCES TInvoice
	);