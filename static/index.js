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