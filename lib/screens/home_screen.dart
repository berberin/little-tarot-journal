import 'package:flutter/material.dart';
import 'package:little_tarot_journal/components/tarot_container.dart';

class HomeScreen extends StatefulWidget {
  static String id = "HomeScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.red,
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: TarotImageContainer(),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
