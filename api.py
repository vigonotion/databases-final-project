from collections import Counter


class Api:
    def __init__(self, cursor, session):
        self.cursor = cursor
        self.session = session

    def get_credit_cards_from_email(self, email):
        """returns a list of credit cards from a user given their email as parameter"""

        self.cursor.execute(
            """
            SELECT TCreditCard.iCardId, TCreditCard.cCreditCardNo FROM TUser
            INNER JOIN TCreditCard ON TUser.iUserId = TCreditCard.iUserId
            WHERE TUser.cEmail = ?
            """,
            email,
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
                SELECT * from TProduct
                WHERE iProductId = ?
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

    def create_invoice(self, user_id, products, card_id, vat):

        self.cursor.execute(
            """
            SET NOCOUNT ON

            DECLARE @i TABLE (
                iInvoiceId INT
            )

            INSERT INTO dbo.TInvoice(dDate, iVat, fTotalPrice, iUserId, iCardId)
            OUTPUT INSERTED.iInvoiceId INTO @i
            VALUES (CURRENT_TIMESTAMP, ?, ?, ?, ?)

            SELECT * FROM @i
            """,
            vat,
            0,
            user_id,
            card_id,
        )

        invoiceId = self.cursor.fetchone().iInvoiceId

        for product in products:
            self.cursor.execute(
                """
                INSERT INTO dbo.TInvoiceLine(iProductId, iInvoiceId, fPrice, iQuantity)
                VALUES (?, ?, ?, ?)

                """,
                product[0].iProductId,
                invoiceId,
                product[0].fUnitPrice,
                product[1],
            )

        self.cursor.commit()

        print("created invoice with id {}".format(invoiceId))
