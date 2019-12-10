-- calculates the average rating for a product based on all ratings.
create procedure SetAvgProductRating (@iProductId INT) as
begin

    set nocount on
    update TProduct
    set fAverageRating = (
        select avg(iRating) from TRating where iProductId = @iProductId group by iProductId
    )
    where iProductId = @iProductId

end

-- calculates product in stock
create procedure ProductinStock(@iProductId INT) as
begin

    set nocount on
    update TProduct
    set iQuantity = iQuantity-(
        select sum(iQuantity) from TInvoiceLine where iProductId = @iProductId group by iProductId
    )
    where iProductId = @iProductId

end
-- calculates total bill in invoice
create procedure Totalmoney(@iInvoiceId INT) as
begin
    set nocount on
    update TInvoice
    set fTotalPrice = (select sum(fPrice) from TInvoiceLine where iInvoiceId = @iInvoiceId group by iInvoiceId)
    where iInvoiceId =@iInvoiceId

end

-- calculates the user total paid
create procedure Totalpaid(@iUserId INT) as
begin
    set nocount on
    update TUser
    set fTotalPaid = (select sum(fTotalPrice) from TInvoice where iUserId = @iUserId group by iUserId)
    where iUserId =@iUserId

end
