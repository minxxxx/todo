const config = require('../config/config');
const customError = require('../modules/customError');
const request = require('request-promise');

const moduleUrl = '/album';

module.exports = {
	getTracksByAlbum: async (req, res, next) => {
		try {
			let options = {
				method: 'GET',
				uri: config.deezer.apiUrl  + moduleUrl + '/' + req.params.id,
				json: true
			};
			let album = await request(options)
			if (album.id) {
				return res.status(200).send(album)
			}
			throw new Error('No album found')
		} catch (err) {
			next(new customError(err.message, 400))
		}
	}
}