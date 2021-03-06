part of pingpong.common;

Future getJSON(String url) {
  return requestJSON('GET', url, null);
}

Future postJSON(String url, dynamic sendData) {
  return requestJSON('POST', url, sendData);
}

Future requestJSON(String method, String url, [dynamic sendData]) {
  var c = new Completer();

  var requestHeaders = {};
  if(sendData != null){
    sendData = JSON.encode(sendData);
    requestHeaders['Content-Type'] = 'application/json';
  }

  HttpRequest.request(url, method: method,
      requestHeaders: requestHeaders,
      sendData: sendData)
    ..then((xhr)=> c.complete(JSON.decode(xhr.responseText)))
    ..catchError((ProgressEvent e){
        print("Error Communicating With Server: ${e}");
        querySelector("#asyncError").hidden = false;
        c.completeError(e);
      });

  return c.future;
}
