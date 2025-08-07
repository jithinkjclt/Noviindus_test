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
    var connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      ShowCustomSnackbar.error(
        context,
        message: "No internet connection.",
        icon: Icons.wifi_off,
      );
      return false;
    }
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
    if (!await _isConnected(context)) {
      return {'statusCode': 503, 'error': 'No internet', 'offline': true};
    }

    final url = Uri.parse("$baseUrl$endpoint");
    final headers = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final usedToken = tempToken ?? token;

    if (usedToken != null && requiresAuth) {
      headers['Authorization'] = 'Bearer $usedToken';
    } else if (requiresAuth && usedToken == null) {
      // Consider throwing an error or handling this case more explicitly
    }

    try {
      http.Response response;
      if (method == 'GET') {
        response = await http.get(url, headers: headers);
      } else if (method == 'POST') {
        final encodedBody = body?.entries
            .map((e) =>
        '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
            .join('&');
        response = await http.post(
          url,
          headers: headers,
          body: encodedBody,
        );
      } else {
        throw Exception('Unsupported method: $method');
      }

      final contentType = response.headers['content-type'] ?? '';

      if (!contentType.contains("application/json")) {
        return {
          'statusCode': response.statusCode,
          'error': 'Server returned an unexpected response format.',
        };
      }

      final decoded = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'statusCode': response.statusCode,
          'data': decoded,
        };
      } else {
        final errorMessage = decoded['message'] ?? decoded['error'] ?? 'An error occurred during the request.';
        return {
          'statusCode': response.statusCode,
          'error': errorMessage,
        };
      }
    } on SocketException {
      ShowCustomSnackbar.error(
        context,
        message: "Network error. Please check your internet connection.",
        icon: Icons.signal_wifi_bad,
      );
      return {'statusCode': 503, 'error': 'Network error', 'offline': true};
    } on TimeoutException {
      ShowCustomSnackbar.warning(
        context,
        message: "The request timed out. Please try again.",
        icon: Icons.timer_off,
      );
      return {'statusCode': 408, 'error': 'Request timeout'};
    } catch (e) {
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
    return await _request(
      context: context,
      endpoint: endpoint,
      method: 'POST',
      body: body,
      requiresAuth: requiresAuth,
      tempToken: token,
    );
  }

  // New method for handling multipart/form-data
  static Future<Map<String, dynamic>> postFormData({
    required BuildContext context,
    required String endpoint,
    required Map<String, String> body,
    bool requiresAuth = true,
    String? token,
  }) async {
    if (!await _isConnected(context)) {
      return {'statusCode': 503, 'error': 'No internet', 'offline': true};
    }

    try {
      final url = Uri.parse("$baseUrl$endpoint");
      final request = http.MultipartRequest("POST", url);

      final usedToken = token ?? token; // assuming you have a globalToken variable
      if (usedToken != null && requiresAuth) {
        request.headers['Authorization'] = 'Bearer $usedToken';
      }

      request.fields.addAll(body);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final decoded = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'statusCode': response.statusCode,
          'data': decoded,
        };
      } else {
        final errorMessage = decoded['message'] ?? decoded['error'] ?? 'An error occurred during the request.';
        return {
          'statusCode': response.statusCode,
          'error': errorMessage,
        };
      }
    } on SocketException {
      ShowCustomSnackbar.error(
        context,
        message: "Network error. Please check your internet connection.",
        icon: Icons.signal_wifi_bad,
      );
      return {'statusCode': 503, 'error': 'Network error', 'offline': true};
    } on TimeoutException {
      ShowCustomSnackbar.warning(
        context,
        message: "The request timed out. Please try again.",
        icon: Icons.timer_off,
      );
      return {'statusCode': 408, 'error': 'Request timeout'};
    } catch (e) {
      ShowCustomSnackbar.error(
        context,
        message: "An unexpected client error occurred. Please try again.",
        icon: Icons.error,
      );
      return {'statusCode': 500, 'error': 'An unexpected client error occurred.'};
    }
  }
}