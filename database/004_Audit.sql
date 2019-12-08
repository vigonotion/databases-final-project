USE Rainforest
GO

CREATE TABLE TAuditUser(
	iId int IDENTITY NOT NULL,
	iOldUserId int,
	cOldEmail VARCHAR(100),
	cOldFirstName VARCHAR(100),
	cOldLastName VARCHAR(100),
	cOldAddress VARCHAR(100),
	cOldZipCode CHAR(4),
	cOldPhoneNo CHAR(8),
	fOldTotalPaid MONEY,
	iNewUserId int,
	cNewEmail VARCHAR(100),
	cNewFirstName VARCHAR(100),
	cNewLastName VARCHAR(100),
	cNewAddress VARCHAR(100),
	cNewZipCode CHAR(4),
	cNewPhoneNo CHAR(8),
	fNewTotalPaid MONEY,
	cDdl CHAR(6) NOT NULL,
	cUser VARCHAR(50) NOT NULL,
	dDate DATETIME2 NOT NULL,
	PRIMARY KEY(iId)
)
GO

CREATE OR ALTER TRIGGER trigAuditTUser
ON TUser
AFTER INSERT, DELETE, UPDATE
AS	
BEGIN
	DECLARE @oldUserId VARCHAR(100)
	DECLARE @oldEmail VARCHAR(100)
	DECLARE @oldFirstName VARCHAR(100)
	DECLARE @oldLastName VARCHAR(100)
	DECLARE @oldAddress VARCHAR(100)
	DECLARE @oldZipcode CHAR(4)
	DECLARE @oldPhone CHAR(8)
	DECLARE @oldTotalPaid MONEY

	DECLARE @userId VARCHAR(100)
	DECLARE @email VARCHAR(100)
	DECLARE @firstName VARCHAR(100)
	DECLARE @lastName VARCHAR(100)
	DECLARE @address VARCHAR(100)
	DECLARE @zipcode CHAR(4)
	DECLARE @phone CHAR(8)
	DECLARE @totalPaid MONEY

	DECLARE @date DATETIME2
	DECLARE @ddl CHAR(6)
	DECLARE @dbUser VARCHAR(50)
	SELECT @date = SYSUTCDATETIME()
	SELECT @dbUser = CURRENT_USER

	IF EXISTS (SELECT * FROM INSERTED) AND EXISTS (SELECT * FROM DELETED)
	BEGIN
	SELECT @ddl = 'UPDATE'
	SELECT	@userId = iUserId,
			@email = cEmail,
			@firstName = cFirstName,
			@lastName = cLastName,
			@address = cAddress,
			@zipcode = cZipcode,
			@totalPaid = ftotalPaid
	FROM inserted
	SELECT	@oldUserId = iUserId,
			@oldEmail = cEmail,
			@oldFirstName = cFirstName,
			@oldLastName = cLastName,
			@oldAddress = cAddress,
			@oldZipcode = cZipcode,
			@phone = cPhoneNo,
			@oldTotalPaid = ftotalPaid
	FROM deleted

	INSERT TAuditUser (iOldUserId, cOldEmail, cOldFirstName, 
						cOldLastName, cOldAddress, cOldZipcode, 
						cOldPhoneNo, fOldTotalPaid,
						iNewUserId, cNewEmail, cNewFirstName, 
						cNewLastName, cNewAddress, cNewZipcode, 
						cNewPhoneNo, fNewTotalPaid, cDdl, cUser, dDate) 
	VALUES (@oldUserId, @oldEmail, @oldFirstName, @oldLastName,
			@oldAddress, @oldZipcode, @oldPhone, @oldTotalPaid,
			@userId, @email, @firstName, @lastName,
			@address, @zipcode, @phone, @totalPaid,
			@ddl, @dbUser, @date)
	END

	IF EXISTS (SELECT * FROM INSERTED) AND NOT EXISTS (SELECT * FROM DELETED)
	BEGIN
	SELECT @ddl = 'INSERT'
	SELECT	@userId = iUserId,
			@email = cEmail,
			@firstName = cFirstName,
			@lastName = cLastName,
			@address = cAddress,
			@zipcode = cZipcode,
			@phone = cPhoneNo,
			@totalPaid = ftotalPaid
	FROM inserted

	INSERT TAuditUser (iNewUserId, cNewEmail, cNewFirstName, 
						cNewLastName, cNewAddress, cNewZipcode, 
						cNewPhoneNo, fNewTotalPaid, cDdl, cUser, dDate) 
	VALUES (@userId, @email, @firstName, @lastName,
			@address, @zipcode, @phone, @totalPaid,
			@ddl, @dbUser, @date)
	END

	IF NOT EXISTS (SELECT * FROM INSERTED) AND EXISTS (SELECT * FROM DELETED)
	BEGIN
	SELECT @ddl = 'DELETE'
	SELECT	@userId = iUserId,
			@email = cEmail,
			@firstName = cFirstName,
			@lastName = cLastName,
			@address = cAddress,
			@zipcode = cZipcode,
			@phone = cPhoneNo,
			@totalPaid = ftotalPaid
	FROM deleted

	INSERT TAuditUser (iOldUserId, cOldEmail, cOldFirstName, 
						cOldLastName, cOldAddress, cOldZipcode, 
						cOldPhoneNo, fOldTotalPaid, cDdl, cUser, dDate) 
	VALUES (@userId, @email, @firstName, @lastName,
			@address, @zipcode, @phone, @totalPaid,
			@ddl, @dbUser, @date)
	END

END
GO



CREATE TABLE TAuditCreditCard(
	iId int IDENTITY NOT NULL,
	cOldCreditCardNo CHAR(16),
	iOldUserId INT,
	cOldCardholdereName VARCHAR(200),
	cOldExpiration DATE,
	cOldCCV NUMERIC(3,0),
	cNewCreditCardNo CHAR(16),
	iNewUserId INT,
	cNewCardholdereName VARCHAR(200),
	cNewExpiration DATE,
	cNewCCV NUMERIC(3,0),
	cDdl CHAR(6) NOT NULL,
	cUser VARCHAR(50) NOT NULL,
	dDate DATETIME2 NOT NULL,
	PRIMARY KEY(iId)
)
GO


CREATE OR ALTER TRIGGER trigAuditTCreditCard
ON TCreditCard
AFTER INSERT, DELETE, UPDATE
AS	
BEGIN
	DECLARE @oldCreditCardNo CHAR(16)
	DECLARE @oldUserId INT
	DECLARE @oldCardholderName VARCHAR(200)
	DECLARE @oldExpiration DATE
	DECLARE @oldCCV NUMERIC(3,0)

	DECLARE @newCreditCardNo CHAR(16)
	DECLARE @newUserId INT
	DECLARE @newCardholderName VARCHAR(200)
	DECLARE @newExpiration DATE
	DECLARE @newCCV NUMERIC(3,0)

	DECLARE @date DATETIME2
	DECLARE @ddl CHAR(6)
	DECLARE @dbUser VARCHAR(50)
	SELECT @date = SYSUTCDATETIME()
	SELECT @dbUser = CURRENT_USER

	IF EXISTS (SELECT * FROM INSERTED) AND EXISTS (SELECT * FROM DELETED)
	BEGIN
	SELECT @ddl = 'UPDATE'
	SELECT	@oldCreditCardNo = cCreditCardNo,
			@oldUserId = iUserId,
			@oldCardholderName = cCardholderName,
			@oldExpiration = cExpiration,
			@oldCCV = cCCV
	FROM deleted
	SELECT	@newCreditCardNo = cCreditCardNo,
			@newUserId = iUserId,
			@newCardholderName = cCardholderName,
			@newExpiration = cExpiration,
			@newCCV = cCCV
	FROM inserted

	INSERT TAuditCreditCard(cOldCreditCardNo, iOldUserId, cOldCardholdereName, 
						cOldExpiration, cOldCCV,
						cNewCreditCardNo, iNewUserId, cNewCardholdereName, 
						cNewExpiration, cNewCCV,
						cDdl, cUser, dDate) 
	VALUES (@oldCreditCardNo, @oldUserId, @oldCardholderName, 
			@oldExpiration, @oldCCV,
			@newCreditCardNo, @newUserId, @newCardholderName, 
			@newExpiration, @newCCV,
			@ddl, @dbUser, @date)
	END

	IF EXISTS (SELECT * FROM INSERTED) AND NOT EXISTS (SELECT * FROM DELETED)
	BEGIN
	SELECT @ddl = 'INSERT'
	SELECT	@newCreditCardNo = cCreditCardNo,
			@newUserId = iUserId,
			@newCardholderName = cCardholderName,
			@newExpiration = cExpiration,
			@newCCV = cCCV
	FROM inserted

	INSERT TAuditCreditCard(	
			cNewCreditCardNo, iNewUserId, 
			cNewCardholdereName, cNewExpiration, 
			cNewCCV, cDdl, cUser, dDate) 
	VALUES (@newCreditCardNo, @newUserId, 
			@newCardholderName, @newExpiration, 
			@newCCV, @ddl, @dbUser, @date)
	END

	IF NOT EXISTS (SELECT * FROM INSERTED) AND EXISTS (SELECT * FROM DELETED)
	BEGIN
	SELECT @ddl = 'DELETE'
	SELECT	@oldCreditCardNo = cCreditCardNo,
			@oldUserId = iUserId,
			@oldCardholderName = cCardholderName,
			@oldExpiration = cExpiration,
			@oldCCV = cCCV
	FROM deleted

	INSERT TAuditCreditCard(	
			cOldCreditCardNo, iOldUserId, 
			cOldCardholdereName, cOldExpiration, 
			cOldCCV, cDdl, cUser, dDate) 
	VALUES (@OldCreditCardNo, @OldUserId, 
			@OldCardholderName, @OldExpiration, 
			@OldCCV, @ddl, @dbUser, @date)
	END

END
GO



/*
insert TUser values ('test@o2.dk','tess','ter','england','1111','12315678',0)
update Tuser set cFirstName = 'cFirstName' where cFirstName = 'tess'
delete TAuditUser where cDdl = 'insert'
select * from TUser
select * from TAuditUser

SELECT SYSTEM_USER, current_user, SUSER_NAME(), SUSER_ID()
select char('66')
go
*/