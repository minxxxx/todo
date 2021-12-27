'use strict'

const model = require('../models/user');
const Crypto = require('../modules/crypto');
const Utils = require('../modules/utils');
const customError = require('../modules/customError');
const Joi 	= require('joi');
const config = require('../config/config.json');
const argon = require('argon2');
const mail = require('../modules/mail');
const event = require('./event');
const playlist = require('./playlist');

exports.connect = (req, res) => {
		return res.status(200).json({
			'token': Crypto.createToken(req.user),
			'user': Utils.filter(model.schema.obj, req.user, 0)
		});
    }

exports.bindDeezerToken = async (req, res, next) => {
	try {
		let user = await model.findOneAndUpdate(
			{_id: req.user._id}, 
			{deezerToken: req.query.deezerToken}, 
			{new: true}
		)
		res.status(200).send(user);
	} catch (err) {
		console.log("bindDeezerToken " + err)
		next(new customError(err.message, 400))
	}
}

exports.deleteDeezerToken = async (req, res, next) => {
	try {
		let user = await model.findOneAndUpdate(
			{_id: req.user._id}, 
			{deezerToken: null}, 
			{new: true}
		)
		res.status(200).send(user);
	} catch (err) {
		console.log("bindDeezerToken " + err)
		next(new customError(err.message, 400))
	}
}

exports.getUsers = async (req, res, next) => {
	try {
		console.info("getUser: getting all users ...");
		let criteria = new RegExp(req.query.criteria || "", 'i')
		let users = await model.find({_id: {$ne: req.user._id}, login: {$regex: criteria}})
		users = users.map((user) => {
			const {login, _id, picture, ...other} = user
			return {login, _id, picture}
		})
		res.status(200).send(users);
	} catch (err) {
		console.error("Error getUsers : %s", err);
		next(new customError(err.message, 400))
	}
}

exports.postUser = async (req, res, next) => {
	try {
		if (req.body.body)
			req.body = JSON.parse(req.body.body)
		console.log("BODY : ", req.body)
		const { error } = validateUser(req.body);
		if (req.file && req.file.filename) {
			req.body.picture = req.file.filename
		}
		if (error) {
			console.error('Error postUser : ', error.details[0].message);
			throw new Error('Bad request ' + error.details[0].message)
		}
		console.info("PostUser: creating user ", req.body.login);
		let user = req.body
		user = Utils.filter(model.schema.obj, user, 1)
		user.email = Utils.normalize(user.email)
		user.password = await argon.hash(user.password);
		user = await model.create(user);
		mail.sendMail("[MusicRoom] Confirm mail", "<a href='" + config.front_url + "/user/confirm/" + Crypto.createToken(user) + "'>click on this link to confirm</a>", user.email)
		res.status(201).send();
	} catch (err) {
		console.error("Error postUser : " + err.toString());
		if (err.code == 11000)
			next(new customError("Email already used", 400))
		next(new customError(err.message, 400))
	}
}

exports.getMe = async (req, res, next) => {
	try {
		res.status(200).send(Utils.filter(model.schema.obj, await model.findOne({"_id": req.user._id}), 0));
	} catch (err) {
		console.error("Error getUserById: %s", err);
		next(new customError(err.message, 400))
	}

}

exports.getUserById = async (req, res, next) => {
	try {
		const { error } = validateId(req.params);
		if (error) {
			console.error('Error getUserById : %s.', error.details[0].message);
			throw new Error('Invalid id');
		}
		console.info("getUserById: search _id -> %s", req.params.id);
		let user = await model.findOne({"_id": req.params.id})
		res.status(200).send(Utils.filter(model.schema.obj, user, 0));
	} catch (err) {
		console.error("Error getUserById: %s", err);
		next(new customError(err.message, 400))
	}

}

exports.deleteUserById = async (req, res, next) => {
	try {
		console.info("deleteUserById : delete _id -> %s", req.user._id);
		await playlist.deletePlaylistsUser(req.user._id)
		await event.deleteEventsUser(req.user._id)
		await model.deleteOne({"_id": req.user._id})
		res.status(204).send();
	} catch (err) {
		console.error("Error deleteUserById: %s", err);
		next(new customError(err.message, 400))
	}
}

exports.modifyUserById = async (req, res, next) => {
	try {
		if (req.body.body)
			req.body = JSON.parse(req.body.body);
		console.log(req.body)
		if (!req.body)
			return res.status(204);
		if (req.file && req.file.filename)
			req.body.picture = req.file.filename
		let userUpdate = {}
		let user = req.body
		if (user.password) {
			if (user.password.length < 8 || user.password.length > 30)
				throw new Error('Password does not fit (length between 8 and 30)')
			user.password = await argon.hash(user.password);
			userUpdate.password = user.password
		} else {
			delete userUpdate.password
		}
		const {error} = Joi.validate(user, {login: Joi.string().min(3).max(50), password: Joi.string(), picture: Joi.string()})
		if (error) {
			throw new Error(error.details[0].message)
		}
		user = Utils.filter(model.schema.obj, user, 1)
		if (user.login)
			userUpdate.login = user.login
		if (user.picture)
			userUpdate.picture = user.picture
		user = await model.findOneAndUpdate({"_id": req.user._id}, userUpdate, {new: true});
		return res.status(200).send(Utils.filter(model.schema.obj, user, 0));
	} catch (err) {
		console.error("Error modifyUserById: %s", err);
		next(new customError(err.message, 400))
	}
}

exports.confirmUser = async (req, res, next) => {
	try {
		if (req.user.status == 'Created')
		{
			await model.updateOne({_id: req.user._id}, {status: 'Active'});
			return res.status(200).send({'token': Crypto.createToken(await model.findOne({_id: req.user._id}))});
		}
		throw new Error('Bad token');
	} catch (err) {
		console.error("Error confirm user: %s", err);
		if (err.message === 'Bad token')
			next(new customError(err.message, 401))
		else
			next(new customError(err.message, 400))
	}		
}

exports.resendMail = async (req, res, next) => {
	try {
		let user = await model.findOne({email: req.body.email, status: 'Created'})
		if (user) {
			let token =  Crypto.createToken(user);
			// RESEND MAIL FrontUrl/token
			mail.sendMail("[MusicRoom] Confirm mail", "<a href='" + config.front_url + "/user/confirm/" + token + "'>click on this link to confirm</a>", user.email)
			// TO DEL WHEN MAIL OK
			// return res.status(200).send({token});
		}
		res.status(202).send({message: "Mail send (if account exist and not already validate)"})
	} catch (err) {
		console.error("Error resend mail: %s", err);
		next(new customError(err.message, 400))
	}		
}

exports.forgotPassword = async (req, res, next) => {
	try {
		let newPass = Utils.randPassowrd()
		console.log(newPass)
		let user = await model.findOneAndUpdate({email: req.body.email, status: 'Active'}, {password: await argon.hash(newPass)}, {new: true})
		if (user) {
			console.log(user)
			mail.sendMail("[MusicRoom] New password", "<p>Your new password is " + newPass + "</p>", user.email)
		}
		res.status(200).send({message: "Mail send (if account exist and already validate)"})
	} catch (err) {
		console.error("Error forgot password mail: %s", err);
		next(new customError(err.message, 400))
	}
}

function validateId(id)
{
	const schema = {
		id: Joi.string().length(24).alphanum().required()
	};

	return Joi.validate(id, schema);
}
function validateUser(user) {

	const schema = {
		login: Joi.string().min(3).max(50).required(),
		email: Joi.string().email({ minDomainAtoms: 2 }).required(),
		password: Joi.string().min(8).max(30).required(),
		picture: Joi.string()
	};
	return Joi.validate(user, schema);
}
