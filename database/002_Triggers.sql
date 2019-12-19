-- updates the average rating for a product after each new rating
USE Rainforest
GO

CREATE OR ALTER trigger UpdateAvgRatingForProduct ON TRating after INSERT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @iProductId int
    SELECT @iProductId = iProductId FROM INSERTED
    EXEC SetAvgProductRating @iProductId
END
GO

---Trigger for Update stock
CREATE OR ALTER trigger UpdateProductInStock ON TInvoiceLine after INSERT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @iProductId INT
            , @iInvoiceLineId INT
    SELECT @iProductId = iProductId, @iInvoiceLineId = iInvoiceLineId FROM INSERTED
    EXEC dbo.ProductinStock @iProductId, @iInvoiceLineId
END
GO

---Trigger for Update Total price in Invoice

CREATE OR ALTER trigger UpdateTotalPrice ON TInvoiceLine after INSERT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @iInvoiceId int
    SELECT @iInvoiceId = iInvoiceId FROM INSERTED
    EXEC dbo.TotalmONey @iInvoiceId
END
GO


---Update User total paid
CREATE OR ALTER trigger UpdateTotalPaid ON TInvoice after INSERT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @iUserId int
    SELECT @iUserId = iUserId FROM INSERTED
    EXEC dbo.Totalpaid @iUserId
END
GO

---Update Card total paid
CREATE OR ALTER trigger UpdateTotalPaidCardInsert ON TInvoice after INSERT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @iCardId int
    SELECT @iCardId = iCardId FROM INSERTED
    EXEC dbo.TotalpaidCard @iCardId
END
GO
CREATE OR ALTER trigger UpdateTotalPaidCardUpdate ON TInvoice after UPDATE
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @iCardId int
    SELECT @iCardId = iCardId FROM INSERTED
    EXEC dbo.TotalpaidCard @iCardId
END
GO