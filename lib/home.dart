import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<String> _notes = [
    "A thin horizontal line, with padding on either side.",
    "In the Material Design language, this represents a divider. Dividers can be used in lists, Drawers, and elsewhere to separate content.",
    "This sample shows how to display a Divider between an orange and blue box inside a column. The Divider is 20 logical pixels in height and contains a vertically centered black line that is 5 logical pixels thick. The black line is indented by 20 logical pixels.",
    "The box's total height is controlled by height. The appropriate padding is automatically computed from the height.",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showNoteOptions(BuildContext context, int index) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 100,
        50.0 + index * 60.0,
        MediaQuery.of(context).size.width,
        100.0 + index * 60.0,
      ),
      items: <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'edit',
          child: Text('Modifier'),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Text('Supprimer'),
        ),
      ],
    ).then((value) {
      if (value == 'edit') {
        // edit
      } else if (value == 'delete') {
        setState(() {
          // delete
        });
      }
    });
  }

  static const TextStyle _notePreviewTextStyle = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      const Text('home', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ListView.builder(
        itemCount: _notes.length * 2 - 1,
        itemBuilder: (context, index) {
          if (index.isOdd) {
            return const Divider(height: 20, thickness: 1, indent: 15, endIndent: 20, color: Colors.grey);
          }
          final noteIndex = index ~/ 2;
          final note = _notes[noteIndex];
          final preview = note.length > 50 ? '${note.substring(0, 50)}...' : note;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(preview, style: _notePreviewTextStyle),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _showNoteOptions(context, noteIndex),
                ),
              ],
            ),
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('lala'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(title: const Text('User Profile')),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Text(
                      'Nouvelle note',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    const TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: '...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                       // save
                        Navigator.pop(context);
                      },
                      child: const Text('Enregistrer'),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              );
            },
          );
        },
        tooltip: 'Ajouter une note',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: 'Notes',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}