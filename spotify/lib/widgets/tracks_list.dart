import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spotify_ui/models/current_track.dart';
import 'package:provider/provider.dart';

import '../data/data.dart';

class TracksList extends StatelessWidget {
  late final List<Song> tracks;

  TracksList({Key? key, dynamic jsonData}) : super(key: key) {
    List<dynamic> parsedJson = jsonDecode(jsonData);

    // print(parsedJson);
    tracks = parsedJson.map((e) => Song.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingTextStyle: Theme.of(context).textTheme.overline!.copyWith(fontSize: 12.0),
      dataRowHeight: 54.0,
      showCheckboxColumn: false,
      columns: const [
        DataColumn(label: Text('TITLE')),
        DataColumn(label: Text('ARTIST')),
        DataColumn(label: Text('ALBUM')),
        DataColumn(label: Icon(Icons.access_time)),
      ],
      rows: tracks.map((e) {
        final selected = context.watch<CurrentTrackModel>().selected?.id == e.id;
        final textStyle = TextStyle(
          color: (selected ? Theme.of(context).colorScheme.secondary : Theme.of(context).iconTheme.color),
        );

        return DataRow(
          cells: [
            DataCell(Text(e.title, style: textStyle)),
            DataCell(Text(e.artist, style: textStyle)),
            DataCell(Text(e.album, style: textStyle)),
            DataCell(Text(e.duration, style: textStyle)),
          ],
          selected: selected,
          onSelectChanged: (_) => context.read<CurrentTrackModel>().selectTrack(e),
        );
      }).toList(),
    );
  }
}
