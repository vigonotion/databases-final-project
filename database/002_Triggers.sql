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
