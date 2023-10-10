import 'package:chess/board_offline.dart';
import 'package:chess/pages/players.dart';
import 'package:flutter/material.dart';

class PlayerMode extends StatefulWidget {
  const PlayerMode({super.key});

  @override
  State<PlayerMode> createState() => _PlayerModeState();
}

class _PlayerModeState extends State<PlayerMode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: double.infinity,
          ),
          TextButton(
            style: ButtonStyle(
              textStyle: const MaterialStatePropertyAll(
                TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              side: const MaterialStatePropertyAll(
                  BorderSide(color: Colors.black)),
              minimumSize: const MaterialStatePropertyAll(
                Size(150, 53),
              ),
              backgroundColor: MaterialStatePropertyAll(
                Colors.grey[300],
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const GameBoardOf();
                  },
                ),
              );
            },
            child: const Text(
              'Player vs Player',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            style: ButtonStyle(
              textStyle: const MaterialStatePropertyAll(
                TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              side: const MaterialStatePropertyAll(
                  BorderSide(color: Colors.black)),
              minimumSize: const MaterialStatePropertyAll(
                Size(150, 53),
              ),
              backgroundColor: MaterialStatePropertyAll(
                Colors.grey[300],
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const PlayersList();
              }));
            },
            child: const Text(
              'Play Online',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
