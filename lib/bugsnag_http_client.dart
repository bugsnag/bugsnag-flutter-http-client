library bugsnag_http_client;

import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'dart:convert';

dynamic Function(dynamic)? _staticSubscriber;

void setSubscriber(dynamic Function(dynamic) callback) {
  _staticSubscriber = callback;
}

@override
Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
  var client = BugSnagHttpClient();
  return client.get(url, headers: headers);
}

Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
  var client = BugSnagHttpClient();
  return client.post(url, headers: headers, body: body, encoding: encoding);
}

Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
  var client = BugSnagHttpClient();
  return client.put(url, headers: headers, body: body, encoding: encoding);
}

Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
  var client = BugSnagHttpClient();
  return client.delete(url, headers: headers, body: body, encoding: encoding);
}

Future<http.Response> patch(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
  var client = BugSnagHttpClient();
  return client.patch(url, headers: headers, body: body, encoding: encoding);
}

Future<http.Response> head(Uri url, {Map<String, String>? headers}) async {
  var client = BugSnagHttpClient();
  return client.head(url, headers: headers);
}

Future<String> read(Uri url, {Map<String, String>? headers}) async {
  var client = BugSnagHttpClient();
  return client.read(url, headers: headers);
}

Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) async {
  var client = BugSnagHttpClient();
  return client.readBytes(url, headers: headers);
}


class BugSnagHttpClient extends http.BaseClient{
  final http.Client _client;
  dynamic Function(dynamic)? _subscriber;
  static int _requestId = 0;

  BugSnagHttpClient({http.Client? client}) : _client = client ?? http.Client();

  String _generateRequestId() {
    _requestId += 1;
    return "$_requestId";
  }

  BugSnagHttpClient withSubscriber(dynamic Function(dynamic) callback) {
    _subscriber = callback;
    return this;
  }

  String _sendRequestStartNotification(String? url,String? method) {
    var requestId = _generateRequestId();
    _notifySubscriber({
      "url": url,
      "status": "started",
      "request_id": requestId,
      "http_method": method
    });
    return requestId;
  }

  void _sendRequestCompleteNotification(String requestId, http.Response response) {
    _notifySubscriber({
      "status": "complete",
      "status_code": response.statusCode,
      "request_id": requestId,
      "http_method": response.request!.method,
      "response_content_length": response.contentLength,
      "request_content_length": response.request!.contentLength
    });
  }

  void _sendRequestFailedNotification(String requestId) {
    _notifySubscriber({
      "status": "failed",
      "request_id": requestId
    });
  }
  
  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    var requestId = _sendRequestStartNotification(url.toString(),"GET");
    try {
      var response = await _client.get(url, headers: headers);
      _sendRequestCompleteNotification(requestId, response);
      return response;
    } catch (e) {
      _sendRequestFailedNotification(requestId);
      rethrow;
    }
  }

  @override
  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding})  async {
    var requestId = _sendRequestStartNotification(url.toString(),"POST");
    try {
      var response = await _client.post(url, headers: headers, body: body, encoding: encoding);
      _sendRequestCompleteNotification(requestId, response);
      return response;
    } catch (e) {
      _sendRequestFailedNotification(requestId);
      rethrow;
    }
  }

  @override
  Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    var requestId = _sendRequestStartNotification(url.toString(),"PUT");
    try {
      var response = await _client.put(url, headers: headers, body: body, encoding: encoding);
      _sendRequestCompleteNotification(requestId, response);
      return response;
    } catch (e) {
      _sendRequestFailedNotification(requestId);
      rethrow;
    }
  }

  @override
  Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding})  async {
    var requestId = _sendRequestStartNotification(url.toString(),"DELETE");
    try {
      var response = await _client.delete(url, headers: headers, body: body, encoding: encoding);
      _sendRequestCompleteNotification(requestId, response);
      return response;
    } catch (e) {
      _sendRequestFailedNotification(requestId);
      rethrow;
    }
  }

  @override
  Future<http.Response> patch(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding})  async {
    var requestId = _sendRequestStartNotification(url.toString(),"PATCH");
    try {
      var response = await _client.patch(url, headers: headers, body: body, encoding: encoding);
      _sendRequestCompleteNotification(requestId, response);
      return response;
    } catch (e) {
      _sendRequestFailedNotification(requestId);
      rethrow;
    }
  }

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) async {
    var requestId = _sendRequestStartNotification(url.toString(),"HEAD");
    try {
      var response = await _client.head(url, headers: headers);
      _sendRequestCompleteNotification(requestId, response);
      return response;
    } catch (e) {
      _sendRequestFailedNotification(requestId);
      rethrow;
    }
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) async {
    var requestId = _sendRequestStartNotification(url.toString(),"READ");
    try {
      var response = await get(url, headers: headers);
      _sendRequestCompleteNotification(requestId, response);
      return response.body;
    } catch (e) {
      _sendRequestFailedNotification(requestId);
      rethrow;
    }
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) async {
    var requestId = _sendRequestStartNotification(url.toString(),"READ");
    try {
      var response = await get(url, headers: headers);
      _sendRequestCompleteNotification(requestId, response);
      return response.bodyBytes;
    } catch (e) {
      _sendRequestFailedNotification(requestId);
      rethrow;
    }
  }

  void _notifySubscriber(Map<String, dynamic> data) {
    _subscriber?.call(data);
    _staticSubscriber?.call(data);
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    var requestId = _sendRequestStartNotification(request.url.toString(),request.method.toUpperCase());
    try {
      var streamedResponse = await _client.send(request);
      streamedResponse.stream.toBytes().then((bytes) {
        _sendRequestCompleteNotification(requestId, http.Response.bytes(
          bytes,
          streamedResponse.statusCode,
          request: request,
          headers: streamedResponse.headers,
          isRedirect: streamedResponse.isRedirect,
          persistentConnection: streamedResponse.persistentConnection,
          reasonPhrase: streamedResponse.reasonPhrase,
        ));
      });
      return streamedResponse;
    } catch (e) {
      _sendRequestFailedNotification(requestId);
      rethrow;
    }
  }
}
