import 'package:flutter/material.dart';

class ChatDetailScreen extends StatelessWidget {
  const ChatDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage(
              'images/profile.png',
            ), // Replace with your image
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sabila Sayma',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Text(
              '8 members, 5 online',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.call, color: Colors.black),
          SizedBox(width: 15),
          Icon(Icons.videocam, color: Colors.black),
          SizedBox(width: 15),
          Icon(Icons.more_vert, color: Colors.black),
          SizedBox(width: 10),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Incoming message (Text)
                chatBubble(
                  isMe: false,
                  text: 'Have a great working week!',
                  time: '09:25 AM',
                  avatar: 'images/profile.png',
                ),

                // Incoming message (Image)
                chatBubble(
                  isMe: false,
                  text: '',
                  time: '09:25 AM',
                  avatar: 'assets/profile.png',
                  image: 'images/profile.png', // Replace with your image
                ),

                // Outgoing message (You)
                chatBubble(
                  isMe: true,
                  text: 'You did your job well',
                  time: '09:25 AM',
                  avatar: 'images/profile.png',
                ),

                // Incoming message (Audio)
                chatBubble(
                  isMe: false,
                  text: '',
                  time: '09:26 AM',
                  avatar: 'images/profile.png',
                  audioDuration: '00:16',
                ),

                // Outgoing message (Repeat)
                chatBubble(
                  isMe: true,
                  text: 'You did your job well',
                  time: '09:26 AM',
                  avatar: 'images/profile.png',
                ),
              ],
            ),
          ),

          // Bottom Chat Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Write your message',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Icon(Icons.attach_file, color: Colors.grey),
                SizedBox(width: 10),
                Icon(Icons.send, color: Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget chatBubble({
    required bool isMe,
    required String text,
    required String time,
    required String avatar,
    String? image,
    String? audioDuration,
  }) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMe)
          CircleAvatar(radius: 16, backgroundImage: AssetImage(avatar)),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                padding: image != null || audioDuration != null
                    ? const EdgeInsets.all(0)
                    : const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isMe
                      ? const Color(0xFF4D8EFF)
                      : const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: isMe ? const Radius.circular(18) : Radius.zero,
                    bottomRight: isMe ? Radius.zero : const Radius.circular(18),
                  ),
                ),
                child: image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          image,
                          width: 200,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      )
                    : audioDuration != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.play_arrow,
                            color: isMe ? Colors.white : Colors.black,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 80,
                            height: 4,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            audioDuration,
                            style: TextStyle(
                              fontSize: 12,
                              color: isMe ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        text,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                          fontSize: 14,
                        ),
                      ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        if (isMe) CircleAvatar(radius: 16, backgroundImage: AssetImage(avatar)),
      ],
    );
  }
}
