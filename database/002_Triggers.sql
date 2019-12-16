-- updates the average rating for a product after each new rating
CREATE OR ALTER trigger UpdateAvgRatingForProduct ON TRating after INSERT
AS
BEGIN
    DECLARE @iProductId int
    SELECT @iProductId = iProductId FROM INSERTED
    print N'Updating avg rating ON the product:'
    print @iProductId
    EXEC SetAvgProductRating @iProductId
END

---Trigger for Update stock
CREATE OR ALTER trigger UpdateProductInStock ON TInvoiceLine after INSERT
AS
BEGIN
    DECLARE @iProductId int
    SELECT @iProductId = iProductId FROM INSERTED
    print N'Updating product in stock:'
    print @iProductId
    EXEC dbo.ProductinStock @iProductId
END

---Trigger for Update Total price in Invoice

CREATE OR ALTER trigger UpdateTotalPrice ON TInvoiceLine after INSERT
AS
BEGIN
    DECLARE @iInvoiceId int
    SELECT @iInvoiceId = iInvoiceId FROM INSERTED
    print N'Updating Invoice Total Price :'
    print @iInvoiceId
    EXEC dbo.TotalmONey @iInvoiceId
END


---Update User total paid
CREATE OR ALTER trigger UpdateTotalPaid ON TInvoice after INSERT
AS
BEGIN
    DECLARE @iUserId int
    SELECT @iUserId = iUserId FROM INSERTED
    print N'Updating user total paid:'
    print @iUserId
    EXEC dbo.Totalpaid @iUserId
END