'use strict';

const jwt = require('jsonwebtoken');
const config = require('../config/config.json');

class Crypto {
	static createToken(user) {
		let token = jwt.sign({
			id: user._id,
			status: user.status
		}, config.token.secret);
		// {
		// 	// expiresIn: expiresIn
		// });
		
		// token = Buffer.from(JSON.stringify({token: token}), 'utf8').toString('base64');
		return token;
	}
}
module.exports = Crypto;
