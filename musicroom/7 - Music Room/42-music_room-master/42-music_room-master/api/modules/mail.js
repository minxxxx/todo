'use strict'

const nodemailer = require('nodemailer');
const config = require('../config/config.json');
const winston = require('winston');

const logger = winston.createLogger({
  levels: winston.config.syslog.levels,
  transports: [
    new winston.transports.File({
      filename: './logs/errors.log',
      level: 'error'
    }),
    new winston.transports.File({
        filename: './logs/info.log',
        level: 'info'
    })
  ]
});

class Mail {
    static sendMail(subject, html, to) {
        const transporter = nodemailer.createTransport({
            service: config.mail.service,
            auth: {
                user: config.mail.email,
                pass: config.mail.password
            }
        });

        let mailOptions = {
            from: config.mail.email, // sender address
            to: to, // list of receivers
            subject: subject, // Subject line
            html: html // plain text body
        };

		transporter.sendMail(mailOptions, function (err, info) {
			if(err)
                logger.error("Mail to " + config.mail.email + " Error -> " + err.message)
			else
                logger.info("Mail to " + config.mail.email + " Info -> " + JSON.stringify(info))
            return
		 });
    }
}
module.exports = Mail