/**
 * 
 */
const {bodyParser} = require('../middleware/middleware.protects');

const express = require('express');
const router = express.Router();
const CoreError = require('./../core/core.error');
const { userRegister, userVerify, userVerified, userLogin, userPasswordVerify, userSettings, userEmailVerify, updatePassword } = require('../controller/controller.auth');

/**
 * auth routes
 */

router.post('/register', bodyParser, userRegister);
router.put('/verified', bodyParser, userVerified);
router.post('/veify', bodyParser, userVerify);
router.post('/login', bodyParser, userLogin);
router.post('/password/mail', bodyParser, userPasswordVerify);
router.post('/password/update', bodyParser, updatePassword);
router.get('/email/verify', bodyParser, userEmailVerify);
router.get('/email/verify', bodyParser, userEmailVerify);

/**
 * Export lastly
 */
router.all('/*', (req, res) => {
    throw new CoreError(`route not found ${req.originalUrl} using ${req.method} method`, 404);
})

module.exports = router;