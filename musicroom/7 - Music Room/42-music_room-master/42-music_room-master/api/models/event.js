const mongoose 	= require('mongoose');
const Schema 	= mongoose.Schema;
const User		= require('../models/user');
const Playlist 		= require('../models/playlist');

const Event = new Schema({
	creator: {
		type: Schema.Types.ObjectId,
		ref: 'user'
	},
	title:{type: String, default: "Aucun"},
	description:{type: String, default: "à définir"},
	location: {
		address : {
			p: {type: String},
			v: {type: String},
			cp: {type: String},
			r: {type: String},
			n: {type: String}
		},
		coord: {
			lat: {type: Number, required: true},
			lng: {type: Number, required: true}
		}
	},
	public: {type: Boolean, default: false},
	distance_max: {type:Number, default: 2},
	distance_required: {type: Boolean, default: false},
	is_start:  {type: Boolean, default: false},
	is_finish:  {type: Boolean, default: false},
	is_play: {type: Boolean, default: true},
	creation_date: {type: Date, default: Date.now},
	event_date: {type: Date, default: Date.now},
	playlist: {type: Playlist.schema},
	isPlaying: {
		type: Schema.Types.ObjectId
	},
	currentTrack:{
		type: Schema.Types.ObjectId
	},
	members : [{
		type: Schema.Types.ObjectId,
		ref: 'user'
	}],
	adminMembers: [{
		type: Schema.Types.ObjectId,
		ref: 'user'
	}],
	picture: {type: String, default: "default.jpeg"}

}, { versionKey: false });

module.exports = mongoose.model('event', Event);
