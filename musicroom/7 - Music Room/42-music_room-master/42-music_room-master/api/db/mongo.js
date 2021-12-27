const mongoose = require('mongoose');
const mongoDB = 'mongodb://mongo/music_room';

mongoose.connect(mongoDB, {
	useNewUrlParser: true,
	useCreateIndex: true
});

mongoose.Promise = global.Promise;

const db = mongoose.connection;

var User = require('../models/user'),
    Event   = require('../models/event'),
    Playlist   = require('../models/playlist'),
    Tracks   = require('../models/track'),
    Schema = mongoose.Schema;

db.on('error', console.error.bind(console, 'MongoDB connection error:'));

