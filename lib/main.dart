import 'package:flutter/material.dart';

void main() {
  runApp(const WhatsAppChatApp());
}

class WhatsAppChatApp extends StatelessWidget {
  const WhatsAppChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ChatScreen(),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isOutgoing;
  final String time;

  ChatMessage({
    required this.text,
    required this.isOutgoing,
    required this.time,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const Color bgDark = Color(0xFF181818);
  static const Color greenAccent = Color(0xFF168C4B);
  static const Color incomingBubbleColor = Color(0xFF232D36);

  final TextEditingController _messageController = TextEditingController();

  final List<ChatMessage> _messages = [
    ChatMessage(text: "Hello !", isOutgoing: false, time: "10:00 AM"),
    ChatMessage(text: "Hello !", isOutgoing: true, time: "10:01 AM"),
    ChatMessage(
      text:
          "Hey! Have you ever thought about how random moments can sometimes turn into the best memories? It's like the universe loves to surprise us when we least expect it!",
      isOutgoing: false,
      time: "10:02 AM",
    ),
    ChatMessage(
      text: "what a Great Content To learn Flutter",
      isOutgoing: false,
      time: "10:03 AM",
    ),
    ChatMessage(
      text: "What a Great Content To learn Flutter",
      isOutgoing: true,
      time: "10:04 AM",
    ),
  ];

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final now = TimeOfDay.now();
    final timeString =
        "${now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod}:${now.minute.toString().padLeft(2, '0')} ${now.period == DayPeriod.am ? 'AM' : 'PM'}";

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isOutgoing: true,
          time: timeString,
        ),
      );
    });

    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: bgDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        titleSpacing: 0,
        title: Row(
          children: const [
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images.jpeg'),
            ),
            SizedBox(width: 10),
            Text(
              'Laila Ali',
              style: TextStyle(
                color: greenAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: bgDark,
          image: DecorationImage(
            image: AssetImage('assets/im.jpeg'),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildBubble(message);
                },
              ),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBubble(ChatMessage message) {
    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.75;

    return Align(
      alignment:
          message.isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(maxWidth: maxBubbleWidth),
        decoration: BoxDecoration(
          color: message.isOutgoing ? greenAccent : incomingBubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: message.isOutgoing
                ? const Radius.circular(12)
                : Radius.zero,
            bottomRight: message.isOutgoing
                ? Radius.zero
                : const Radius.circular(12),
          ),
        ),
        child: Wrap(
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            Text(
              message.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.time,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 10,
                    ),
                  ),
                  if (message.isOutgoing) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.done_all,
                      size: 14,
                      color: Colors.blueAccent,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                prefixIcon: const Icon(Icons.camera_alt, color: Colors.white54),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: greenAccent),
                  onPressed: _sendMessage,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                filled: true,
                fillColor: incomingBubbleColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: greenAccent, width: 1),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            decoration: const BoxDecoration(
              color: greenAccent,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.mic, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}