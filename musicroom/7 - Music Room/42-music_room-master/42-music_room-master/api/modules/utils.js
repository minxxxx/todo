'use strict';

class Utils {
	static filter(model, obj, visibility = 0) {
		if (!obj) return null;
		for (const field in model) {
			if (model[field].visibility && model[field].visibility > visibility) {
				obj[field] = undefined
			} else if (obj[field]) {
				obj[field] = this.sanitize(obj[field]);
			}
		}
		return obj;
	}

	static normalize(input) {
		if (typeof input !== 'string') {
			return input;
		}
		return input.toLowerCase().trim();
	}

	static sanitize(input) {
		if (typeof input !== 'string') {
			return input;
		}
		const rules = [
			new RegExp('w*((%27)|(\'))((%6F)|o|(%4F))((%72)|r|(%52))', 'i'),
			new RegExp('(%27)|(\')|(--)|(%23)|(#)', 'i'),
			new RegExp('((%3D)|(=))[^\n]*((%27)|(\')|(--)|(%3B)|(;))', 'i'),
			new RegExp('((%27)|(\'))union', 'i'),
			new RegExp('((%3C)|<)((%2F)|/)*[a-z0-9%]+((%3E)|>)', 'i'),
			new RegExp('((%3C)|<)((%69)|i|(%49))((%6D)|m|(%4D))((%67)|g|(%47))[^\n]+((%3E)|>)', 'i')
		];
		rules.forEach(rule => {
			input = input.replace(rule, '');
		});
		return input;
	}
	static randPassowrd() {
		let chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz!@#$%^&*()_-/?<>[]{}";
		let string_length = randomIntFromInterval(8, 20);
		let randomstring = '';
		for (var i = 0; i < string_length; i++) {
			let rnum = Math.floor(Math.random() * chars.length);
			randomstring += chars.substring(rnum, rnum + 1);
		}
		return (randomstring)
	}
}

function randomIntFromInterval(min, max)
{
	return Math.floor(Math.random()*(max-min+1)+min);
}

module.exports = Utils;
