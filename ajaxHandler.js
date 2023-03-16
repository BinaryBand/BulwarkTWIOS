
//var open = XMLHttpRequest.prototype.open;

//var send = XMLHttpRequest.prototype.send;


//function openReplacement(method, url, async, user, password) {
//  this._url = url;
  //  this.addEventListener("load", function() {
  //      var message = {"status" : this.status, "responseURL" : this.responseURL, "body" : this.responseText};
 //      // webkit.messageHandlers.test.postMessage(message);
 //   });
 //
 // return open.apply(this, arguments);
//}
//function sendReplacement(data) {
 // if(this.onreadystatechange) {
 //   this._onreadystatechange = this.onreadystatechange;
 // }
//  /**
//   * PLACE HERE YOUR CODE WHEN REQUEST IS SENT
//   */
//  this.onreadystatechange = onReadyStateChangeReplacement;
//  return send.apply(this, arguments);
//}
//function onReadyStateChangeReplacement() {
//  /**
//   * PLACE HERE YOUR CODE FOR READYSTATECHANGE
//   */
//    if(this.status==200){
//        var message = {"status" : this.status, "responseURL" : this.responseURL, "body" : this.responseText};
//        //webkit.messageHandlers.test.postMessage(message);
//    }
//  if(this._onreadystatechange) {
//    return this._onreadystatechange.apply(this, arguments);
//  }
//}
//XMLHttpRequest.prototype.open = openReplacement;
//XMLHttpRequest.prototype.send = sendReplacement;


window.fetch = new Proxy(window.fetch, {
    apply(fetch, that, args) {
        // Forward function call to the original fetch
        const result = fetch.apply(that, args);
        
        //webkit.messageHandlers.test.postMessage(result.response);
        // Do whatever you want with the resulting Promise
        result.then((response) => {
            
            //webkit.messageHandlers.test.postMessage('tttttttttttttttttttttttttt');
          //  webkit.messageHandlers.test.postMessage(response.message);
          //  webkit.messageHandlers.test.postMessage('tsssssssddsdsdsdsdsd');
          //  webkit.messageHandlers.test.postMessage(response._url);
          //  webkit.messageHandlers.test.postMessage('qqqqq');
          //  webkit.messageHandlers.test.postMessage(response.data);
          //  webkit.messageHandlers.test.postMessage('ttt');
            console.log("fetch completed!", args, response);
            
            respclone = response.clone()
            
            respclone.json().then(data => ({
                    data: data,
                    status: response.status
                })
            ).then(res => {
                console.log("xxxxxxxxx", res.data);
                
                let jstr = JSON.stringify(res.data);
                webkit.messageHandlers.truliaHandler.postMessage(jstr);
                
                
            });
            
            
            //respclone = response.clone()
            //console.log(respclone)
            //let reader = respclone.body.getReader();
            //let decoder = new TextDecoder('utf-8');
            //reader.read().then(function (resultn) {
                
            //    webkit.messageHandlers.truliaHandler.postMessage(decoder.decode(resultn.value))
            //    console.log(decoder.decode(result.value));
            //    console.log('\n\n\n\n\n\n\n');
             //  });
            
            //console.log(response.body.text())
            
        });

        return result;
    }
});
