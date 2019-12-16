/*
	Indexes for database: Rainforest
*/

--TRating
CREATE INDEX IDX_iUserId ON TRating (iUserId)

--TProduct
CREATE INDEX IDX_cName ON TProduct (cName);
CREATE INDEX IDX_cDescription ON TProduct (cDescription);

--TUser
--Email index automatically created due to unique constraint

--TCreditCard
CREATE INDEX IDX_iUserId ON TCreditCard (iUserId);