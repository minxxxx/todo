 var mongoose = require('mongoose');
var Schema = mongoose.Schema;
 
const Track = new Schema({
	id: {
		type: Number,
		index: true
	},
	userId: {
		type: [Schema.Types.ObjectId],
		index: true
	},
	readable: {
		type: Boolean,
	},
	title: {
		type: String,
	},
	title_short: {
		type: String,
	},
	title_version: {
		type: String,
	},
	isrc: {
		type: String,
	},
	link: {
		type: String,
	},
	share: {
		type: String,
	},
	duration: {
		type: Number,
	},
	track_position: {
		type: Number,
	},
	disk_number: {
		type: Number,
	},
	rank: {
		type: Number,
	},
	release_date: {
		type: Date
	},
	explicit_lyrics: {
		type: String
	},
	preview: {
		type: String
	},
	bpm: {
		type: Number,
	},
	gain: {
		type: Number,
	},
	contributors: {
		type: Object,
	},
	artist: {
		type: Object,
	},
	album: {
		type: Object,
	},
	likes: [{
		type: Schema.Types.ObjectId,
		ref: 'user',
		index: true
	}],
	status: {type:Number, default: 0}
});

module.exports = mongoose.model('track', Track);