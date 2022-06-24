import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:http/http.dart' as http;

import '../data/data.dart';
import '../widgets/playlist_header.dart';
import '../widgets/tracks_list.dart';

class PlaylistScreen extends StatefulWidget {
  final Playlist playlist;

  const PlaylistScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late ScrollController _sc;
  String jsonTracks = "[]";

  @override
  void initState() {
    super.initState();
    _sc = ScrollController();

    // 스크롤 속도 조절
    _sc.addListener(() {
      const extraSpeed = 10;

      switch (_sc.position.userScrollDirection) {
        case ScrollDirection.forward:
          _sc.jumpTo(max(_sc.offset - extraSpeed, _sc.position.minScrollExtent));
          break;
        case ScrollDirection.reverse:
          _sc.jumpTo(min(_sc.offset + extraSpeed, _sc.position.maxScrollExtent));
          break;
        case ScrollDirection.idle:
          // nothing to do
          break;
      }
    });

    getTracks();
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 140.0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                customBorder: const CircleBorder(),
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_left, size: 28.0),
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                customBorder: const CircleBorder(),
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_right, size: 28.0),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(primary: Theme.of(context).iconTheme.color),
            onPressed: () {},
            icon: Icon(
              Icons.account_circle_outlined,
              size: 30.0,
            ),
            label: Text('treestae'),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            padding: const EdgeInsets.only(),
            onPressed: () {},
            icon: Icon(
              Icons.keyboard_arrow_down,
              size: 30.0,
            ),
          ),
          const SizedBox(width: 20.0),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xffaf1018), Theme.of(context).backgroundColor],
            stops: [0, 0.3],
          ),
        ),
        child: Scrollbar(
          thumbVisibility: true,
          controller: _sc,
          child: ListView(
            controller: _sc,
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
            children: [
              PlaylistHeader(playlist: widget.playlist),
              TracksList(jsonData: jsonTracks),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getTracks() async {
    var data = await http.get(Uri.parse('https://treestae.com/demo/spotify/tracks'));

    setState(() {
      jsonTracks = data.body;
    });
  }
}
