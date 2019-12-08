-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

create procedure ProductinStock(@iProductId INT) as
begin

    set nocount on
    update TProduct
    set iQuantity = iQuantity-(
        select sum(iQuantity) from TInvoiceLine where iProductId = @iProductId group by iProductId
    )
    where iProductId = @iProductId

end

