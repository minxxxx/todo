'use strict'

const express = require('express');
const router = express.Router();
const albumController = require('../controllers/album');
const passport = require('passport');
const middlewares = require('../modules/middlewares');

/**
 * @route GET /album/:id
 * @group event - Operations about event
 * @security - Bearer: []
 * @returns {object} 200 - Deezer albums
 * @returns {Error} 400 - Bad request
 * @returns {Error}  default - Unexpected error
 */
router.get('/:id',
    passport.authenticate('bearer'),
    middlewares.isConfirmed,
    albumController.getTracksByAlbum);

module.exports = router;