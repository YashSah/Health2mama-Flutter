import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket _socket;
  final Function(Map<String, dynamic>) onMessageReceived;

  SocketService(this.onMessageReceived) {
    _initSocket();
  }

  void _initSocket() {
    _socket = IO.io('https://node-health2mama.mobiloitte.io', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.on('connect', (_) {
      print('Connected to socket server');
    });

    _socket.on('disconnect', (_) {
      print('Disconnected from socket server');
    });

    // Handle userChatInitiated event
    _socket.on('userChatInitiated', (data) {
      print('User chat initiated: $data');
      if (data != null && data['messages'] != null) {
        List<Map<String, dynamic>> messages = List<Map<String, dynamic>>.from(data['messages']);
        onMessageReceived({
          'chatRoomId': data['chatRoomId'],
          'messages': messages,
        });
      }
    });

    // Handle userSendMessage event
    _socket.on('userSendMessage', (data) {
      print('User sent message: $data');
      onMessageReceived(data);
    });

    // Handle getUserMessage event
    _socket.on('getUserMessage', (data) {
      print('Get user message: $data');
      onMessageReceived(data);
    });

    _socket.connect();
  }

  void initiateUserChat(String senderId, String receiverId) {
    _socket.emit('initiateUserChat', {
      'senderId': senderId,
      'receiverId': receiverId,
      'page': 1,
      'limit': 10,
    });
  }

  void sendMessage(String roomId, String from, String to, String message) {
    _socket.emit('userSendMessage', {
      'roomId': roomId,
      'from': from,
      'to': to,
      'message': message,
      'messageType': 'MESSAGE',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  void getUserMessage(String from, String to, String roomId, String message) {
    _socket.emit('getUserMessage', {
      'from': from,
      'to': to,
      'roomId': roomId,
      'message': message,
      'messageType': 'MESSAGE',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> fetchMessages(String userId, String receiverId, int page, int limit) async {
    final Completer<List<Map<String, dynamic>>> completer = Completer();

    _socket.emit('fetchMessages', {
      'userId': userId,
      'receiverId': receiverId,
      'page': page,
      'limit': limit,
    });

    _socket.on('fetchMessagesResponse', (data) {
      completer.complete(data);
    });

    return completer.future;
  }

  void dispose() {
    _socket.disconnect();
    _socket.dispose();
  }
}
