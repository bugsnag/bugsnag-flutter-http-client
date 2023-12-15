library bugsnag_http_client;

import 'dart:ffi';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:convert';

class BugSnagHttpClient extends http.BaseClient{
  final http.Client _client;
  dynamic Function(dynamic)? _subscriber;

  BugSnagHttpClient({http.Client? client}) : _client = client ?? http.Client();

  void withSubscriber(dynamic Function(dynamic) callback) {
    _subscriber = callback;
  }

  String _sendRequestStartNotification() {
    var requestId = _generateRequestId();
    _notifySubscriber({
      "status": "started",
      "request_id": requestId
    });
    return requestId;
  }

  void _sendRequestCompleteNotification(String requestId, http.Response response) {
    _notifySubscriber({
      "status": "complete",
      "status_code": response.statusCode.toString(),
      "request_id": requestId,
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
    var requestId = _sendRequestStartNotification();
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
    var requestId = _sendRequestStartNotification();
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
    var requestId = _sendRequestStartNotification();
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
    var requestId = _sendRequestStartNotification();
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
    var requestId = _sendRequestStartNotification();
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
    var requestId = _sendRequestStartNotification();
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
    var requestId = _sendRequestStartNotification();
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
    var requestId = _sendRequestStartNotification();
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
  }

  String _generateRequestId() {
    return "${Random().nextInt(999999)}";
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    var requestId = _sendRequestStartNotification();
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
