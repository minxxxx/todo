function addToResult(element) {
	var color = '';
	if (element.number == 1 || element.number == 7 || element.number == 8 || element.number == 9 || element.number == 17 || element.number == 35 || element.number == 53) {
		color = "green1";
	} else if (element.number == 6 || element.number == 15 || element.number == 16 || element.number == 17 || element.number == 35 || element.number == 53) {
		color = "green2";
	} else if (element.number >= 57 && element.number <= 71) {
		color = "pink1";
	} else if (element.number >= 89 && element.number <= 103) {
		color = "pink2";
	} else if (element.number == 3 || element.number == 11 || element.number == 19 || element.number == 37 || element.number == 55 || element.number == 87) {
		color = "red";
	} else if (element.number == 4 || element.number == 12 || element.number == 20 || element.number == 38 || element.number == 56 || element.number == 88) {
		color = "yellow";
	} else if (element.number == 2 || element.number == 10 || element.number == 18 || element.number == 36 || element.number == 54 || element.number == 86) {
		color = "blue";
	} else if ((element.number >= 21 && element.number <= 30) || (element.number >= 39 && element.number <= 48) || (element.number >= 72 && element.number <= 80) || (element.number >= 104 && element.number <= 108) || element.number == 112) {
		color = "pink3";
	} else if (element.number == 5 || element.number == 14 || element.number == 32 || element.number == 33 || element.number == 51 || element.number == 52 || element.number == 85) {
		color = "marron";
	}

	var result = "";
	result += "<td class='withborder "+ color +"'>";
	result += "<p class='weight'>"+ element.molar +"</p>";
	result += "<p class='symbol'>"+ element.small +"</p>";
	result += "<p class='number'>"+ element.number +"</p>";
	result += '</td>';
	return (result);
}

function printTable(table) {
	var result = "";

	table.table.forEach(function(line) {
		result += '<tr>';
		line.elements.forEach(function(element) {
			result += addToResult(element);
		});
		result += '</tr>';
	});
	result += '<tr>';
	table.lanthanoids.forEach(function(element) {
		result += addToResult(element);
	});
	result += '</tr>';

	result += '<tr>';
	table.actinoids.forEach(function(element) {
		result += addToResult(element);
	});
	result += '</tr>';


	console.log(result);
};
var xhr = new XMLHttpRequest();
xhr.onreadystatechange = function() {
	if (xhr.readyState === XMLHttpRequest.DONE) {
		if (xhr.status === 200) {
			printTable(JSON.parse(xhr.responseText));
		} else {
			console.log("error");
		}
	}
};
xhr.open("GET", "https://raw.githubusercontent.com/diniska/chemistry/master/PeriodicalTable/periodicTable.json", true);
xhr.send();
