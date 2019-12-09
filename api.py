from collections import Counter


class Api:
    def __init__(self, cursor, session):
        self.cursor = cursor
        self.session = session

    def get_credit_cards_from_email(self, email):
        """returns a list of credit cards from a user given their email as parameter"""

        self.cursor.execute(
            """
            select iUserId from TUser
            where cEmail = ?
            """,
            email,
        )
        UserId = self.cursor.fetchone()[0]
        self.cursor.execute(
            """
            select cCreditCardNo from TCreditCard
            where iUserId = ?
            """,
            UserId,
        )
        usersCreditCards = self.cursor.fetchall()
        return usersCreditCards

    def get_unique_products(self):
        """returns a list containing uniqe products and the amount of those objects and the total price of all the objects"""
        tempCart = self.session["cartProduct"]
        counter = Counter(tempCart)
        checkoutItems = []
        for product_id in counter:
            self.cursor.execute(
                """
                select * from TProduct
                where iProductId = ?
            """,
                product_id,
            )
            product = self.cursor.fetchone()
            # pos 1 product object            | list[x][0]
            # pos 2 amount of products        | list[x][1]
            # pos 3 total price (pos1*pos2)   | list[x][2]
            checkoutItems.append(
                [
                    product,
                    counter[product_id],
                    (counter[product_id] * product.fUnitPrice),
                ]
            )
        return checkoutItems
