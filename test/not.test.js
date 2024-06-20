const {firebaseNotification, notify} = require('../core/core.utils')

//regToken | Device ID
let iosToken = "c0jrxPqNu0LDmjG736qCQn:APA91bGmbQVhGxzGcSfumMIIL9bmyapTUEgWabKxMg2nsAsZyFPDYGTDE-7kA1i4r8uPAx8RaDQjZ9wGy26ukC60xtG_jxj1FkZuC3JnGbMzKnQm_4GQoYqhze4clKQfQ3uwJ-dTUog_"
let androidToken = "dC8itKEETvKgAE8CN30KLW:APA91bEoA2QaL7H5xsXez9pGuFUT0d36D4mixuYcB7OxwE3kQ33tVSgNXcOePhkUvMcaqJ5kKPAGpiAv5rvymEwSSteZooUy7pVZjAvK8dRcTP97t3j11uOnLcikOHUk11HY5fX1LOag"

let token = 'dy42NkNoS-eqhGS50UDPSd:APA91bHbAgJWBHSV9wix5b5F8CPqjgChMG3yqPhYpjPXzth6PIfWmV-6-nSYK4PVTJDfQZP1rL6fY3X3afWT-EcfBuBb_B-i1LJ28-ZYiv_tU97MCVrePXuQf7xwBnRxE8EKCN540DLK'

//Message Payload (Data)

let data = {
    message_kind: "type"
}
let notification = {
    title: "Hi",
    body: `Welcome to Mongoro`
};

//Send Notification
// firebaseNotification(token, notification.title, notification.body, data).then(r => log(r));
notify('@voo', notification.title, notification.body, data).then(r => console.log(r));