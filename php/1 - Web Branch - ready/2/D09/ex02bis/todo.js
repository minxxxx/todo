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

function createElement(text) {
	text = text.trim();
	$("#ft_list").prepend("<div class='item'>"+ text +"</div>");
	document.cookie = encodeURIComponent(text) + "=OK";
}

var listCookies = getCookies();
for (i in listCookies) {
	createElement(listCookies[i]);
}

$("button").click(function() {
	var newItemText = prompt("New todo:");
	if (newItemText && newItemText.trim() && listCookies.indexOf(newItemText.trim()) == -1)
		createElement(newItemText);
});

$("#ft_list").on("click", ".item", function(e) {
	if (confirm("Delete?")) {
		$(this).remove();
		document.cookie = encodeURIComponent($(this).text()) + "=";
	}
});
