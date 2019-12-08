create procedure Totalmoney(@iInvoiceId INT) as
begin
    set nocount on
    update TInvoice
    set fTotalPrice = (select sum(fPrice) from TInvoiceLine where iInvoiceId = @iInvoiceId group by iInvoiceId)
    where iInvoiceId =@iInvoiceId

end