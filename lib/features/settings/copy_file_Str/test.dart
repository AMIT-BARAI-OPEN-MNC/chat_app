import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/utils/user_Controller/user_provider.dart';
import 'package:chat_app/features/chat/data/models/chat_message_model.dart';
import 'package:chat_app/features/chat/presentation/view_models/chat_message_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final chatMessageProvider = Provider.of<ChatMessageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Home'),
      ),
      body: Consumer<ChatMessageProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.messages.length,
            itemBuilder: (context, index) {
              final message = provider.messages[index];
              final user = userProvider.users.firstWhere(
                  (user) => user.id == message.userId,
                  orElse: () => User(
                      id: message.userId,
                      username: 'Unknown',
                      email: 'unknown@example.com'));
              return ListTile(
                title: Text('${user.username}: ${message.message}'),
                subtitle: Text(
                    'Sent at ${DateTime.fromMillisecondsSinceEpoch(message.timestamp).toLocal()}'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showMessageDialog(
                      context, chatMessageProvider,
                      message: message),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMessageDialog(context, chatMessageProvider),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showMessageDialog(BuildContext context, ChatMessageProvider provider,
      {ChatMessage? message}) {
    final userController = TextEditingController();
    final messageController = TextEditingController();
    if (message != null) {
      final user = Provider.of<UserProvider>(context, listen: false)
          .users
          .firstWhere((user) => user.id == message.userId,
              orElse: () => User(
                  id: message.userId,
                  username: 'Unknown',
                  email: 'unknown@example.com'));
      userController.text = user.username;
      messageController.text = message.message;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message == null ? 'Add Message' : 'Edit Message'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: userController,
              decoration: InputDecoration(labelText: 'User'),
            ),
            TextField(
              controller: messageController,
              decoration: InputDecoration(labelText: 'Message'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final username = userController.text;
              final user = Provider.of<UserProvider>(context, listen: false)
                  .users
                  .firstWhere((user) => user.username == username,
                      orElse: () => User(
                          id: DateTime.now().millisecondsSinceEpoch,
                          username: username,
                          email: 'example@example.com'));
              if (user.id == DateTime.now().millisecondsSinceEpoch) {
                Provider.of<UserProvider>(context, listen: false).addUser(user);
              }
              final newMessage = ChatMessage(
                id: message?.id ?? DateTime.now().millisecondsSinceEpoch,
                userId: user.id,
                message: messageController.text,
                timestamp: DateTime.now().millisecondsSinceEpoch,
              );
              if (message == null) {
                provider.addMessage(newMessage);
              } else {
                provider.updateMessage(newMessage);
              }
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
