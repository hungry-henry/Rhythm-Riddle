import 'package:flutter/material.dart';
import '/generated/l10n.dart';
import 'package:http/http.dart' as http;

class SinglePlayer extends StatefulWidget {
  const SinglePlayer({super.key});

  @override
  State<SinglePlayer> createState() => _SinglePlayerState();
}

class _SinglePlayerState extends State<SinglePlayer> {
  int playlistId = 0;
  String playlistTitle = '';
  String createTime = '';
  String createdBy = '';
  String musicTitle = '';
  String artist = '';
  int musicCount = 0;
  String? description;

  int selectedDifficulty = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final Map args = ModalRoute.of(context)?.settings.arguments as Map;
      setState(() {
        playlistId = args["id"];
        playlistTitle = args["title"];
        createTime = args["createTime"];
        createdBy = args["createdBy"];
        musicTitle = args["musicTitle"];
        artist = args["artist"];
        description = args["description"];
        musicCount = args["count"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${S.current.singlePlayer}: $playlistTitle")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Left Column
            Column(
              children: [
                // Playlist Image
                playlistId == 0 ? const Center(child: CircularProgressIndicator()) : Image.network(
                  "http://hungryhenry.xyz/musiclab/playlist/$playlistId.jpg",
                  width: 350,
                  height: 350,
                ),
                SizedBox(height: 8),
                // Date and Username
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(createTime, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 16),
                    Text(createdBy, style: const TextStyle(fontSize: 14)),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  playlistTitle,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                // Song Info
                Text(
                  S.current.contains( musicCount, musicTitle, artist),
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                // Description
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(
                    description ?? S.current.noDes,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            // Right Column - Difficulty
             Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDifficulty = 0;
                        });
                      },
                      child: Container(
                        width: 80,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: selectedDifficulty == 0 ? Colors.blue : Colors.grey[300],
                          border: Border.all(color: Colors.grey),
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            S.current.easy,
                            style: TextStyle(
                              color: selectedDifficulty == 0 ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDifficulty = 1;
                        });
                      },
                      child: Container(
                        width: 80,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: selectedDifficulty == 1 ? Colors.blue : Colors.grey[300],
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Text(
                            S.current.normal,
                            style: TextStyle(
                              color: selectedDifficulty == 1 ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDifficulty = 2;
                        });
                      },
                      child: Container(
                        width: 80,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: selectedDifficulty == 2 ? Colors.blue : Colors.grey[300],
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Text(
                            S.current.hard,
                            style: TextStyle(
                              color: selectedDifficulty == 2 ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDifficulty = 3;
                        });
                      },
                      child: Container(
                        width: 80,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: selectedDifficulty == 3 ? Colors.blue : Colors.grey[300],
                          border: Border.all(color: Colors.grey),
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            S.current.custom,
                            style: TextStyle(
                              color: selectedDifficulty == 3 ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    )
                  ]
                ),
                SizedBox(height: 20),
                if(selectedDifficulty != 3) ... [
                  Text(
                    selectedDifficulty == 0 ? S.current.easyInfo : selectedDifficulty == 1 ? S.current.normalInfo : S.current.hardInfo,
                    style: TextStyle(fontSize: 18),
                    softWrap: true,
                  ),
                ] else ... [
                  //blahblah
                ],
                ElevatedButton(onPressed: (){}, child: Text('开始游戏'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SinglePlayerGame extends StatefulWidget {
  const SinglePlayerGame({super.key});

  @override
  State<SinglePlayerGame> createState() => _SinglePlayerGameState();
}

class _SinglePlayerGameState extends State<SinglePlayerGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hi")
      )
    );
  }
}