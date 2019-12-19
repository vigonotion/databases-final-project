const content = document.querySelector("#content");
const search_box = document.querySelector("#search");

search_box.addEventListener('input', function(e) {
    let query = e.target.value;
    console.log("searching for: " + query);

    var r = new XMLHttpRequest();
    r.open("GET", "/search/" + query, true);
    r.onreadystatechange = function() {
        if (r.readyState != 4 || r.status != 200) return;
        content.innerHTML = r.responseText;
    };
    r.send();
});

document.querySelectorAll(".see-ratings").forEach(function(a) {

    a.addEventListener('click', function(e) {
        e.preventDefault();
        let product_id = e.target.getAttribute('data-product-id');

        let rating_container = $(e.target).closest('.product').find(".ratings");

        var r = new XMLHttpRequest();
        r.open("GET", "/api/products/" + product_id + "/ratings", true);
        r.onreadystatechange = function() {
            if (r.readyState != 4 || r.status != 200) return;

            $(rating_container).html(r.responseText);
        };
        r.send();
    });
});

$(function() {
    $('[id^=BuyProduct]').click(function() {

        var amountField = $(this).closest(".field").find('input[name=amount]');

        var productId = $(this).val();
        var amount = amountField.val();

        $.ajax({
            url: '/api/cart',
            contentType: 'application/json',
            data: JSON.stringify({
                productId: productId,
                amount: amount
            }),
            dataType : 'text',
            type: 'POST',
            success: function(response) {
                alert("Product was added to your cart");

                amountField.val(1);
            },
            error: function(error) {
                alert("Oh no somthing went wrong! your product was not added");
            }
        });
    });
});

// cart

$(function() {
    $('[id^=DeleteProduct]').click(function() {
        productId = $(this).val()
        $.ajax({
            url: '/api/cart',
            contentType: 'application/json',
            data: JSON.stringify(productId),
            dataType: 'text',
            type: 'DELETE',
            success: function(response) {
                var $quantityElement = $("#quantity" + productId)
                var oldQuantityText = $quantityElement.text();
                var QuantitytextVal = parseInt($quantityElement.text());

                var $amountElement = $("#amount" + productId)
                var oldamountText = $amountElement.text();
                var amounttextVal = parseInt($amountElement.text());

                var onesPrice = amounttextVal / QuantitytextVal

                if (QuantitytextVal != 1) {
                    QuantitytextVal = QuantitytextVal - 1
                    $quantityElement.text(oldQuantityText.replace(oldQuantityText, QuantitytextVal + ""))
                } else {
                    $("#DeleteDivProduct" + productId).remove()
                }

                amounttextVal = onesPrice * QuantitytextVal
                $amountElement.text(oldamountText.replace(oldamountText, amounttextVal + ".00 kr."))

                var $totalElement = $("#total")
                var oldtotalText = $totalElement.text();
                var totaltextVal = parseInt($totalElement.text());
                totaltextVal = totaltextVal - onesPrice
                $totalElement.text(oldtotalText.replace(oldtotalText, totaltextVal + ".00 kr."))


            },
            error: function(error) {
                alert("Oh no somthing went wrong! ur product was not deleted");
            }
        });
    });
});