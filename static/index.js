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
        productId=$(this).val()
        console.log(productId)
        $.ajax({
            url: '/AddToCart',
            contentType: 'application/json',
            data: JSON.stringify(productId),
            dataType : 'text',
            type: 'POST',
            success: function(response) {
                alert("Product was added to your cart");
            },
            error: function(error) {
                alert("Oh no somthing went wrong! your product was not added");
            }
        });
    });
});   

