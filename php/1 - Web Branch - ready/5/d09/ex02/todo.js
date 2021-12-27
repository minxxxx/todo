function putCookie(name, value, days)
{	
	var date = new Date();
	date.setTime(date.getTime()+(days*24*60*60*1000));
	document.cookie = name + "=" + value + "; expires="+ date.toGMTString() + "; path=/";
}

function delCookie(name){putCookie(name, 'deleted', -2);}

function padWithZero(num)
{
	var tutu = num + "";
	while (tutu.length < 5)
		tutu = "0" + tutu;
	return (tutu);
}

var i = 0;

function addADiv(input)
{	
	var div = document.createElement('div');
	var ft_list = document.getElementById('ft_list');

	div.setAttribute("name", 'todo' + padWithZero(i++));
	div.addEventListener("click", function(){if (confirm('Really?')){ft_list.removeChild(div);delCookie(div.getAttribute('name'));}}, false);
	div.innerHTML = input.replace('%3D', '=').replace('%3B', ';');
	putCookie(div.getAttribute('name'), input.replace('=', '%3D').replace(';', '%3B'), 7);
	ft_list.insertBefore(div, ft_list.firstChild);
}

function newTodo()
{
	var input = "";
	while (input == "" || input == null)
		input = prompt("Please enter the new todo");
	addADiv(input);
}

function getCookies()
{
	var arr_cookies = document.cookie.split(';');
	var arr = {};

	for (var x in arr_cookies)
	{
		var split_cookies = arr_cookies[x].split("=");

		if (split_cookies.length > 1 && /todo\d+/.test(split_cookies[0]))
			arr[split_cookies[0].trim()] = split_cookies[1].trim();		
	}
	return (arr);
}

var cookies = getCookies();
var sortedKeys = Object.keys(cookies).sort();

for (var x in sortedKeys)
{
	delCookie(sortedKeys[x]);
	addADiv(cookies[sortedKeys[x]]);
}
