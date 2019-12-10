-- updates the average rating for a product after each new rating
create or alter trigger UpdateAvgRatingForProduct on TRating after insert
as
begin
    declare @iProductId int
    select @iProductId = iProductId from inserted
    print N'Updating avg rating on the product:'
    print @iProductId
    exec SetAvgProductRating @iProductId
end

---Trigger for Update stock
create or alter trigger UpdateProductInStock on TInvoiceLine after insert
as
begin
    declare @iProductId int
    select @iProductId = iProductId from inserted
    print N'Updating product in stock:'
    print @iProductId
    exec dbo.ProductinStock @iProductId
end

---Trigger for Update Total price in Invoice

create or alter trigger UpdateTotalPrice on TInvoiceLine after insert
as
begin
    declare @iInvoiceId int
    select @iInvoiceId = iInvoiceId from inserted
    print N'Updating Invoice Total Price :'
    print @iInvoiceId
    exec dbo.Totalmoney @iInvoiceId
end


---Update User total paid
create or alter trigger UpdateTotalPaid on TInvoice after insert
as
begin
    declare @iUserId int
    select @iUserId = iUserId from inserted
    print N'Updating user total paid:'
    print @iUserId
    exec dbo.Totalpaid @iUserId
end