'use strict'

const express = require('express');
const router = express.Router();
// const strategies = require('../controllers/strategies')();
const passport = require('passport');
const middlewares = require('../modules/middlewares');
const playlistController = require('../controllers/playlist');

/**
 * @route GET /playlist
 * @group playlist - Operations about playlist
 * @security - Bearer: []
 * @returns {object} 200 - all deezer playlists and authorized playlist
 * @returns {Error} 400 - Bad request
 * @returns {Error}  default - Unexpected error
 */
router.get('/',
    passport.authenticate('bearer'),
    middlewares.isConfirmed,
    playlistController.getPlaylistsByUser);

/**
 * @route GET /playlist/:id
 * @group playlist - Operations about playlist
 * @security - Bearer: []
 * @returns {object} 200 - deezer playlists and authorized playlist by id
 * @returns {Error} 400 - Bad request
 * @returns {Error}  default - Unexpected error
 */
router.get('/:id',
    passport.authenticate('bearer'),
    middlewares.isConfirmed,
    playlistController.getPlaylistById);

/**
 * @route GET /playlist/me/:id
 * @group playlist - Operations about playlist
 * @security - Bearer: []
 * @returns {object} 200 - deezer playlists and authorized playlist by id
 * @returns {Error} 400 - Bad request
 * @returns {Error}  default - Unexpected error
 */
router.get('/me/:id',
    passport.authenticate('bearer'),
    middlewares.isConfirmed,
    playlistController.getPlaylistUserById);

/**
 * @route POST /playlist
 * @group playlist - Operations about playlist
 * @security - Bearer: []
 * @param {string} title.query.required - playlist's title
 * @param {array} members.query - array of user id
 * @returns {object} 201
 * @returns {Error} 400 - Bad request
 * @returns {Error}  default - Unexpected error
 */
router.post('/',
    passport.authenticate('bearer'),
    middlewares.isConfirmed,
    playlistController.postPlaylist);

/**
 * @route PUT /playlist/:id
 * @group playlist - Operations about playlist
 * @security - Bearer: []
 * @param {string} title.query - playlist's title
 * @param {array} members.query - array of user id
 * @returns {object} 200
 * @returns {Error} 400 - Bad request
 * @returns {Error}  default - Unexpected error
 */
router.put('/:id',
    passport.authenticate('bearer'),
    middlewares.isConfirmed,
    playlistController.putPlaylistById);

/**
 * @route PUT /playlist/:id/track
 * @group playlist - Operations about playlist
 * @security - Bearer: []
 * @param {string} id.query - track id
 * @returns {object} 200
 * @returns {Error} 400 - Bad request
 * @returns {Error}  default - Unexpected error
 */
router.put('/:id/track',
    passport.authenticate('bearer'),
    middlewares.isConfirmed,
    playlistController.addTrackToPlaylistById);

/**
 * @route DELETE /playlist/:id
 * @group playlist - Operations about playlist
 * @security - Bearer: []
 * @returns {object} 204
 * @returns {Error} 400 - Bad request
 * @returns {Error}  default - Unexpected error
 */
router.delete('/:id',
    passport.authenticate('bearer'),
    middlewares.isConfirmed,
    playlistController.deletePlaylistById);

/**
 * @route DELETE /playlist/:id/:trackId
 * @group playlist - Operations about playlist
 * @security - Bearer: []
 * @returns {object} 204
 * @returns {Error} 400 - Bad request
 * @returns {Error}  default - Unexpected error
 */
router.delete('/:id/:trackId',
    passport.authenticate('bearer'),
    middlewares.isConfirmed,
    playlistController.deleteTrackPlaylistById);

module.exports = router;

