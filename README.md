# NOTE: This repo is a work in progress and has not yet been released as a production ready package.

# BugSnagHttpClient

A wrapper for the [Dart HTTP package](https://pub.dev/packages/http) that enables automated instrumentation via the BugSnag Performance SDK and Error Monitoring SDK. This package simplifies the process of tracking and monitoring HTTP requests in your Dart applications.

## Features

- **Automated Request Instrumentation**: Automatically creates network spans for HTTP requests and sends them to the BugSnag Performance dashboard.

## Getting Started

To use the `BugSnagHttpClient` wrapper in your Dart project, first add the dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  bugsnag_http_client: ^1.0.0 # Use the latest version
```

Then, run pub get in your terminal to fetch the package.

## Usage
Here's a simple example of using BugSnagHttpClient:

```dart

// Import the wrapper
import 'package:bugsnag_http_client/bugsnag_http_client.dart' as http;

// add Bugsnag Performance as a subscriber. This only needs to be done once in your apps lifecycle.
  http.addSubscriber(BugsnagPerformance.networkInstrumentation);

// Requests can be made staticly 
  http.get(Uri.parse("https://www.google.com"));

// or via a client instance
  var client = http.BugSnagHttpClient();
  client.get(Uri.parse("https://www.google.com"));

```
