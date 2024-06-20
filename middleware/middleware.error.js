/**
 * Slantapp code and properties {www.slantapp.io}
 */
const middlewareError = (err, req, res, next) => {
    const error = {...err};
    error.message = err.message;
    //log whole error to console
    //console.log(error);
    /**
     * Define other error handling struct here
     */
    return res.status(error.statusCode || 500).json({
        status: false,
        message: error.message,
        data: null
    })
}
module.exports = middlewareError;