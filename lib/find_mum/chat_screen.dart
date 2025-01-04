import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String image;

  const ChatScreen({required this.name, required this.image,super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}



class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _textController = TextEditingController();

  void _sendMessage(String text) {
    if (text.isEmpty) return;

    setState(() {
      _messages.insert(0, {"text": text, "sender": "user"});
    });

    // Simulate a response
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.insert(0, {"text": "${widget.name}: $text", "sender": "bot"});
      });
    });

    _textController.clear();
  }

  Widget _buildMessageItem(Map<String, String> message) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');
    bool isUserMessage = message["sender"] == "user";
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          gradient: isUserMessage
              ? const LinearGradient(colors: [Colors.pinkAccent, Colors.pinkAccent])
              : const LinearGradient(colors: [Colors.white,Colors.white]),
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
        child: Text(
          message["text"] ?? "",
          style: TextStyle(color: isUserMessage ? Colors.white : Colors.black , fontSize: (displayType == 'desktop' || displayType == 'tablet') ? 22 :16.0),
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      margin: const EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              cursorColor: Theme.of(context).primaryColor,

              controller: _textController,
              decoration: InputDecoration(
                hintText: "I want to...",
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(12.0),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              minLines: 1,
              expands: false,

              style:  TextStyle(fontSize: (displayType == 'desktop' || displayType == 'tablet') ? 22 :16.0),
              onSubmitted: _sendMessage,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.pinkAccent),
            onPressed: () => _sendMessage(_textController.text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.only(
                left: (displayType == 'desktop' || displayType == 'tablet')
                    ? 15.h
                    : 15,
                top: (displayType == 'desktop' || displayType == 'tablet')
                    ? 3.h
                    : 3),
            child: Image.asset(
              'assets/Images/back.png', // Replace with your image path
              width: (displayType == 'desktop' || displayType == 'tablet')
                  ? 35.w
                  : 35, // Set width as needed
              height: (displayType == 'desktop' || displayType == 'tablet')
                  ? 35.h
                  : 35, // Set height as needed
            ),
          ),
        ),
        title:  Text("Chat Screen",style: (displayType == 'desktop' || displayType == 'tablet')
            ? FTextStyle.appTitleStyleTablet
            : FTextStyle.appBarTitleStyle),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children:[
          Positioned.fill(
            child: Image.asset(
              "assets/Images/chatbackground.png", // Change to your image path
              fit: BoxFit.cover,
            ),
          ),
          Column(

            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  height: 1,
                  color: AppColors.findMumBorderColor,
                ),
              ),
              Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _buildMessageItem(_messages[index]),
                  itemCount: _messages.length,
                ),
              ),
              const Divider(height: 1.0),
              _buildTextComposer(),
            ],
          ),

        ]

      ),
    );
  }
}
