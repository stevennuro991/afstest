import 'package:afs_test/utils/constants.dart';
import 'package:afs_test/utils/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFormFieldChat extends StatelessWidget {
  final TextEditingController chatController;
  final Function() btnFun;
  const TextFormFieldChat(
      {super.key, required this.chatController, required this.btnFun});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 12,
          left: 20,
          right: 12,
          bottom: 50,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                cursorColor: kPrimaryWhite,
                controller: chatController,
                autofocus: true,
                style: GoogleFonts.poppins(color: kPrimaryWhite, fontSize: 20),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.8)),
                        borderRadius: kBoxRadius(5)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.8)),
                        borderRadius: kBoxRadius(5)),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.8),
                    hintText: 'Ask me anything you want',
                    hintStyle: GoogleFonts.poppins(color: kPrimaryWhite)),
              ),
            ),
            xBox(10),
            Container(
              color: kGreen,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                    icon: Icon(Icons.send_rounded), onPressed: btnFun),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TypewriterText extends StatefulWidget {
  final String text;
  final Duration duration;

  const TypewriterText(
      {Key? key,
      required this.text,
      this.duration = const Duration(milliseconds: 50)})
      : super(key: key);

  @override
  _TypewriterTextState createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(
          milliseconds: widget.duration.inMilliseconds * widget.text.length),
      vsync: this,
    );

    _animation =
        IntTween(begin: 0, end: widget.text.length).animate(_controller)
          ..addListener(() {
            setState(() {});
          });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String displayedText = widget.text.substring(0, _animation.value);
    return Text(
      displayedText,
      style: GoogleFonts.poppins(color: Colors.white),
    );
  }
}
