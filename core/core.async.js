/**
 * Slantapp code and properties {www.slantapp.io}
 */
const asyncHandler = clk => (req, res, next) => Promise.resolve(clk(req, res, next)).catch(next);
module.exports = asyncHandler;