var system = require('system');
var page = require('webpage').create();
var fs = require('fs');

if (system.args.length === 2) {
    console.log('Usage: snap.js <some URL> <view port width>');
    phantom.exit();
}
var url = system.args[1];
var view_port_width = system.args[2];

page.viewportSize = { width: view_port_width, height: 1500};
page.settings = { loadImages: true, javascriptEnabled: true };
page.settings.userAgent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/28.0.1500.95 Safari/537.17';

// You can place custom headers here, example below.
// page.customHeaders = {

//      // 'X-Candy-OVERRIDE': 'https://api.live.bbc.co.uk/'
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


page.onConsoleMessage = function(msg) {
    console.log(msg);
};

page.open(url, function(status) {
    if ( status === "success" ) {
        page.includeJs("http://ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js", function() {
            page.evaluate(function() {
                console.log($('a').each(function() { console.log(this.getAttribute('href')) }));
            });
            phantom.exit();
        });
    }
});

