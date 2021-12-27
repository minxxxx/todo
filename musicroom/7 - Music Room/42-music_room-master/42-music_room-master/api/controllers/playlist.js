const playlistModel 	= require('../models/playlist');
const config 			= require('../config/config');
const request 			= require('request-promise');
const customError = require('../modules/customError');

let self = module.exports = { 
	getPlaylistsByUser: async (req, res, next) => {
		try {
			let localPlaylists = await playlistModel.find().populate('members')
			let retPlaylist = localPlaylists.reduce((acc, elem) => {
				if (elem.idUser.toString() === req.user._id.toString())
					acc['myPlaylists'].push(elem)
				else if (elem.members.filter((e) => e._id.toString() === req.user._id.toString()).length > 0)
					acc['friendPlaylists'].push(elem)
				else if (elem.public === true)
					acc['allPlaylists'].push(elem)
				return acc
			}, {myPlaylists: [], friendPlaylists: [], allPlaylists: []})

			let options = {
				method: 'GET',
				uri: config.deezer.apiUrl + '/user/me/playlists',
				qs: {
					"access_token": req.user.deezerToken
				},
				json: true
			};
			let deezerPlaylists = await request(options)
			if (deezerPlaylists.data)
				retPlaylist.myPlaylists = [...retPlaylist.myPlaylists, ...deezerPlaylists.data]
			res.status(200).json(retPlaylist)
		} catch (err) {
			next(new customError(err.message, 400))
		}
	},
	getPlaylistById: async (req, res, next) => {
		try {
			let playlist = {}
			if (!Number(req.params.id))
				playlist = await playlistModel
					.findOne({'_id': req.params.id,
						$or:
						[
							{'idUser':
								{$eq: req.user._id}
							},
							{'members':
								{$in: req.user._id}
							},
							{
								public: true
							}
						]
					}).populate('members')
			else
				playlist = await self.getPlaylistDeezerById(req.params.id, req.user.deezerToken)
			res.status(200).json(playlist);
		} catch (err) {
			console.log("Bad Request getPlaylistUserById" + err)
			next(new customError(err.message, 400));
		}
	},
	getPlaylistUserById: async (req, res, next) => {
		try {
			let playlist = {}
			if (!Number(req.params.id)) {
				playlist = await playlistModel.findOne(
					{_id: req.params.id,
						$or:
							[
								{'idUser':
									{$eq: req.user._id}
								},
								{'members':
									{$in: req.user._id}
								},
								{
									public: true
								}
							]
					})
				if (!playlist)
					throw new Error('Id playlist error (bad id or private playlist)')
			} else {
				let options = {
					method: 'GET',
					uri: config.deezer.apiUrl + '/playlist/' + req.params.id,
					json: true
				};
				playlist = await request(options)
				if (playlist.id && playlist.creator.id == req.user.deezerId) {
					return res.status(200).json(playlist);
				}
				playlist = {}
			}
			res.status(200).json(playlist);
		} catch (err) {
			console.log("Bad Request getPlaylistUserById" + err)
			next(new customError(err.message, 400))
		}
	},
	postPlaylist: async (req, res, next) => {
		try {
			let playlist = {}
			if (req.body.id) {
				if (!Number(req.body.id)) {
					console.log("COUCOU")
					playlist = await playlistModel
						.findOneAndUpdate({$and: [{
							_id: req.body.id,
							idUser: {$ne: req.user._id},
							members: {$ne: req.user._id},
							public: true}]},
							{$push: {members: req.user._id}},
							{new: true}
						)
				} else {
				req.body = await self.getPlaylistDeezerById(req.body.id, req.user.deezerToken)
				req.body.idUser = req.user._id
				if (req.body.id)
					playlist = await playlistModel.create(req.body);
				else
					throw new Error('Deezer playlist not exist')
				}
			}
			else {
				req.body.idUser = req.user._id
				if (!req.body.title)
					throw new Error('No title')
				if (!req.body.creator)
				{
					req.body.creator = {
						id: req.user.deezerId,
						name: req.user.login,
						tracklist: req.user.deezerId ? config.deezer.apiUrl + '/user/' + req.user.deezerId + '/flow' : undefined,
						type: 'user'
					}
				}
				playlist = await playlistModel.create(req.body);
			}
			res.status(201).json(playlist);
		} catch (err) {
			console.log(err)
			next(new customError(err.message, 400))
		}
	},
	putPlaylistById: async (req, res, next) => {
		try {
			let playlist = await playlistModel
				.findOneAndUpdate(
					{_id: req.params.id,
					$or:
						[
							{'idUser':
								{$eq: req.user._id}
							},
							{'members':
								{$in: req.user._id}
							},
							{
								public: true
							}
						]
					},
					req.body,
					{new: true}
				).populate('members')
			if (!playlist)
				throw new Error('You can not modify this playlist')
			res.status(200).json(playlist);
		} catch (err) {
			console.log("Bad Request putPlaylistById" + err)
			next(new customError(err.message, 400))
		}
	},
	addTrackToPlaylistById: async (req, res, next) => {
		try {
			if (!Number(req.params.id)) {
				let options = {
					method: 'GET',
					uri: config.deezer.apiUrl + '/track/' + req.body.id,
					json: true
				};
				let track = await request(options)
				if (!track.id)
					throw Error('No track found')
				if (!await playlistModel.findOne({
					_id: req.params.id,
					$or:
						[
							{'idUser':
								{$eq: req.user._id}
							},
							{'members':
								{$in: req.user._id}
							},
							{
								public: true
							}
						],
					'tracks.data': {$elemMatch: {id: track.id}}})) {
						let playlist = await playlistModel.updateOne({
							_id: req.params.id,
							$or:
								[
									{'idUser':
										{$eq: req.user._id}
									},
									{'members':
										{$in: req.user._id}
									},
									{
										public: true
									}
								]
							},
							{$push: {'tracks.data': track}}
						)
						if (playlist.n === 0)
							throw Error('You can not modify this playlist')
				} else {
					throw Error('This song already exists in this playlist')
				}
			}
			else {
				let options = {
					method: 'POST',
					uri: config.deezer.apiUrl + '/playlist/' + req.params.id + '/tracks',
					json: true,
					qs: {
						"access_token": req.user.deezerToken,
						"songs": req.body.id
					}
				};
				playlist = await request(options)
				if (playlist !== true)
					throw playlist.error.message
			}
			res.status(200).send({message: 'Track added'});
		} catch (err) {
			console.log("Bad Request addTrackToPlaylistById" + err)
			next(new customError(err.message, 400))
		}
	},
	deletePlaylistById: async (req, res, next) => {
		try {
			await playlistModel.deleteOne({_id: req.params.id, idUser: req.user._id})
			res.status(204).json({message: 'PLaylist deleted'});
		} catch (err) {
			console.log("Bad Request deletePlaylistById" + err)
			next(new customError(err.message, 400))
		}
	},
	deleteTrackPlaylistById: async (req, res, next) => {
		try {
			if (!Number(req.params.id)) {
				await playlistModel.updateOne({_id: req.params.id, 
					$or:
					[
						{'idUser':
							{$eq: req.user._id}
						},
						{'members':
							{$in: req.user._id}
						},
						{
							public: true
						}
					]
				},
					{$pull: {'tracks.data': {id: req.params.trackId}}}
				)
			} else {
				let options = {
					method: 'DELETE',
					uri: config.deezer.apiUrl + '/playlist/' + req.params.id + '/tracks',
					json: true,
					qs: {
						"access_token": req.user.deezerToken,
						"songs": req.params.trackId
					}
				};
				playlist = await request(options)
				if (playlist !== true)
					throw playlist.error.message
			}
			res.status(204).json({message: 'Track deleted'});
		} catch (err) {
			console.log("Bad Request deletePlaylistById" + err)
			next(new customError(err.message, 400))
		}
	},

	getPlaylistDeezerById: async (id, token) => {
		try {
			let options = {
				method: 'GET',
				uri: config.deezer.apiUrl + '/playlist/' + id,
				json: true
			};
			if (token)
				options.qs = {"access_token": token};
			let playlist = await request(options)
			if (playlist.id) {
				return playlist;
			}
			return {}
		} catch (err) {
			throw err
		}
	},
	deletePlaylistsUser: async (idUser) => {
		try {
			await playlistModel.deleteMany({idUser})
			await playlistModel.updateMany(
					{'members':
						{$in: idUser}
					},
				{$pull: {members: idUser}},
				{ multi: true }
			)
		} catch (err) {
			throw err
		}
	}
};
