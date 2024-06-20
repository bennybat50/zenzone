const {useAsync} = require("./index");
require('dotenv').config();
const originalConsoleLog = console.log; // Store the original console.log function

exports.ConsoleLogger = function (...args) {
    if (process.env.CONSOLE_LOG === 'true') {
        originalConsoleLog(...args); // Use the original console.log function
    }
};