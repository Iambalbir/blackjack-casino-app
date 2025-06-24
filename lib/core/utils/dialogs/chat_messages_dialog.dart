import '../../../export_file.dart';

class ChatDialog extends StatefulWidget {
  final void Function(String message) onSend;
  MultiPlayerBlackjackBloc bloc;

  ChatDialog({
    Key? key,
    required this.onSend,
    required this.bloc,
  }) : super(key: key);

  @override
  _ChatDialogState createState() => _ChatDialogState();
}

class _ChatDialogState extends State<ChatDialog> {
  TextEditingController textEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextView(
                      text: 'LOBBY CHAT',
                      textStyle: textStyleHeadingMedium(context).copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                    tooltip: 'Close chat',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Messages List
            Expanded(
              child: BlocBuilder<MultiPlayerBlackjackBloc,
                  MultiplayerBlackjackState>(
                bloc: widget.bloc,
                builder: (context, state) {
                  final chatMessages = state.chatListing;
                  // Scroll to the bottom when new messages arrive
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController
                          .jumpTo(_scrollController.position.minScrollExtent);
                    }
                  });
                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                        vertical: margin_8, horizontal: margin_10),
                    itemCount: chatMessages.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final msg = chatMessages[index];
                      final isCurrentUser =
                          msg['senderUid'] == currentUserModel.uid;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Align(
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: IntrinsicWidth(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6,
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: margin_10, vertical: margin_5),
                                decoration: BoxDecoration(
                                  color: isCurrentUser
                                      ? Colors.greenAccent.shade700
                                          .withOpacity(0.85)
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(margin_10),
                                    topRight: Radius.circular(margin_10),
                                    bottomLeft: Radius.circular(
                                        isCurrentUser ? margin_10 : margin_1),
                                    bottomRight: Radius.circular(
                                        isCurrentUser ? margin_1 : margin_10),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 3,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: isCurrentUser
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!isCurrentUser)
                                      Padding(
                                        padding:
                                            EdgeInsets.only(bottom: margin_2),
                                        child: TextView(
                                          text: msg['senderName'] ?? '',
                                          textStyle: textStyleBodySmall(context)
                                              .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: font_10,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    TextView(
                                      text: msg['message'] ?? '',
                                      textStyle:
                                          textStyleBodyMedium(context).copyWith(
                                        fontSize: font_14,
                                        color: isCurrentUser
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Bottom input with send button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * .65,
                    height: MediaQuery.sizeOf(context).height * .08,
                    child: TextField(
                      controller: textEditingController,
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          widget.onSend(value);
                          textEditingController.clear();
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Type a message…',
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: textStyleBodyMedium(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      if (textEditingController.text.isNotEmpty) {
                        widget.onSend(textEditingController.text);
                        textEditingController.clear();
                      }
                    },
                    borderRadius: BorderRadius.circular(radius_25),
                    child: Container(
                      padding: EdgeInsets.all(margin_10),
                      decoration: BoxDecoration(
                        color: kBackground,
                        borderRadius: BorderRadius.circular(radius_35),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: font_24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
