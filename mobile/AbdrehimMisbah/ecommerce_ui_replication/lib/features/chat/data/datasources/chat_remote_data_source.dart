import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exception.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  /// Calls GET /chats
  Future<List<ChatModel>> getAllChats();

  /// Calls GET /chats/{chatId}/messages
  Future<List<MessageModel>> getChatMessages(String chatId);

  Future<ChatModel> initiateChat(String userId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  final String? authToken;

  ChatRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = 'https://g5-flutter-learning-path-be.onrender.com/api/v3',
    this.authToken,
  });

  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    if (authToken != null && authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }

  @override
  Future<List<ChatModel>> getAllChats() async {
    final url = Uri.parse('$baseUrl/chats');
    final response = await client.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<dynamic> chatListJson = body['data'];
      final chats = chatListJson
          .map((json) => ChatModel.fromJson(json))
          .toList();
      return chats;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MessageModel>> getChatMessages(String chatId) async {
    final url = Uri.parse('$baseUrl/chats/$chatId/messages');
    final response = await client.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<dynamic> messageListJson = body['data'];
      final messages = messageListJson
          .map((json) => MessageModel.fromJson(json))
          .toList();
      return messages;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ChatModel> initiateChat(String userId) async {
    final url = Uri.parse('$baseUrl/chats');
    final response = await client.post(
      url,
      headers: _headers,
      body: json.encode({'userId': userId}),
    );

    if (response.statusCode == 201) {
      final body = json.decode(response.body);
      final chatJson = body['data'];
      return ChatModel.fromJson(chatJson);
    } else {
      throw ServerException();
    }
  }
}
