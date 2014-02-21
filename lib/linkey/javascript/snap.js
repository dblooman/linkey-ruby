var system = require('system');
var page = require('webpage').create();
var fs = require('fs');

var url = system.args[1];
var lastRequestTimeout;
var finalTimeout;
var currentRequests = 0;

// You can place custom headers here, example below.
// page.customHeaders = {

//      'X-Candy-OVERRIDE': 'https://api.live.bbc.co.uk/',
//      'X-Country': 'cn'

//  };

// If you want to set a cookie, just add your details below in the following way.

phantom.addCookie({
    'name': 'ckns_policy',
    'value': '111',
    'domain': '.bbc.co.uk'
});
phantom.addCookie({
    'name': 'locserv',
    'value': '1#l1#i=6691484:n=Oxford+Circus:h=e@w1#i=8:p=London@d1#1=l:2=e:3=e:4=2@n1#r=40',
    'domain': '.bbc.co.uk'
});

var checkLinks = function checkLinks () {
    page.evaluate(function() {
        var anchorsArray = Array.prototype.slice.call(document.querySelectorAll("a"));

        anchorsArray.forEach(function(anchor) {
            console.log(anchor.pathname);
        });

        window.callPhantom();
    });
};

var debouncedCheckFinish = function debouncedCheckFinish () {
    clearTimeout(lastRequestTimeout);
    clearTimeout(finalTimeout);

    if (currentRequests < 1) {
        clearTimeout(finalTimeout);
        lastRequestTimeout = setTimeout(function() {
            // Page has finished loading all resources
            // Do stuff here
            checkLinks();
        }, 1000);
    }

    finalTimeout = setTimeout(function() {
        // Page is tired of waiting for resources to load
        // Exit but do stuff anyway

        checkLinks();
    }, 9000);
};

page.onResourceRequested = function(req) {
    currentRequests += 1;
};

page.onResourceReceived = function(res) {
    if (res.stage === 'end') {
        currentRequests -= 1;
        debouncedCheckFinish();
    }
};

page.onConsoleMessage = function(msg) {
    console.log(msg);
};

page.onCallback = function() {
    phantom.exit();
};

page.open(url, function(status) {
    if (status === 'fail') {
        console.error('Couldn\'t load url');
        phantom.exit(1);
    }
});
