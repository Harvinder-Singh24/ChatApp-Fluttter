import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  String message;
  String sender;
  final bool sendByMe;
  MessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.sendByMe})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: widget.sendByMe ? 0 : 10,
        right: widget.sendByMe ? 10 : 0,
      ),
      child: Container(
        margin: widget.sendByMe
            ? const EdgeInsets.only(left: 120)
            : const EdgeInsets.only(right: 120),
        padding:
            const EdgeInsets.only(top: 17, left: 20, bottom: 17, right: 20),
        decoration: BoxDecoration(
            borderRadius: widget.sendByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
            color: widget.sendByMe
                ? Theme.of(context).primaryColor
                : Colors.grey[700]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.sender.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
