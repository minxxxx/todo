'use strict'

const express = require('express');
const router = express.Router();
const searchController = require('../controllers/search');
const passport = require('passport');
const middlewares = require('../modules/middlewares');


/**
 * @route GET /search
 * @group search - Operations about search
 * @security - Bearer: []
 * @returns {object} 200
 * @returns {Error} 400
 * @returns {Error}  default - Unexpected error
 */
router.get('/',
    passport.authenticate('bearer'),
    middlewares.isConfirmed,
    searchController.search);

/**
 * @route GET /search/track
 * @group search - Operations about search
 * @security - Bearer: []
 * @returns {object} 200 - tracks
 * @returns {Error} 400
 * @returns {Error}  default - Unexpected error
 */
router.get('/track',
    passport.authenticate('bearer'),
    middlewares.isConfirmed,
    searchController.searchTrack);

/**
 * @route GET /search/album
 * @group search - Operations about search
 * @security - Bearer: []
 * @returns {object} 200 - albums
 * @returns {Error} 400
 * @returns {Error}  default - Unexpected error
 */
router.get('/album',
    passport.authenticate('bearer'),
    middlewares.isConfirmed,
    searchController.searchAlbum);

/**
 * @route GET /search/playlist
 * @group search - Operations about search
 * @security - Bearer: []
 * @returns {object} 200 - playlists
 * @returns {Error} 400
 * @returns {Error}  default - Unexpected error
 */
router.get('/playlist',
    passport.authenticate('bearer'),
    middlewares.isConfirmed,
    searchController.searchPlaylist);

/**
 * @route GET /search/artist
 * @group search - Operations about search
 * @security - Bearer: []
 * @returns {object} 200 - artists
 * @returns {Error} 400
 * @returns {Error}  default - Unexpected error
 */
router.get('/artist',
    passport.authenticate('bearer'),
    middlewares.isConfirmed,
    searchController.searchArtist);

module.exports = router;
