import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/constants/variables.dart';
import '../../presentation/widget/custome_snackbar.dart';

class ApiService {
  static Future<bool> _isConnected(BuildContext context) async {
    print('ApiService: Checking internet connectivity...');
    var connectivity = await Connectivity().checkConnectivity();

    if (connectivity == ConnectivityResult.none) {
      print('ApiService: No internet connection detected.');
      ShowCustomSnackbar.error(
        context,
        message: "No internet connection.",
        icon: Icons.wifi_off,
      );
      return false;
    }
    print('ApiService: Internet connection available.');
    return true;
  }

  static Future<Map<String, dynamic>> _request({
    required BuildContext context,
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    bool requiresAuth = true,
    String? tempToken,
  }) async {
    print('ApiService: Starting API request for endpoint: $endpoint, method: $method');

    if (!await _isConnected(context)) {
      print('ApiService: Request aborted due to no internet connection.');
      return {'statusCode': 503, 'error': 'No internet', 'offline': true};
    }

    final url = Uri.parse("$baseUrl$endpoint");
    print('ApiService: Full URL: $url');

    final headers = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final usedToken = tempToken ?? token;
    print('ApiService: Requires Auth: $requiresAuth, Token Provided: ${usedToken != null ? "Yes" : "No"}');

    if (usedToken != null && requiresAuth) {
      // Changed from 'Token' to 'Bearer'
      headers['Authorization'] = 'Bearer $usedToken';
      print('ApiService: Authorization Header being sent: ${headers['Authorization']}');
    } else if (requiresAuth && usedToken == null) {
      print('ApiService: Warning: Authentication required but no token available.');
    }

    try {
      http.Response response;

      if (method == 'GET') {
        print('ApiService: Performing GET request...');
        response = await http.get(url, headers: headers);
      } else if (method == 'POST') {
        print('ApiService: Performing POST request...');
        final encodedBody = body?.entries
            .map((e) =>
        '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
            .join('&');
        print('ApiService: Request Body (Form-urlencoded): $encodedBody');

        response = await http.post(
          url,
          headers: headers,
          body: encodedBody,
        );
      } else {
        throw Exception('Unsupported method: $method');
      }

      print('ApiService: Response Status Code: ${response.statusCode}');
      print('ApiService: Response Headers: ${response.headers}');
      print('ApiService: Response Body: ${response.body}');

      final contentType = response.headers['content-type'] ?? '';
      print('ApiService: Response Content-Type: $contentType');

      if (!contentType.contains("application/json")) {
        print('ApiService: Server returned non-JSON content. Assuming error or unexpected response.');
        return {
          'statusCode': response.statusCode,
          'error': 'Server returned an unexpected response format.',
        };
      }

      final decoded = jsonDecode(response.body);
      print('ApiService: Decoded Response: $decoded');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('ApiService: Request successful.');
        return {
          'statusCode': response.statusCode,
          'data': decoded,
        };
      } else {
        final errorMessage = decoded['message'] ?? decoded['error'] ?? 'An error occurred during the request.';
        print('ApiService: API error: $errorMessage');
        return {
          'statusCode': response.statusCode,
          'error': errorMessage,
        };
      }
    } on SocketException {
      print('ApiService: SocketException: Network error.');
      ShowCustomSnackbar.error(
        context,
        message: "Network error. Please check your internet connection.",
        icon: Icons.signal_wifi_bad,
      );
      return {'statusCode': 503, 'error': 'Network error', 'offline': true};
    } on TimeoutException {
      print('ApiService: TimeoutException: Request timed out.');
      ShowCustomSnackbar.warning(
        context,
        message: "The request timed out. Please try again.",
        icon: Icons.timer_off,
      );
      return {'statusCode': 408, 'error': 'Request timeout'};
    } catch (e) {
      print('ApiService: Caught unexpected error: $e');
      ShowCustomSnackbar.error(
        context,
        message: "An unexpected client error occurred. Please try again.",
        icon: Icons.error,
      );
      return {'statusCode': 500, 'error': 'An unexpected client error occurred.'};
    }
  }

  static Future<Map<String, dynamic>> get({
    required BuildContext context,
    required String endpoint,
    bool requiresAuth = true,
    String? token,
  }) async {
    print('ApiService: Calling GET method for endpoint: $endpoint');
    return await _request(
      context: context,
      endpoint: endpoint,
      method: 'GET',
      requiresAuth: requiresAuth,
      tempToken: token,
    );
  }

  static Future<Map<String, dynamic>> post({
    required BuildContext context,
    required String endpoint,
    required Map<String, dynamic> body,
    bool requiresAuth = true,
    String? token,
  }) async {
    print('ApiService: Calling POST method for endpoint: $endpoint');
    return await _request(
      context: context,
      endpoint: endpoint,
      method: 'POST',
      body: body,
      requiresAuth: requiresAuth,
      tempToken: token,
    );
  }
}