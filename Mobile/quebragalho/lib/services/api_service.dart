import 'dart:convert';
import 'dart:io';
import 'package:flutter_quebragalho/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static Map<String, String> _getHeaders({bool isMultipart = false}) {
    final headers = {
      if (!isMultipart) 'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  static Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
        headers: _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Future<dynamic> post(String endpoint, {dynamic body}) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
        headers: _getHeaders(),
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e, stackTrace) {
      print('Erro no POST: $e\n$stackTrace');
      throw _handleError(e);
    }
  }

  static Future<dynamic> put(String endpoint, {dynamic body}) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
        headers: _getHeaders(),
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Future<bool> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
        headers: _getHeaders(),
      );
      return _handleResponse(response) ?? true;
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Future<dynamic> uploadFile(
    String endpoint,
    File file, {
    String fieldName = 'file',
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
      );
      request.headers.addAll(_getHeaders(isMultipart: true));
      request.files.add(await http.MultipartFile.fromPath(
        fieldName,
        file.path,
        contentType: MediaType('image', 'jpeg'),
      ));

      var response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(responseData);
      } else {
        throw HttpException(
          'Upload failed with status ${response.statusCode}',
          uri: Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
        );
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  static dynamic _handleResponse(http.Response response) {
    print('Resposta da API [${response.statusCode}]: ${response.body}');

    switch (response.statusCode) {
      case 200:
      case 201:
        return response.body.isNotEmpty ? jsonDecode(response.body) : true;
      case 204:
        return true;
      case 400:
        throw BadRequestException(response.body);
      case 401:
        throw UnauthorizedException(response.body);
      case 403:
        throw ForbiddenException(response.body);
      case 404:
        throw NotFoundException(response.body);
      case 500:
      case 502:
        throw ServerException(response.body);
      default:
        throw HttpException(
          'Request failed with status ${response.statusCode}',
          uri: response.request?.url,
        );
    }
  }

  static Exception _handleError(dynamic error) {
    if (error is SocketException) {
      return NetworkException('Falha na conexão com o servidor');
    } else if (error is HttpException) {
      return error;
    } else if (error is FormatException) {
      return DataParsingException('Erro ao processar dados da API');
    }
    return UnknownException(error.toString());
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class BadRequestException implements Exception {
  final String message;
  BadRequestException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}

class ForbiddenException implements Exception {
  final String message;
  ForbiddenException(this.message);
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class DataParsingException implements Exception {
  final String message;
  DataParsingException(this.message);
}

class UnknownException implements Exception {
  final String message;
  UnknownException(this.message);
}
