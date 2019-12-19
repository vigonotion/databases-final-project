const content = document.querySelector("#content");
const search_box = document.querySelector("#search");

search_box.addEventListener('input', function(e) {
    let query = e.target.value;
    console.log("searching for: " + query);

    var r = new XMLHttpRequest();
    r.open("GET", "/search/" + query, true);
    r.onreadystatechange = function () {
        if (r.readyState != 4 || r.status != 200) return;
        content.innerHTML = r.responseText;
    };
    r.send();
});

document.querySelectorAll(".see-ratings").forEach(function(a) {

    a.addEventListener('click', function(e) {
        e.preventDefault();
        let product_id = e.target.getAttribute('data-product-id');
        
        let product_container = e.target.closest('.product');

        var r = new XMLHttpRequest();
        r.open("GET", "/api/products/" + product_id + "/ratings", true);
        r.onreadystatechange = function () {
            if (r.readyState != 4 || r.status != 200) return;

            product_container.insertAdjacentHTML('beforeend', r.responseText);
        };
        r.send();
    });
});

$(function() {
    $('[id^=BuyProduct]').click(function() {

        var amountField = $(this).closest(".field").find('input[name=amount]');

        var productId=$(this).val()
        var amount = amountField.val()

        productId=$(this).val()
        amount = $(this).closest(".field").find("input[name=amount]").val()
        console.log(productId)
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

