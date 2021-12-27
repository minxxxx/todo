const mongoose 		= require('mongoose');
const Schema 		= mongoose.Schema;
const Track 		= require('../models/track');

const Playlist = new Schema({
	idUser: {
		type: Schema.Types.ObjectId,
		ref: 'user',
		index: true
	},
	id: {type: Number},
	title: {type: String},
	description: {type: String},
	duration: {type: Number},
	public: {
		type: Boolean,
		default: true},
	is_loved_track: {type: Boolean},
	collaborative: {type: Boolean},
	nb_tracks: {type: Number},
	fans: {type: Number},
	link: {type: String},
	share: {type: String},
	picture: {type: String},
	picture_small: {type: String},
	picture_medium: {type: String},
	picture_big: {type: String},
	picture_xl: {type: String},
	checksum: {type: String},
	tracklist: {type: String},
	creation_date: {type: Date},
	creator: {
		id: {type: Number},
		name: {type: String},
		tracklist: {type: String},
		type: {type: String},
	},
	type: {type: String},
	tracks : {
		data: [
			Track.schema
		],
		checksum: {type: String}
	},
	members : [{
		type: Schema.Types.ObjectId,
		ref: 'user',
		index: true
	}]
});

module.exports = mongoose.model('playlist', Playlist);

