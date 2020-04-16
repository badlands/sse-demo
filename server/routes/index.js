var express = require('express');
var router = express.Router();
var fs = require('fs');


function sendSSE(res, jsonObject) {	
	res.write(`data: ${JSON.stringify(jsonObject)}\n\n`); // res.write() instead of res.send()
}


/// GET /
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

/// GET /sse
router.get('/sse', (req, res) => {
	res.locals.connectionId = Math.floor(Math.random() * Math.floor(9999));

	console.log('GET /sse [' + res.locals.connectionId + ']');

	// Watch /tmp and look for changes
	let watcher = fs.watch('./tmp', (eventType, filename) => {
		if (filename) {
	  		console.log('[' + res.locals.connectionId + '] ' + Date() + " " + filename);
			  
			sendSSE(res, {filename: filename});
		}
	});	

	res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader("Access-Control-Allow-Origin", "*");
	res.flushHeaders(); // flush the headers to establish SSE with client	
	  
	sendSSE(res, {num: 1});

    // If client closes connection, stop sending events
    res.on('close', () => {
		// Stop the watcher
		watcher.close();

        console.log('[' + res.locals.connectionId + '] ' + Date() + ' ' + 'client dropped me at: ' + Date());
        res.end();
    });
});

module.exports = router;
