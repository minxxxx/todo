const passport = require('passport');
const FacebookStrategy = require('passport-facebook-token');
const GoogleTokenStrategy = require('passport-google-token').Strategy;
const LocalStrategy = require('passport-local').Strategy;
const BearerStrategy = require('passport-bearer-strategy').Strategy;
const config = require('../config/config.json');
const Crypto = require('../modules/crypto');
const modelUser = require('../models/user');
const argon = require('argon2');
const jwt = require('jsonwebtoken');
const customError = require('../modules/customError');

module.exports = function () {

	passport.use(new FacebookStrategy({
		clientID: config.facebook.clientID,
		clientSecret: config.facebook.clientSecret
	},
	function(accessToken, refreshToken, profile, done) {
		if (!profile.emails[0] || !profile.emails[0].value)
			return done(null, false);
		modelUser.findOne({
			'email': profile.emails[0].value
		}, function(err, user) {
			if (err) {
				console.log(err);
				return done(null, false);
			}
			if (!user) {
				user = new modelUser({
					facebookId: profile.id,
					facebookToken: accessToken,
					email: profile.emails[0].value,
					login: !profile.username ? profile.displayName : profile.username,
					picture: profile.photos.length > 0 ? profile.photos[0].value : undefined,
					status: 'Active'
				});
				modelUser.create(user, function(err) {
					if (err) {
						console.log(err);
						return done(null, false);
					}
					return done(null, user);
				});
			} else {
				if (!user.facebookId || !user.facebookToken)
				{
					modelUser.updateOne({_id: user._id}, {
						facebookId: profile.id,
						facebookToken: accessToken,
						status: 'Active'
					}, function(err, user) {
						if (err) {
							console.log(err);
							return done(null, false);
						}
						return done(null, user);
					});
				}
				return done(null, user);
			}
		});
	}));

	passport.use(new GoogleTokenStrategy({
		clientID: config.google.clientID,
		clientSecret: config.google.clientSecret
	},
	function(accessToken, refreshToken, profile, done) {
		if (!profile.emails[0] || !profile.emails[0].value)
			return done(null, false);
		modelUser.findOne({
			'email': profile.emails[0].value
		}, function(err, user) {

			if (err) {
				console.log(err);
				return done(null, false);
			}
			if (!user) {
				user = new modelUser({
					googleId: profile.id,
					googleToken: profile.accessToken,
					email: profile.emails[0].value,
					login: !profile.username ? profile.displayName : profile.username,
					picture: profile.picture,
					status: 'Active'
				});
				modelUser.create(user, function(err) {
					if (err) {
						console.log(err);
						return done(null, false);
					}
					return done(null, user);
				});
			} else {
				if (!user.googleId || !user.googleToken)
				{
					modelUser.updateOne({_id: user._id}, {
						googleId: profile.id,
						googleToken: accessToken,
						status: 'Active'
					}, function(err, user) {
						if (err) {
							console.log(err);
							return done(null, false);
						}
						return done(null, user);
					});
				}
				return done(null, user);
			}
		});
	}));

	passport.use(new LocalStrategy({
		usernameField: 'email',
		passwordField: 'password',
		passReqToCallback: true,
		session: false
	},
	function (req, email, password, cb) {
		modelUser.findOne({
			'email': email,
			'status': 'Active'
		}, function(err, user) {
			if (err || !user)
				return cb(null, false);
			argon.verify(user.password, password)
			.then(match => {
				if (match) {
					return cb(null, user);
				} else {
					return cb(null, false);
				}
			})
			.catch(err => {
				return cb(null, false);
			});
		})
	}));


	passport.use(new BearerStrategy({
		passReqToCallback: true
	}, function(req, token, done) {
			token = jwt.verify(token, config.token.secret);
			modelUser.findOne({
				'_id': token.id,
				'status': token.status
			}, function (err, user) {
				if (err)
					return done(null, false);
				if (!user) {
					return done(null, false);
				}
				return done(null, user, { scope: 'all' });
		});
	}));
}
