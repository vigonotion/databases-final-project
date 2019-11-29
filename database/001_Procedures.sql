-- calculates the average rating for a product based on all ratings.
create procedure SetAvgProductRating (@product_id INT) as
begin

    set nocount on
    update TProduct
    set average_rating = (
        select avg(rating) from TRating where product_id = @product_id group by product_id
    )
    where product_id = @product_id

end