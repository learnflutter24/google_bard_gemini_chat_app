import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/material.dart';
import '../model/MessageModel.dart';
import '../widgets/card.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  static const kValue = 15.0;
  final textController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final apiKey = 'AIzaSyC38wegJI4lw29sRvt9NcZwyqOX3X5Qgls';
  final messages = [MessageModel(true, 'Hi')];
  bool isBotTyping = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Bard/Gemini in Flutter'),
          centerTitle: true,
          leading: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/Google_Icon.png'),
            ),
          ),
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final isBot = messages[index].isBot;
                    final alignment =
                        isBot ? Alignment.centerLeft : Alignment.centerRight;
                    return Align(
                      alignment: alignment,
                      child: card(
                        index: index,
                        alignment: alignment,
                        isBot: isBot,
                        message: messages[index].message.trim(),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: kValue / 2,
                    vertical: kValue / 1.5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(kValue),
                      topLeft: Radius.circular(kValue),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.23),
                        offset: const Offset(kValue / 1.2, .5),
                        blurRadius: kValue,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.12),
                            borderRadius: BorderRadius.circular(kValue * 3.33),
                          ),
                          child: TextFormField(
                            controller: textController,
                            autofocus: true,
                            decoration: const InputDecoration(
                              hintText: 'Enter question here',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(kValue),
                            ),
                            textInputAction: TextInputAction.send,
                            validator: (value) =>
                                value!.isEmpty ? 'Enter some question' : null,
                          ),
                        ),
                      ),
                      isBotTyping
                          ? Transform.scale(
                              scale: 0.8,
                              child: const CircularProgressIndicator(
                                strokeWidth: 5,
                                color: Color(0xff0360a6),
                              ),
                            )
                          : GestureDetector(
                              onTap: askQuestion,
                              child: Container(
                                margin: const EdgeInsets.all(kValue / 2),
                                width: kValue * 3,
                                height: kValue * 3,
                                decoration: BoxDecoration(
                                  color: const Color(0xff0360a6),
                                  borderRadius:
                                      BorderRadius.circular(kValue * 3.33),
                                ),
                                child: const Icon(
                                  Icons.send,
                                  size: kValue * 1.6,
                                  color: Color(0xffffffff),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );

  void askQuestion() async {
    if (formKey.currentState!.validate()) {
      setState(() => isBotTyping = true);
      try {
        final model = GenerativeModel(model: 'gemini-1.0-pro', apiKey: apiKey);
        final response = await model.generateContent(
          [
            Content.text(textController.text),
          ],
        );
        debugPrint('response.text :${response.text}');
        setState(() {
          messages.add(
            MessageModel(false, textController.text),
          );
          textController.clear();
          messages.add(
            MessageModel(true, response.text!),
          );
          isBotTyping = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'),
            dismissDirection: DismissDirection.horizontal,
          ),
        );
        debugPrint('$e');
      }
    }
  }
}
