const address = require("address");
const ipLocation = require("iplocation");

const ip = address.ip();

async function getUserLocation(ip) {
    const response = await fetch(`https://ipinfo.io/${ip}/json?token=26917d1f7f2cb9`);
    const {city, country} = await response.json();
    return {city, country};
}

// Example usage:
getUserLocation(ip)
    .then(location => console.log(location))
    .catch(error => console.error(error));