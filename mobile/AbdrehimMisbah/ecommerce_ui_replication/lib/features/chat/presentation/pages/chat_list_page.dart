import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3081F2),
      body: SafeArea(
        child: Column(
          children: [
            // Top Row - Status Avatars
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(children: [Expanded(child: StatusAvatars())]),
            ),

            // Chat List Container
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: const ChatList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusAvatars extends StatelessWidget {
  const StatusAvatars({super.key});

  @override
  Widget build(BuildContext context) {
    final users = ['My status', 'Adil', 'Marina', 'Dean', 'Max'];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: users.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return Column(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundImage: AssetImage('images/profile.png'),
              ),
              const SizedBox(height: 4),
              Text(
                users[index],
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    final chatData = [
      {
        'name': 'Alex Linderson',
        'message': 'How are you today?',
        'time': '2 min ago',
        'unread': 3,
      },
      {
        'name': 'Team Align',
        'message': 'Don’t miss to attend the meeting.',
        'time': '2 min ago',
        'unread': 4,
      },
      {
        'name': 'John Ahraham',
        'message': 'Hay! Can you join the meeting?',
        'time': '2 min ago',
        'unread': 0,
      },
      {
        'name': 'Sabila Sayma',
        'message': 'How are you today?',
        'time': '2 min ago',
        'unread': 0,
      },
      {
        'name': 'John Borino',
        'message': 'Have a good day 🌸',
        'time': '2 min ago',
        'unread': 1,
      },
      {
        'name': 'Angel Dayna',
        'message': 'How are you today?',
        'time': '2 min ago',
        'unread': 0,
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: chatData.length,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final chat = chatData[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('images/profile.png'),
            ),
            const SizedBox(width: 12),
            // Name & Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat['name']! as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat['message']! as String,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            // Time & Unread
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat['time']! as String,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                if (chat['unread']! as int > 0)
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3081F2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      chat['unread'].toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
