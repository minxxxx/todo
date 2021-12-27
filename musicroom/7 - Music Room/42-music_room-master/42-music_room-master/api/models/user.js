var mongoose = require('mongoose');
var Schema = mongoose.Schema;
 
const User = new Schema({
	facebookId: {
		type: String
	},
	facebookToken: {
		type: String
	},
	googleId: {
		type: String
	},
	googleToken: {
		type: String
	},
	deezerToken: {
		type: String
	},
	deezerRefreshToken: {
		type: String
	},
	deezerId: {
		type: String
	},
	login:{
		type: String
	},
	password:{
		type: String,
		visibility: 1
	},
	status:{
		type: String,
		enum: ['Active', 'Suspended', 'Created'],
		default: 'Created'
	},
	picture:{
		type: String
	},
	email:{
		type: String,
		unique:true,
		allowNull: false,
		required: true,
		index: true
	},
	creationDate: {
		type: Date,
		default: Date()
	},
	picture: {type: String, default: "default.jpeg"}
}, { versionKey: false });

module.exports = mongoose.model('user', User);