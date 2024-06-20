/**
 * 
 */
const {userBodyGuard} = require('../middleware/middleware.protects');

const express = require('express');
const router = express.Router();
const CoreError = require('./../core/core.error');
const {  userSettings, singleUser, deleteUser,userHomeData, audit, singleAudit, deleteAudit, allUser, changePassword,hostPorfile, userUpdateMood, sendMoodCheck } = require('../controller/controller.user');
const { resources,allResources,resourceUpdate, singleResources, userResources, deleteResources, interestResources,interestAndResources ,searchResources, updatePlayCount,highResources} = require('../controller/controller.resources');
const { deleteSubscription, userSubscription, singleSubscription, subscription, allSubscription } = require('../controller/controller.subscription');
const { review, singleReview, userReview, deleteReview, allReview } = require('../controller/controller.review');
const { interest,interestUpdate, singleInterest, allInterest, userInterest, deleteInterest, createUserInterest,deleteUserInterest, interestUser } = require('../controller/controller.interest');
const { history, singleHistory, allHistory, userHistory, deleteHistory } = require('../controller/controller.history');
const { singleFavourite, allFavourite, userFavourite, deleteFavourite, favourite } = require('../controller/controller.favourite');
const { host, singleHost, allHost, userHost, deleteHost } = require('../controller/controller.hostRequest');
const { bookmark, singleBookmark, allBookmark, userBookmark, deleteBookmark,userSingleBookmark } = require('../controller/controller.bookmark');
const { recommend, singleRecommend, interestRecommend, deleteRecommend, allRecommend } = require('../controller/controller.recommend');
const { app_message_create, app_version_create, singleAppMessage, singleAppVersion, deleteAppMessage, deleteAppVersion } = require('../controller/controller.app-management');
const { generateCoupon, singlecoupon, allcoupon, deletecoupon, assigncoupon,stripePayment } = require('../controller/controller.coupon');
/**
 * auth routes
 */

router.put('/user/setting/:id', userSettings);
router.get('/single/:id', singleUser);
router.get('/users', allUser);
router.get('/user/host/:id', hostPorfile);
router.get('/user/home/:id', userHomeData); 
router.post('/change/password', changePassword);
router.post('/delete', deleteUser);
router.post('/mood-update/:id', userUpdateMood);
router.get('/send-mood-check', sendMoodCheck);

//AUDIT
router.post('/audit', audit);
router.get('/audit/:id', singleAudit);
router.post('/audit/delete', deleteAudit);

//RESOURCES
router.post('/resources', resources);
router.post('/resources/search', searchResources);
router.get('/resources', allResources);
router.get('/resources/:id', singleResources);
router.put('/resources/:id', resourceUpdate);
router.get('/resources/user/:id', userResources);
router.get('/resources/interest/:id', interestResources);
router.get('/resource-interests', interestAndResources);
router.post('/resources/delete', deleteResources);
router.get('/resources/count/:id', updatePlayCount);
router.get('/resources/top/count', highResources);

// SUBSCRIPTION
router.post('/subscription', subscription);
router.get('/subscription/:id', singleSubscription);
router.get('/subscriptions', allSubscription);
router.post('/subscription/delete', deleteSubscription);

//REVIEW
router.post('/review', review);
router.get('/review/:id', singleReview);
router.get('/reviews', allReview);
router.get('/review/user/:id', userReview);
router.post('/review/delete', deleteReview);

//INTEREST
router.post('/interest', interest);
router.post('/interest/user/create', createUserInterest);
router.get('/interest/:id', singleInterest);
router.put('/interest/:id', interestUpdate);
router.get('/interests', allInterest);
router.get('/interest/user/:id', userInterest);
router.get('/interest/users/interest/:id', interestUser);
router.get('/interest/user/delete', deleteUserInterest);
router.post('/interest/delete', deleteInterest);

//HISTORY
router.post('/history', history);
router.get('/history/:id', singleHistory);
router.get('/histories', allHistory);
router.get('/history/user/:id', userHistory);
router.post('/history/delete', deleteHistory);

//FAVOURITES
router.post('/favourite', favourite);
router.get('/favourite/:id', singleFavourite);
router.get('/favourites', allFavourite);
router.get('/favourite/user/:id', userFavourite);
router.post('/favourite/delete', deleteFavourite);

//HOST REQUEST
router.post('/host', host);
router.get('/host/:id', singleHost);
router.get('/hosts', allHost);
router.get('/host/user/:id', userHost);
router.post('/host/delete', deleteHost);


//Bookmark
router.post('/bookmark', bookmark);
router.get('/bookmark/:id', singleBookmark);
router.get('/bookmark/all', allBookmark);
router.get('/bookmark/user/:id', userBookmark);
router.get('/bookmark/user/:userID/:resourceID', userSingleBookmark);
router.post('/bookmark/delete', deleteBookmark);

//Recommend
router.post('/recommendation', recommend);
router.get('/recommendation/:id', singleRecommend);
router.get('/recommendation', allRecommend);
router.get('/recommendation/interest/:id', interestRecommend);
 router.post('/recommendation/delete', deleteRecommend);

//App Version
router.post('/app-version', app_version_create);
router.post('/app-message', app_message_create);
router.get('/app-version', singleAppVersion);
router.get('/app-message', singleAppMessage);
router.post('/app-version/delete', deleteAppVersion);
router.post('/app-message/delete', deleteAppMessage);

//App Cuopns
router.post('/create-coupons', generateCoupon);
router.get('/all-coupons', allcoupon);
router.post('/assign-coupon', assigncoupon);
router.post('/stripe-payment', stripePayment);
/**
 * Export lastly
 */
router.all('/*', (req, res) => {
    throw new CoreError(`route not found ${req.originalUrl} using ${req.method} method`, 404);
})

module.exports = router;
