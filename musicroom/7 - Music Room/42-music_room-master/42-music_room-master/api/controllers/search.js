const config = require('../config/config');
const customError = require('../modules/customError');
const playlistModel 	= require('../models/playlist');
const moduleUrl = '/search';
const request = require('request-promise');

module.exports = {
	search: async (req, res, next) => {
		try {
			if (Object.keys(req.query).length === 0 || req.query.q === "")
				res.status(200).send([])
			let options = {
				method: 'GET',
				uri: config.deezer.apiUrl + moduleUrl + '?q=' + encodeURIComponent(req.query.q),
				json: true
			};
			let search = await request(options)
			res.status(200).send(search.data)
		} catch (err) {
			next(new customError(err.message, 400))
		}
	},
	searchAlbum: async (req, res, next) => {
		try {
			if (Object.keys(req.query).length === 0 || req.query.q === "")
				res.status(200).send([])
			let options = {
				method: 'GET',
				uri: config.deezer.apiUrl + moduleUrl + '/album ' + '?q=' + encodeURIComponent(req.query.q),
				json: true
			};
			let album = await request(options)
			res.status(200).send(album.data)
		} catch (err) {
			next(new customError(err.message, 400))
		}
	},
	searchTrack: async (req, res, next) => {
		try {
			if (Object.keys(req.query).length === 0 || req.query.q === "")
				res.status(200).send([])
			let options = {
				method: 'GET',
				uri: config.deezer.apiUrl + moduleUrl + '/track ' + '?q=' + encodeURIComponent(req.query.q),
				json: true
			};
			let tracks = await request(options)
			res.status(200).send(tracks.data)
		} catch (err) {
			next(new customError(err.message, 400))
		}
	},
	searchPlaylist: async  (req, res, next) => {
		try {
			if (Object.keys(req.query).length === 0 || req.query.q === "")
				res.status(200).send([])
			let criteria = new RegExp(req.query.q || "", 'i')
			let allPlaylist = []
			if (req.query.all) {
				console.log("on search au bon endroit")
				allPlaylist = await playlistModel
				.find({
					"title" : {$regex: criteria},
					$or:[
						{'idUser': {$eq: req.user._id}},
						{'members': {$in: req.user._id}},
						{public: true}
					]}
				)
			} else {
				allPlaylist = await playlistModel
					.find({$and: [{
						idUser: {$ne: req.user._id},
						members: {$ne: req.user._id},
						public: true,
						"title" : {$regex: criteria}}
					]})
				}
			let options = {
				method: 'GET',
				uri: config.deezer.apiUrl  + moduleUrl + '/playlist?q=' + encodeURIComponent(req.query.q),
				json: true
			};
			playlist = await request(options)
			if (playlist.total > 0) {
				allPlaylist = allPlaylist.concat(playlist.data)
			}
			let ret = allPlaylist.map((elem) => {
				const {_id, id, title, ...other} = elem
				return {_id, id, title}
			})
			res.status(200).send(ret)
		} catch (err) {
			next(new customError(err.message, 400))
		}
	},
	searchArtist: async (req, res, next) => {
		try {
			if (Object.keys(req.query).length === 0 || req.query.q === "")
				res.status(200).send([])
			let options = {
				method: 'GET',
				uri: config.deezer.apiUrl + moduleUrl + '/artist ' + '?q=' + encodeURIComponent(req.query.q),
				json: true
			};
			let artist = await request(options)
			res.status(200).send(artist.data)
		} catch (err) {
			next(new customError(err.message, 400))
		}
	}
}
