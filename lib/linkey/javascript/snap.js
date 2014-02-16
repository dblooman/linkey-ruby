var system = require('system');
var page = require('webpage').create();
var fs = require('fs');

var url = system.args[1];

// You can place custom headers here, example below.
// page.customHeaders = {

     // 'X-Candy-OVERRIDE': 'https://api.test.bbc.co.uk/'
     // 'X-Country': 'cn'

 // };

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


page.onConsoleMessage = function(msg) {
    console.log(msg);
};

page.onCallback = function() {
    phantom.exit();
};

page.open(url, function(status) {
    if ( status === "success" ) {
        page.evaluate(function() {
            var anchorsArray = Array.prototype.slice.call(document.querySelectorAll("a"));

            anchorsArray.forEach(function(anchor) {
                console.log(anchor.pathname);
            });

            window.callPhantom();
        });
    }
});

