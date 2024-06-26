library bugsnag_http_client;

import 'dart:typed_data';

import 'package:bugsnag_bridge/bugsnag_bridge.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final _subscribers = <dynamic Function(dynamic)?>[];
final _headersProvider = HttpHeadersProviderImpl();

void addSubscriber(dynamic Function(dynamic)? callback) {
  _subscribers.add(callback);
}

@override
Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
  var client = Client();
  return client.get(url, headers: headers);
}

Future<http.Response> post(Uri url,
    {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
  var client = Client();
  return client.post(url, headers: headers, body: body, encoding: encoding);
}

Future<http.Response> put(Uri url,
    {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
  var client = Client();
  return client.put(url, headers: headers, body: body, encoding: encoding);
}

Future<http.Response> delete(Uri url,
    {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
  var client = Client();
  return client.delete(url, headers: headers, body: body, encoding: encoding);
}

Future<http.Response> patch(Uri url,
    {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
  var client = Client();
  return client.patch(url, headers: headers, body: body, encoding: encoding);
}

Future<http.Response> head(Uri url, {Map<String, String>? headers}) async {
  var client = Client();
  return client.head(url, headers: headers);
}

Future<String> read(Uri url, {Map<String, String>? headers}) async {
  var client = Client();
  return client.read(url, headers: headers);
}

Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) async {
  var client = Client();
  return client.readBytes(url, headers: headers);
}

class Client extends http.BaseClient {
  final http.Client _client;
  static int _requestId = 0;

  Client({http.Client? client}) : _client = client ?? http.Client();

  String _generateRequestId() {
    _requestId += 1;
    return "$_requestId";
  }

  String _sendRequestStartNotification(String? url, String? method) {
    final requestId = _generateRequestId();
    _notifySubscriber({
      "url": url,
      "status": "started",
      "request_id": requestId,
      "http_method": method
    });
    return requestId;
  }

  void _sendRequestCompleteNotification(
      String requestId, http.Response response) {
    _notifySubscriber({
      "status": "complete",
      "status_code": response.statusCode,
      "request_id": requestId,
      "http_method": response.request!.method,
      "response_content_length": response.contentLength,
      "request_content_length": response.request!.contentLength,
      "client": 'package:http',
      "url": response.request!.url.toString()
    });
  }

  void _sendRequestFailedNotification(String requestId) {
    _notifySubscriber({
      "status": "failed",
      "request_id": requestId,
      "client": _client.runtimeType.toString()
    });
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final requestId = _sendRequestStartNotification(url.toString(), "GET");
    try {
      final allHeaders = {
        ...?headers,
        ...?(await _headersProvider.requestHeaders(
          url: url.toString(),
          requestId: requestId,
        )),
      };
      var response = await _client.get(url, headers: allHeaders);
      _sendRequestCompleteNotification(requestId, response);
      return response;
    } catch (e) {
      _sendRequestFailedNotification(requestId);
      rethrow;
    }
  }

  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final requestId = _sendRequestStartNotification(url.toString(), "POST");
    try {
      final allHeaders = {
        ...?headers,
        ...?(await _headersProvider.requestHeaders(
          url: url.toString(),
          requestId: requestId,
        )),
      };
      var response = await _client.post(url,
          headers: allHeaders, body: body, encoding: encoding);
      _sendRequestCompleteNotification(requestId, response);
      return response;
    } catch (e) {
      _sendRequestFailedNotification(requestId);
      rethrow;
    }
  }

  @override
  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final requestId = _sendRequestStartNotification(url.toString(), "PUT");
    try {
      final allHeaders = {
        ...?headers,
        ...?(await _headersProvider.requestHeaders(
          url: url.toString(),
          requestId: requestId,
        )),
      };
      var response = await _client.put(url,
          headers: allHeaders, body: body, encoding: encoding);
      _sendRequestCompleteNotification(requestId, response);
      return response;
    } catch (e) {
      _sendRequestFailedNotification(requestId);
      rethrow;
    }
  }

  @override
  Future<http.Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final requestId = _sendRequestStartNotification(url.toString(), "DELETE");
    try {
      final allHeaders = {
        ...?headers,
        ...?(await _headersProvider.requestHeaders(
          url: url.toString(),
          requestId: requestId,
        )),
      };
      var response = await _client.delete(url,
          headers: allHeaders, body: body, encoding: encoding);
      _sendRequestCompleteNotification(requestId, response);
      return response;
    } catch (e) {
      _sendRequestFailedNotification(requestId);
      rethrow;
    }
  }

  @override
  Future<http.Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final requestId = _sendRequestStartNotification(url.toString(), "PATCH");
    try {
      final allHeaders = {
        ...?headers,
        ...?(await _headersProvider.requestHeaders(
          url: url.toString(),
          requestId: requestId,
        )),
      };
      var response = await _client.patch(url,
          headers: allHeaders, body: body, encoding: encoding);
      _sendRequestCompleteNotification(requestId, response);
      return response;
    } catch (e) {
      _sendRequestFailedNotification(requestId);
      rethrow;
    }
  }

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) async {
    final requestId = _sendRequestStartNotification(url.toString(), "HEAD");
    try {
      final allHeaders = {
        ...?headers,
        ...?(await _headersProvider.requestHeaders(
          url: url.toString(),
          requestId: requestId,
        )),
      };
      var response = await _client.head(url, headers: allHeaders);
      _sendRequestCompleteNotification(requestId, response);
      return response;
    } catch (e) {
      _sendRequestFailedNotification(requestId);
      rethrow;
    }
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) async {
    final requestId = _sendRequestStartNotification(url.toString(), "READ");
    try {
      final allHeaders = {
        ...?headers,
        ...?(await _headersProvider.requestHeaders(
          url: url.toString(),
          requestId: requestId,
        )),
      };
      var response = await get(url, headers: allHeaders);
      _sendRequestCompleteNotification(requestId, response);
      return response.body;
    } catch (e) {
      _sendRequestFailedNotification(requestId);
      rethrow;
    }
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) async {
    final requestId = _sendRequestStartNotification(url.toString(), "READ");
    try {
      final allHeaders = {
        ...?headers,
        ...?(await _headersProvider.requestHeaders(
          url: url.toString(),
          requestId: requestId,
        )),
      };
      var response = await get(url, headers: allHeaders);
      _sendRequestCompleteNotification(requestId, response);
      return response.bodyBytes;
    } catch (e) {
      _sendRequestFailedNotification(requestId);
      rethrow;
    }
  }

  void _notifySubscriber(Map<String, dynamic> data) {
    for (var subscriber in _subscribers) {
      subscriber!(data);
    }
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final requestId = _sendRequestStartNotification(
        request.url.toString(), request.method.toUpperCase());
    try {
      var streamedResponse = await _client.send(request);
      streamedResponse.stream.toBytes().then((bytes) {
        _sendRequestCompleteNotification(
          requestId,
          http.Response.bytes(
            bytes,
            streamedResponse.statusCode,
            request: request,
            headers: streamedResponse.headers,
            isRedirect: streamedResponse.isRedirect,
            persistentConnection: streamedResponse.persistentConnection,
            reasonPhrase: streamedResponse.reasonPhrase,
          ),
        );
      });
      return streamedResponse;
    } catch (e) {
      _sendRequestFailedNotification(requestId);
      rethrow;
    }
  }
}
