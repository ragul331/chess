import 'package:chess/components/nametile.dart';
import 'package:chess/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PlayersList extends StatefulWidget {
  const PlayersList({super.key});

  @override
  State<PlayersList> createState() => _PlayersListState();
}

class _PlayersListState extends State<PlayersList> {
  final patRef = FirebaseDatabase.instance.ref('players');
  final credentials = FirebaseAuth.instance.currentUser;
  Future getData(players, player) async {
    final snapshot = await patRef.get();
    players = snapshot.value as Map;
    players.forEach((key, value) {
      player.add(value);
    });
    return snapshot;
  }

  String santizedMail(String mail) {
    String removed = '';
    for (int i = 0; i < mail.length; i++) {
      if (mail[i] == '.') {
        continue;
      } else {
        removed += mail[i];
      }
    }
    return removed;
  }

  void challengePlayer(String mail) async {
    final snapshot = await patRef.get();

    Map allPlayer = snapshot.value as Map;
    Map challengedPlayer = allPlayer[mail];
    Map<String, Object?> newMap = {};
    List challengers = [];
    if (challengedPlayer.containsKey('challenge')) {
      for (int i = 0; i < challengedPlayer['challenge'].length; i++) {
        challengers.add(challengedPlayer['challenge'][i]);
      }
    }
    challengers.add([mail, false]);
    challengedPlayer.update('challange', (value) {
      return challengers;
    }, ifAbsent: () {
      return challengers;
    });
    challengedPlayer.forEach((key, value) {
      newMap[key.toString()] = value;
    });
    print({mail: newMap});
  }

  void logout(NavigatorState navigator) async {
    await FirebaseAuth.instance.signOut();
    navigator.pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return const LogIn();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map players = {};
    List player = [];
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Players'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                logout(navigator);
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: FutureBuilder(
        future: getData(players, player),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
                itemCount: player.length,
                itemBuilder: (context, index) {
                  if (credentials!.email == player[index]['mail'] || player[index]['mail']=='admin@vsbec.com') {
                    return Container();
                  } else {
                    return GestureDetector(
                      onTap: () {
                        return challengePlayer(
                            santizedMail(player[index]['mail']));
                      },
                      child: NameCard(
                          name: player[index]['name'],
                          mailId: player[index]['mail']),
                    );
                  }
                });
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const Text('Some Error Ocuured');
        },
      ),
    );
  }
}
