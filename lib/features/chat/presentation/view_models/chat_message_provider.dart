import 'package:chat_app/core/services/DB_helper/database_helper.dart';
import 'package:chat_app/features/chat/data/models/chat_message_model.dart';
import 'package:flutter/material.dart';

class ChatMessageProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => _messages;

  ChatMessageProvider() {
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    _messages = await _databaseHelper.getChatMessages();
    notifyListeners();
  }

  Future<void> addMessage(ChatMessage message) async {
    await _databaseHelper.insertChatMessage(message);
    await fetchMessages();
  }

  Future<void> updateMessage(ChatMessage message) async {
    await _databaseHelper.updateChatMessage(message);
    await fetchMessages();
  }

  Future<void> deleteMessage(int id) async {
    await _databaseHelper.deleteChatMessage(id);
    await fetchMessages();
  }
}
