import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/chat.dart';
import '../../injection_container.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/user/user_bloc.dart';
import 'chat_detail_page.dart';

class ChatListScreen extends StatelessWidget {
  final String currentUserId;

  const ChatListScreen({super.key, required this.currentUserId});

  static Widget withBloc({required String currentUserId}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => chatSl<ChatBloc>()..add(LoadChatsEvent())),
        BlocProvider(
          create: (_) =>
              chatSl<UserBloc>()..add(LoadUsersEvent()), // This is needed
        ),
      ],
      child: ChatListScreen(currentUserId: currentUserId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3081F2),
      body: SafeArea(
        child: BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatInitiated) {
              final otherUser = state.chat.user1.id == currentUserId
                  ? state.chat.user2
                  : state.chat.user1;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatDetailScreen.withBloc(
                    chatId: state.chat.id,
                    currentUserId: currentUserId,
                    otherUserId: otherUser.id,
                    otherUserName: otherUser.name,
                  ),
                ),
              );
            } else if (state is ChatError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: Column(
            children: [
              // Top Row - List of Users
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          if (state is UserLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is UsersLoaded) {
                            return StatusAvatars(
                              users: state.users,
                              currentUserId: currentUserId,
                            );
                          } else if (state is UserError) {
                            return Text(
                              state.message,
                              style: const TextStyle(color: Colors.white),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Chat List Container
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is ChatLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ChatsLoaded) {
                        return ChatList(
                          chats: state.chats,
                          currentUserId: currentUserId,
                        );
                      } else if (state is ChatError) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusAvatars extends StatelessWidget {
  final List<User> users;
  final String currentUserId;

  const StatusAvatars({
    super.key,
    required this.users,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final otherUsers = users.where((u) => u.id != currentUserId).toList();

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: otherUsers.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final user = otherUsers[index];
          return InkWell(
            onTap: () {
              context.read<ChatBloc>().add(InitiateChatEvent(userId: user.id));
            },
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage('images/profile.png'),
                ),
                const SizedBox(height: 4),
                Text(
                  user.name,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ChatList extends StatelessWidget {
  final List<Chat> chats;
  final String currentUserId;

  const ChatList({super.key, required this.chats, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: chats.length,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final chat = chats[index];
        final otherUser = chat.user1.id == currentUserId
            ? chat.user2
            : chat.user1;

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatDetailScreen.withBloc(
                  chatId: chat.id,
                  currentUserId: currentUserId,
                  otherUserId: otherUser.id,
                  otherUserName: otherUser.name,
                ),
              ),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('images/profile.png'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  otherUser.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
