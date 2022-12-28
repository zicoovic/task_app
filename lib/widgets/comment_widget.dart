import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final List<Color> _colors = [
    Colors.orangeAccent,
    Colors.pink,
    Colors.amber,
    Colors.purple,
    Colors.brown,
    Colors.blue,
  ];

  CommentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    _colors.shuffle();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          width: 5,
        ),
        Flexible(
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: _colors[3],
              ),
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: NetworkImage(
                  'https://cdn-icons-png.flaticon.com/512/1077/1077012.png',
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Commenter name',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Comment body',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
