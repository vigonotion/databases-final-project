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