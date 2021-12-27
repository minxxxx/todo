'use strict'

const express = require('express');
const router = express.Router();
const eventController = require('../controllers/event');
const multer  = require('multer')
const upload = multer({ dest: "./public/eventPicture/"})
const passport = require('passport');
const middlewares = require('../modules/middlewares');

/**
 * @route GET /event/:id
 * @group event - Operations about event
 * @security - Bearer: []
 * @returns {object} 200 - Authorized events
 * @returns {Error} 400 - Bad request
 * @returns {Error}  default - Unexpected error
 */
router.get('/',
    passport.authenticate('bearer'),
    middlewares.isConfirmed,
    eventController.getEvents);

/**
 * @route GET /event/:id
 * @group event - Operations about event
 * @security - Bearer: []
 * @returns {object} 200 - event by id
 * @returns {Error} 400 - Bad request
 * @returns {Error}  default - Unexpected error
 */
router.get('/:id',
    passport.authenticate('bearer'),
    middlewares.isConfirmed,
    eventController.getEventById);

/**
 * @route PUT /event/:id
 * @group event - Operations about event
 * @security - Bearer: []
 * @param {string} creator.query.required - event creator
 * @param {string} title.query.required - event title
 * @param {string} description.query.required - event description
 * @param {string} location.query.required - event location
 * @param {file} picture.query - event picture
 * @returns {object} 200 - updated event
 * @returns {Error} 400 - Bad request
 * @returns {Error}  default - Unexpected error
 */
router.put('/:id',
    passport.authenticate('bearer'),
    middlewares.isConfirmed,
    eventController.putEventById);

/**
 * @route DELETE /event/:id
 * @group event - Operations about event
 * @security - Bearer: []
 * @returns {object} 204
 * @returns {Error} 400 - Bad request
 * @returns {Error}  default - Unexpected error
 */
router.delete('/:id',
    passport.authenticate('bearer'),
    middlewares.isConfirmed,
    eventController.deleteEventById);

/**
 * @route POST /event
 * @group event - Operations about event
 * @security - Bearer: []
 * @param {string} creator.query.required - event creator
 * @param {string} title.query.required - event title
 * @param {string} description.query.required - event description
 * @param {string} location.query.required - event location
 * @param {file} picture.query - event picture
 * @returns {object} 201 - created event
 * @returns {Error} 400 - Bad request
 * @returns {Error}  default - Unexpected error
 */
router.post('/',
    passport.authenticate('bearer'),
    middlewares.isConfirmed,
    upload.single('file'),
    eventController.postEvent);

module.exports = router;
