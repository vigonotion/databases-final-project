/*
	Indexes for database: Rainforest
*/
USE Rainforest
GO

--TRating
CREATE INDEX IDX_iUserId ON TRating (iUserId)

--TProduct
CREATE INDEX IDX_cName ON TProduct (cName);

--TCreditCard
CREATE INDEX IDX_iUserId ON TCreditCard (iUserId);

--TUser
--Email index automatically created due to unique constraint

