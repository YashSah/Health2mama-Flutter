
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/apis/forums/forums_bloc.dart';
import 'package:intl/intl.dart';

class ForumsDetails extends StatefulWidget {
  const ForumsDetails({Key? key, required this.forumId}) : super(key: key);

  final String forumId;

  @override
  State<ForumsDetails> createState() => _ForumsDetailsState();
}

class _ForumsDetailsState extends State<ForumsDetails> {
  final TextEditingController _replyController = TextEditingController();
  bool _isErrorVisible = false;

  @override
  void initState() {
    super.initState();
    _replyController.addListener(_onTextChanged);
    BlocProvider.of<ForumsBloc>(context).add(ViewForumEvent(widget.forumId));
  }

  @override
  void dispose() {
    _replyController.removeListener(_onTextChanged);
    _replyController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      // Rebuild the widget when text changes
    });
  }

  String formatDate(String createdAt) {
    DateTime parsedDate = DateTime.parse(createdAt);
    String formattedDate = DateFormat('dd MMM yyyy hh:mm a').format(parsedDate);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            'Forum',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            BlocProvider.of<ForumsBloc>(context).add(FetchForums());
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 15, top: 3),
            child: Image.asset(
              'assets/Images/back.png',
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<ForumsBloc, ForumsState>(
          listener: (context, state) {
            if (state is ReplyToForumsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.failureResponse['message']}')),
              );
            } else if (state is CommonServerFailure) {
              Center(
                child: Image.asset('assets/Images/somethingwentwrong.png'),
              );
            } else if (state is CheckNetworkConnection) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No Internet Connection')),
              );
            } else if (state is ReplyToForumsLoaded) {
              _replyController.clear();
              BlocProvider.of<ForumsBloc>(context).add(ViewForumEvent(widget.forumId));
            }
          },
          builder: (context, state) {
            if (state is ViewForumsLoading) {
              return Center(child: CircularProgressIndicator(color: AppColors.pink));
            } else if (state is ViewForumsLoaded) {
              final data = state.successResponse['result'];
              final replies = List<Map<String, dynamic>>.from(data['userReply'] ?? []);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(thickness: 1.2, color: Color(0XFFF6F6F6)),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 75,
                                          height: 75,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Color(0xFF3D94D1),
                                              width: 3,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            backgroundImage: data['userId']['profilePicture'] != null
                                                ? NetworkImage(data['userId']['profilePicture'])
                                                : AssetImage('assets/Images/man.png') as ImageProvider,
                                          ),

                                        ),
                                        SizedBox(width: 20.0),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              (data['userId']['fullName'] != null && data['userId']['fullName'].length > 25)
                                                  ? '${data['userId']['fullName'].substring(0, 25)}...'
                                                  : data['userId']['fullName'] ?? 'Unknown',
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              formatDate(data['createdAt'] ?? 'No date'),
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(
                                        data['topicTitle'] ?? 'No Title',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: Text(
                                        data['description'] ?? 'No Description',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 30, top: 8, bottom: 10),
                            child: Text(
                              '${data['totalReplies'] ?? 0} Replies',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Divider(thickness: 2, color: Color(0XFFF6F6F6)),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: replies.length,
                            itemBuilder: (BuildContext context, int index) {
                              final reply = replies[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          child: CircleAvatar(
                                            backgroundImage: (reply['userId']['profilePicture'] != null && reply['userId']['profilePicture'] is String && reply['userId']['profilePicture'].isNotEmpty)
                                                ? NetworkImage(reply['userId']['profilePicture'])
                                                : const AssetImage('assets/Images/man.png') as ImageProvider,
                                          ),
                                        ),
                                        SizedBox(width: 20.0),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              (reply['userId']['fullName'] ?? 'Unknown').length > 30
                                                  ? (reply['userId']['fullName'].substring(0, 30) + '...')
                                                  : reply['userId']['fullName'] ?? 'Unknown',
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                            ),

                                            Text(
                                              formatDate(reply['createdAt'] ?? ''),
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: Text(
                                        reply['message'] ?? 'No message',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          if (_isErrorVisible)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Text(
                                'Reply cannot be empty.',
                                style: TextStyle(color: Colors.red, fontSize: 14),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      padding: EdgeInsets.all(8),
                      height: 60,
                      child: Center(
                        child: TextField(
                          controller: _replyController,
                          style: TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Add Reply',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            suffixIcon: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _replyController.text.isEmpty
                                    ? Colors.grey
                                    : Color(0xFF3D94D1),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.only(left: 3),
                                onPressed: _replyController.text.isEmpty
                                    ? null // Disable button when text is empty
                                    : () {
                                  if (_replyController.text.isEmpty) {
                                    setState(() {
                                      _isErrorVisible = true;
                                    });
                                  } else {
                                    setState(() {
                                      _isErrorVisible = false;
                                    });
                                    final forumBloc = BlocProvider.of<ForumsBloc>(context);
                                    forumBloc.add(UserReplyEvent(
                                      forumId: widget.forumId,
                                      message: _replyController.text,
                                    ));
                                  }
                                },
                                icon: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset('assets/Images/SendIcon.png', width: 17, height: 17),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is ViewForumsError) {
              return Center(child: Text('Error: ${state.failureResponse}'));
            } else if (state is CommonServerFailure) {
              Center(
                child: Image.asset('assets/Images/somethingwentwrong.png'),
              );
            } else if (state is CheckNetworkConnection) {
              return Center(child: Text('No Internet Connection'));
            }
            return Center(child: CircularProgressIndicator(color: AppColors.pink));
          },
        ),
      ),
    );
  }
}
