import 'package:flutter/material.dart';
import 'package:flutter_sound_board/screens/config_screen.dart';
import 'package:provider/provider.dart';
import '../state/settings.dart';
import '../services/utils.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<Settings>(builder: (context, settings, child) {
        return ListView(
          children: <Widget>[
            ListTile(
              title: Text("Show Note Names"),
              trailing: Switch(
                  value: settings.noteNames,
                  onChanged: (value) {
                    settings.showNoteNames(value);
                  }),
            ),
            Divider(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Text("Base Note"),
                      TextButton(
                        onPressed: () => settings.resetBaseNote(),
                        child: Text("Reset"),
                      )
                    ],
                  ),
                  trailing: Text(
                      "${getNoteName(settings.baseNote)}  (${settings.baseNote.toString()})"),
                  // dense: true,
                ),
                Slider(
                  min: 0,
                  max: 112,
                  value: settings.baseNote.toDouble(),
                  onChanged: (value) {
                    settings.baseNote = value.toInt();
                  },
                ),
              ],
            ),
            Divider(),
            Center(
              child: ElevatedButton(
                child: Text("Choose Midi Device"),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ConfigScreen()),
                  );
                },
              ),
            ),
            Divider(),
            Card(
              margin: EdgeInsets.all(10),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Resources:\n\nLogo by 'catalyststuff' [freepik.com]\n      Animated with Rive"),
              ),
            )
          ],
        );
      }),
    );
  }
}