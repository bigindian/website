
/*
Set this to the total number of scripts in the page. Ideally we could use a
loop and find out programatically, but I prefer to hard-code it as the
dependencies don't change that often.
 */

(function() {
  var _addScript, body, head, incrementProgressBar, isDevelopment, j, len, maxScriptCount, processScript, script, totalScriptsLoaded;

  maxScriptCount = 10;

  head = (document.getElementsByTagName("head"))[0];

  body = (document.getElementsByTagName("body"))[0];

  totalScriptsLoaded = 0;

  isDevelopment = publicData.environment === "development";

  incrementProgressBar = function() {
    var setProgressBar;
    setProgressBar = function(i, total) {
      var progressBarStyle;
      progressBarStyle = (document.getElementById("page-loading-bar")).style;
      return progressBarStyle.width = (i * 1.0 / total * 100) + "%";
    };
    totalScriptsLoaded++;
    return setProgressBar(totalScriptsLoaded, maxScriptCount);
  };


  /*
  This function neatly adds the script/stylesheet into the DOM, and that too
  asynchronously. It also takes care of making sure that CSS code is loaded in
  a non-blocking manner (This means that you need to make sure that you have
  some inline styles on the page otherwise the page will look ugly when the
  CSS has not yet fully loaded. See more about render-blocking CSS).
   */

  _addScript = function(urlsOrCode, isCSS) {
    var $fileref;
    if (isCSS) {
      $fileref = document.createElement("link");
      $fileref.rel = "stylesheet";
      $fileref.type = "text/css";
      $fileref.media = "none";
    } else {
      $fileref = document.createElement("script");
      $fileref.type = "text/javascript";
    }
    if (isCSS) {
      $fileref.href = urlsOrCode;
    } else {
      $fileref.src = urlsOrCode;
    }
    $fileref.async = false;
    $fileref.onreadystatechange = function() {
      if (this.media === "none") {
        this.media = "all";
      }
      if (this.readyState === "complete") {
        return incrementProgressBar();
      }
    };
    $fileref.onload = function() {
      if (this.media === "none") {
        this.media = "all";
      }
      return incrementProgressBar();
    };
    if (isCSS) {
      return head.appendChild($fileref);
    } else {
      return head.insertBefore($fileref, head.firstChild);
    }
  };


  /*
  This function processes the given script and attempts to load it either from
  the cache or from the remote URL..
   */

  processScript = function(script) {
    var isCSS, j, len, results, urlOrCode, urlsOrCode;
    isCSS = (script.id.substr(-3)) === "css";
    urlsOrCode = script.remote;
    if (isDevelopment && (script.local != null)) {
      urlsOrCode = [script.local];
    }
    results = [];
    for (j = 0, len = urlsOrCode.length; j < len; j++) {
      urlOrCode = urlsOrCode[j];
      results.push(_addScript(urlOrCode, isCSS));
    }
    return results;
  };

  for (j = 0, len = scripts.length; j < len; j++) {
    script = scripts[j];
    processScript(script);
  }

}).call(this);
