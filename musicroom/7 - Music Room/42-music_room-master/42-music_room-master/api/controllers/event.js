'use strict'

const modelEvent = require('../models/event');
const modelPlaylist = require('../models/playlist');
const ObjectId = require('mongodb').ObjectID;
const customError = require('../modules/customError');
const playlistController = require('./playlist');

module.exports = {
	getEvents: async (req, res, next) => {
		try {
			let events = await modelEvent.find()
				.populate('creator')
				.populate('members')
				.populate('adminMembers')

			let retEvents = events.reduce((acc, elem) => {
				if (elem.creator._id.toString() === req.user._id.toString())
					acc['myEvents'].push(elem)
				else if (elem.members.filter((e) => e._id.toString() === req.user._id.toString()).length > 0)
					acc['friendEvents'].push(elem)
				else if (elem.adminMembers.filter((e) => e._id.toString() === req.user._id.toString()).length > 0)
					acc['friendEvents'].push(elem)
				else if (elem.public === true)
					acc['allEvents'].push(elem)
				return acc
			}, {myEvents: [], friendEvents: [], allEvents: []})

			res.status(200).json(retEvents);
		} catch (err) {
			console.log("Error getEvents: " + err)
			next(new customError(err.message, 400))
		}
	},
	getEventById: async (req, res, next) => {
		try {
			let event = await modelEvent
				.findOne(
					{_id: req.params.id,
						$or:
							[
								{'creator': 
									{$eq: req.user._id}
								},
								{'adminMembers': 
									{$in: req.user._id}
								},
								{'members': 
									{$in: req.user._id}
								},
								{
									public: true
								}
							]
					})
					.populate('creator')
					.populate('members')
					.populate('adminMembers')
			res.status(200).json(event || {})
		} catch (err) {
			next(new customError(err.message, 400))
		}
	},
	postEvent: async (req, res, next) => {
		try {
			req.body = JSON.parse(req.body.body);
			console.log("post event");
			console.log(req.body);
			if (!req.body.creator)
				throw new Error('No creator')
			if (!req.body.title)
				throw new Error('No title')
			if (!req.body.description)
				throw new Error('No description')
			if (!req.body.location)
				throw new Error('No Location')
			if (!req.body.playlist)
				throw new Error('No playlist')
			if (req.file && req.file.filename)
				req.body.picture = req.file.filename
			if (!req.body.playlist._id) {
				req.body.playlist = await playlistController.getPlaylistDeezerById(req.body.playlist.id, req.user.deezerToken)
			} else {
				req.body.playlist = await modelPlaylist.findOne({_id: req.body.playlist._id})
				delete req.body.playlist._id
				req.body.playlist.members = []
			}
			if (!req.body.playlist || !req.body.playlist.tracks || req.body.playlist.tracks.data.length === 0)
				throw new Error('No tracks in playlist')
			let event = await modelEvent.create(req.body)
			event = await modelEvent.findOneAndUpdate({_id : event._id}, {currentTrack: event.playlist.tracks.data[0]._id}, {new: true})
			res.status(200).send(event)
		} catch (err) {
			console.log("ERROR POST EVENT -> " + err)
			next(new customError(err.message, 400))
		}
	},
	putEventById: async (req, res, next) => {
		try {
			console.log(req.body)
			if (!req.body.creator)
				throw new Error('No creator')
			if (!req.body.title)
				throw new Error('No title')
			if (!req.body.location)
				throw new Error('No location')
			if (!req.body.description)
				throw new Error('No description')
			if (!req.body.playlist)
				throw new Error('No playlist')
			if (!req.body.playlist._id) {
				req.body.playlist = await playlistController.getPlaylistDeezerById(req.body.playlist.id, req.user.deezerToken)
			} else {
				req.body.playlist = await modelPlaylist.findOne({_id: req.body.playlist._id})
				delete req.body.playlist._id
				req.body.playlist.members = []
			}
			if (!req.body.playlist || !req.body.playlist.tracks || req.body.playlist.tracks.data.length === 0)
				throw new Error('No tracks in playlist')
			let user = await modelEvent
				.findOne(
					{_id: req.params.id,
						$or:
							[
								{'creator': 
									{$eq: req.user._id}
								},
								{'adminMembers': 
									{$in: req.user._id}
								}
							]
					})
			if (!user)
				return next(new customError('You are not authorize to modify this event', 401))
			let test = await modelEvent.updateOne({_id: req.params.id}, req.body, {new: true})
			res.status(200).json(test)
		} catch (err) {
			next(new customError(err.message, 400))
		}
	},
	deleteEventById: async (req, res, next) => {
		try {
			let del = await modelEvent
				.deleteOne(
					{_id: req.params.id,
						$or:
							[
								{'creator':
									{$eq: req.user._id}
								},
								{'adminMembers':
									{$in: req.user._id}
								}
							]
					})
			if (del.n === 0)
				throw new Error('you are not authorize to del this event')
			res.status(204).send();
		} catch (err) {
			console.log(err)
			next(new customError(err.message, 400))
		}
	},
	deleteEventsUser: async (userId) => {
		try {
			await modelEvent.deleteMany({creator: userId})
			await modelEvent.updateMany({$or:
				[
					{'members':
						{$in: userId}
					},
					{'adminMembers':
						{$in: userId}
					}
				]},
				{$pull: {adminMembers: userId, members: userId}},
				{ multi: true }
			)
		} catch (err) {
			throw err
		}
	}
};
