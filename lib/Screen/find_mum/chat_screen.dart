import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health2mama/Utils/api_constant.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/find_mum/find_mum_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:health2mama/services/SocketService.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final String name;
  final String image;
  final String userId;
  final String receiverId;

  const ChatScreen({
    required this.name,
    required this.image,
    required this.userId,
    required this.receiverId,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _textController = TextEditingController();
  late final SocketService _socketService;
  bool _isSending = false;
  int _page = 1;
  int _limit = 10;
  bool _isLoading = false;
  bool _hasMoreMessages = true;
  String? _roomId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _socketService = SocketService((message) {
      if (message.containsKey('chatRoomId')) {
        setState(() {
          _roomId = message['chatRoomId'];
          _messages.clear();
          _messages.addAll(message['messages']);
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    });
    _initChat();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.minScrollExtent &&
          _hasMoreMessages) {
        _fetchMoreMessages();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _socketService.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> _initChat() async {
    setState(() => _isLoading = true);

    try {
      _socketService.initiateUserChat(widget.userId, widget.receiverId);
    } catch (error) {
      print('Error initiating chat: $error');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchMoreMessages() async {
    if (_isLoading || !_hasMoreMessages) return;

    setState(() => _isLoading = true);

    try {
      _page++;
      final fetchedMessages = await _socketService.fetchMessages(
          widget.userId, widget.receiverId, _page, _limit);
      if (fetchedMessages.isNotEmpty) {
        setState(() {
          _messages.addAll(fetchedMessages);
        });
      } else {
        _hasMoreMessages = false;
      }
    } catch (error) {
      print('Error fetching more messages: $error');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _sendMessage(String text, String messageType) {
    if (text.isEmpty || _roomId == null || _isSending) return;

    setState(() {
      _isSending = true;
    });

    try {
      _socketService.sendMessage(
          _roomId!, widget.userId, widget.receiverId, text);

      setState(() {
        _messages.add({
          'message': text,
          'from': widget.userId,
          'createdAt': DateTime.now().toIso8601String(),
          'messageType': messageType,
        });

        // Clear the text field after sending the message
        _textController.clear();
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (error) {
      print('Error sending message: $error');
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  Future<String> _uploadFile(String filePath, String fileType) async {
    final serverEndpoint = APIEndPoints.uploadFile;

    final file = File(filePath);
    final fileName =
        file.uri.pathSegments.last;

    final request = http.MultipartRequest('POST', Uri.parse(serverEndpoint))
      ..fields['fileType'] = fileType
      ..files.add(
        http.MultipartFile(
          'files',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: fileName,
          contentType: MediaType('application', 'octet-stream'),
        ),
      );

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(responseBody);
        if (responseJson['result'] != null) {
          return responseJson['result'];
        } else {
          throw Exception('Result URL not found in response');
        }
      } else {
        throw Exception(
            'Failed to upload file. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error uploading file: $error');
    }
  }

  Future<void> _pickFile(String fileType) async {
    FilePickerResult? result;

    switch (fileType) {
      case 'image':
        result = await FilePicker.platform.pickFiles(type: FileType.image);
        break;
      case 'audio':
        result = await FilePicker.platform.pickFiles(type: FileType.audio);
        break;
      case 'video':
        result = await FilePicker.platform.pickFiles(type: FileType.video);
        break;
      case 'file':
        result = await FilePicker.platform.pickFiles(type: FileType.any);
        break;
    }

    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        await _uploadAndSendFile(filePath, fileType);
      }
    }
  }

  Future<void> _uploadAndSendFile(String filePath, String fileType) async {
    try {
      String fileUrl = await _uploadFile(filePath, fileType);
      print('Uploaded file URL: $fileUrl');
      _sendMessage(fileUrl, fileType.toUpperCase());
    } catch (error) {
      print('Error uploading file: $error');
    }
  }

  Widget _buildMessageItem(Map<String, dynamic> message) {
    bool isUserMessage = message["from"] == widget.userId;

    switch (message['messageType']) {
      case 'IMAGE':
        return _buildImageMessage(message, isUserMessage);
      case 'AUDIO':
      case 'VIDEO':
      case 'FILE':
        return _buildFileMessage(message, isUserMessage);
      default:
        return _buildTextMessage(message, isUserMessage);
    }
  }

  Widget _buildImageMessage(Map<String, dynamic> message, bool isUserMessage) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: CachedNetworkImage(
          imageUrl: message['message'],
          placeholder: (context, url) => Center(child: CircularProgressIndicator(color: AppColors.pink)),
          errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
          fit: BoxFit.cover, // Adjust fit to cover the available space
        ),
      ),
    );
  }

  Widget _buildFileMessage(Map<String, dynamic> message, bool isUserMessage) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: () async {
          final url = message['message']; // URL of the file
          if (await canLaunch(url)) {
            await launch(url, forceWebView: false, forceSafariVC: false);
          } else {
            throw 'Could not launch $url';
          }
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getFileIcon(message['message']), size: 40),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Open file: ${_getFileName(message['message'])}",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Helper method to determine the icon based on file type
  IconData _getFileIcon(String url) {
    if (url.endsWith('.pdf')) return Icons.picture_as_pdf;
    if (url.endsWith('.mp3')) return Icons.audiotrack;
    if (url.endsWith('.mp4')) return Icons.video_library;
    return Icons.file_copy;
  }


  String _getFileName(String url) {
    return url.split('/').last; // Extracts the file name from the URL
  }

  Widget _buildTextMessage(Map<String, dynamic> message, bool isUserMessage) {
    final text = message["message"] ?? "";
    final regex = RegExp(r'(https?://[^\s]+)');
    final matches = regex.allMatches(text);

    final textSpans = <TextSpan>[];

    int lastMatchEnd = 0;
    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        textSpans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: TextStyle(color: isUserMessage ? Colors.white : Colors.black),
        ));
      }
      textSpans.add(TextSpan(
        text: match.group(0),
        style: TextStyle(color: Colors.black),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            final url = match.group(0);
            if (await canLaunch(url!)) {
              await launch(url, forceWebView: false, forceSafariVC: false);
            } else {
              throw 'Could not launch $url';
            }
          },
      ));
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      textSpans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: TextStyle(color: isUserMessage ? Colors.white : Colors.black),
      ));
    }

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          gradient: isUserMessage
              ? const LinearGradient(colors: [Colors.pinkAccent, Colors.pinkAccent])
              : const LinearGradient(colors: [Colors.white, Colors.white]),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12.0),
            topRight: const Radius.circular(12.0),
            bottomLeft: isUserMessage ? const Radius.circular(12.0) : const Radius.circular(0),
            bottomRight: isUserMessage ? const Radius.circular(0) : const Radius.circular(12.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: RichText(
          text: TextSpan(children: textSpans),
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.image),
            onPressed: () => _pickFile('image'),
          ),
          IconButton(
            icon: Icon(Icons.audiotrack),
            onPressed: () => _pickFile('audio'),
          ),
          IconButton(
            icon: Icon(Icons.video_library),
            onPressed: () => _pickFile('video'),
          ),
          IconButton(
            icon: Icon(Icons.file_copy),
            onPressed: () => _pickFile('file'),
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration.collapsed(
                hintText: 'Type a message',
              ),
              onSubmitted: (text) {
                if (!_isSending) {
                  _sendMessage(text, 'MESSAGE');
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.pinkAccent),
            onPressed: () {
              _sendMessage(_textController.text, 'MESSAGE');
              BlocProvider.of<
                  FindMumBloc>(
                  context)
                  .add(CreateNotification(
                  senderId: PrefUtils.getUserId(),
                  receiverId:
                  widget.receiverId,
                  message: 'You have received a new message from ${PrefUtils.getUserName()}.Click to check it out.',
                  title: 'New Message'));
            }
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.image),
              radius: 20,
            ),
            SizedBox(width: 10.0),
            Text(widget.name),
          ],
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildMessageItem(_messages[index]);
              },
            ),
          ),
          _buildTextComposer(),
        ],
      ),
    );
  }
}
