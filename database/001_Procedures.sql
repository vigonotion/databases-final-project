-- calculates the average rating for a product based on all ratings.
USE Rainforest
GO

CREATE PROCEDURE SetAvgProductRating (@iProductId INT) AS
BEGIN
    SET NOCOUNT ON
    UPDATE TProduct
    SET fAverageRating = (
        SELECT avg(iRating) FROM TRating WHERE iProductId = @iProductId GROUP BY iProductId
    )
    WHERE iProductId = @iProductId

END
GO

-- calculates product in stock
CREATE PROCEDURE ProductinStock(@iProductId INT, @iInvoiceLineId INT) AS
BEGIN
	SET NOCOUNT ON
    UPDATE TProduct
    SET iQuantity = iQuantity-(
        SELECT iQuantity FROM TInvoiceLine WHERE iProductId = @iProductId AND iInvoiceLineId = @iInvoiceLineId
    )
    WHERE iProductId = @iProductId

END
GO

-- calculates total bill in invoice
CREATE PROCEDURE Totalmoney(@iInvoiceId INT) AS
BEGIN
    SET NOCOUNT ON
    UPDATE TInvoice
    SET fTotalPrice = (select sum(fPrice * iQuantity) FROM TInvoiceLine WHERE iInvoiceId = @iInvoiceId GROUP BY iInvoiceId)
    WHERE iInvoiceId =@iInvoiceId

END
GO

-- calculates the user total paid
CREATE PROCEDURE Totalpaid(@iUserId INT) AS
BEGIN
    SET NOCOUNT ON
    UPDATE TUser
    SET fTotalPaid = (select sum(fTotalPrice) FROM TInvoice WHERE iUserId = @iUserId GROUP BY iUserId)
    WHERE iUserId =@iUserId

END
GO