var button = document.querySelector("button");
var ft_list = document.querySelector("#ft_list");

function getCookies() {
	var cooks = document.cookie.split(";");
	var res = [];
	cooks.forEach(function(cookie) {
		var c = cookie.split("=");
		if (c[1] == "OK") {
			res.push(decodeURIComponent(c[0]).trim());
		}
	});
	return res;
}

function createElement(text, parent) {
	text = text.trim();
	var newItem = document.createElement("div");
	newItem.className += "item";
	newItem.innerHTML = text;
	parent.insertBefore(newItem, parent.firstChild);
	document.cookie = encodeURIComponent(text) + "=OK";
}

var listCookies = getCookies();
for (i in listCookies) {
	createElement(listCookies[i], ft_list);
}

button.addEventListener("click", function() {
	var newItemText = prompt("New todo:");
	if (newItemText && newItemText.trim() && listCookies.indexOf(newItemText.trim()) == -1)
		createElement(newItemText, ft_list);
});

ft_list.addEventListener("click", function(e) {
	var clickedItem = e.target;
	if (clickedItem.className == "item") {
		if (confirm("Delete?")) {
			this.removeChild(clickedItem);
			document.cookie = encodeURIComponent(clickedItem.innerHTML) + "=";
		}
	}
});
