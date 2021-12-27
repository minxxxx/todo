'use strict'

const config = require('../config/config.json');
const express = require('express');
const router = express.Router();
const userController = require('../controllers/user');
const strategies = require('../controllers/strategies')();
const passport = require('passport');
const middlewares = require('../modules/middlewares');
const multer  = require('multer')
const upload = multer({ dest: "./public/userPicture/"})

/**
 * @route POST /user/login
 * @group user - Operations about user
 * @param {string} email.body.required - user's email
 * @param {string} password.body.required - user's password
 * @returns {object} 200 - user info and jwt token
 * @returns {Error} 401 - Unauthorized
 * @returns {Error}  default - Unexpected error
 */
router.post('/login',
    	passport.authenticate('local', {session: false}), userController.connect
    );

router.get('/login/facebook',
		passport.authenticate('facebook-token', { session: false } ), userController.connect
	);

router.get('/login/google',
		passport.authenticate('google-token', { session: false } ), userController.connect
	);


router.put('/login/deezer',
		passport.authenticate('bearer'),
		middlewares.isConfirmed,
		userController.bindDeezerToken
	);

router.delete('/login/deezer',
		passport.authenticate('bearer'),
		middlewares.isConfirmed,
		userController.deleteDeezerToken
	);

/**
 * @route GET /user
 * @group user - Operations about user
 * @security - Bearer: []
 * @returns {object} 200 - users info
 * @returns {Error} 401 - Unauthorized
 * @returns {Error}  default - Unexpected error
 */
router.get('/',
		passport.authenticate('bearer'),
		middlewares.isConfirmed,
		userController.getUsers
	);


/**
 * @route PUT /user/confirm
 * @group user - Operations about user
 * @security - Bearer: []
 * @returns {object} 200 - token
 * @returns {Error} 401 - Unauthorized
 * @returns {Error}  default - Unexpected error
 */
router.put('/confirm',
		passport.authenticate('bearer'),
		userController.confirmUser
	);

/**
 * @route POST /user/resendMail
 * @group user - Operations about user
 * @param {string} email.query.required - user's email
 * @returns {object} 202
 * @returns {Error} 401 - Unauthorized
 * @returns {Error}  default - Unexpected error
 */
router.post('/resendMail',
		userController.resendMail
	);

/**
 * @route POST /user/forgotPassword
 * @group user - Operations about user
 * @param {string} email.query.required - user's email
 * @returns {object} 200
 * @returns {Error} 400
 * @returns {Error}  default - Unexpected error
 */
router.post('/forgotPassword',
		userController.forgotPassword
	);

/**
 * @route GET /user/me
 * @group user - Operations about user
 * @security - Bearer: []
 * @returns {object} 200 - user info
 * @returns {Error} 401 - Unauthorized
 * @returns {Error}  default - Unexpected error
 */
router.get('/me',
		passport.authenticate('bearer'),
		middlewares.isConfirmed,
		userController.getMe
	);

/**
 * @route GET /user/me
 * @group user - Operations about user
 * @security - Bearer: []
 * @param {string} login.body - user login
 * @param {string} password.body - user password
 * @returns {object} 200
 * @returns {Error} 401 - Unauthorized
 * @returns {Error}  default - Unexpected error
 */
router.put('/me',
		passport.authenticate('bearer'),
		middlewares.isConfirmed,
		upload.single('file'),
		userController.modifyUserById
	);

/**
 * @route DELETE /user/me
 * @group user - Operations about user
 * @security - Bearer: []
 * @returns {object} 204
 * @returns {Error} 401 - Unauthorized
 * @returns {Error}  default - Unexpected error
 */
router.delete('/me',
		passport.authenticate('bearer'),
		middlewares.isConfirmed,
		userController.deleteUserById
	);

/**
 * @route GET /user/:id
 * @group user - Operations about user
 * @security - Bearer: []
 * @returns {object} 200 - user info
 * @returns {Error} 401 - Unauthorized
 * @returns {Error}  default - Unexpected error
 */
router.get('/:id',
		passport.authenticate('bearer'),
		middlewares.isConfirmed,
		userController.getUserById
	);

/**
 * @route POST /user
 * @group user - Operations about user
 * @param {string} email.body.required - user's email
 * @param {string} login.body.required - user's login
 * @param {string} password.body.required - user's password
 * @returns {object} 200 - confirmation token -> mail
 * @returns {Error} 401 - Unauthorized
 * @returns {Error}  default - Unexpected error
 */
router.post('/', upload.single('file'), userController.postUser);

module.exports = router;
