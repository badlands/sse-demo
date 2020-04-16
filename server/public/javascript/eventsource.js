let eventSource;

function start() { // when "Start" button pressed
	log('start()');
	
  if (!window.EventSource) {
    // IE or an old browser
    alert("The browser doesn't support EventSource.");
    return;
  }

  eventSource = new EventSource('sse');

  eventSource.onopen = function(e) {
    log("Event: open");
  };

  eventSource.onerror = function(e) {
    log("Event: error");
    if (this.readyState == EventSource.CONNECTING) {
      log(`Reconnecting (readyState=${this.readyState})...`);
    } else {
      log("Error has occured.");
    }
  };

  eventSource.addEventListener('bye', function(e) {
    log("Event: bye, data: " + e.data);
  });

  eventSource.onmessage = function(e) {
    log("Event: message, data: " + e.data);
  };
}

function stop() { // when "Stop" button pressed
  eventSource.close();
  log("eventSource.close()");
}

function log(msg) {
	console.log(msg);
  logElem.innerHTML += msg + "<br>";
  document.documentElement.scrollTop = 99999999;
}

start();