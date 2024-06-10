import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:you_to_do/components/methods/database.dart';
import 'package:you_to_do/first.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late BuildContext contextNew = context;
  final noteController = TextEditingController();
  final searchController = TextEditingController();
  String searchText = '';
  Tag? selectedTag;
  String filteringDropdownValue = 'All';
  String sortingDropdownValue = 'newest';

  List<Tag> availableTags = [
    Tag(name: 'Home', color: Colors.blue),
    Tag(name: 'Work', color: Colors.green),
    Tag(name: 'Personal', color: Colors.red)
  ];

  // funkcija za uzimanje boje taga
  Color? findTagColor(String tagName, List<Tag> tags) {
    final tag = tags.firstWhere((tag) => tag.name == tagName,
        orElse: () => Tag(name: '', color: Colors.black));
    return tag.color;
  }

  List<Map<String, String>> sortingOptions = [
    {'value': 'newest', 'label': 'Newest Added'},
    {'value': 'oldest', 'label': 'Oldest Added'},
    {'value': 'az', 'label': 'A-Z'},
    {'value': 'za', 'label': 'Z-A'},
  ];

  // dialog za odabir tagova kod unosa biljeske
  void showTagSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select a tag', textAlign: TextAlign.center),
          titleTextStyle: GoogleFonts.ubuntu(color: Colors.black, fontSize: 28),
          children: [
            SingleChildScrollView(
              child: Column(
                children: availableTags.map((tag) {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(tag.name),
                        if (selectedTag == tag)
                          const Icon(Icons.check,
                              color: Colors.black, size: 20),
                      ],
                    ),
                    titleTextStyle: GoogleFonts.ubuntu(
                        color: findTagColor(tag.name, availableTags),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    onTap: () {
                      setState(() {
                        selectedTag = tag;
                      });
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    final uid = user!.uid;
    final String email = user.email!;

    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Image.asset('lib/images/you_to_do.png', height: 50, width: 50),
          centerTitle: true,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return PopScope(
                    canPop: false,
                    child: AlertDialog(
                      title: const Text('Warning', textAlign: TextAlign.center),
                      titleTextStyle: GoogleFonts.ubuntu(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 28),
                      content: Text(
                          'Are you sure you want to log out from the account with the email address: $email?',
                          textAlign: TextAlign.justify),
                      contentTextStyle: GoogleFonts.ubuntu(
                          color: Colors.black, fontSize: 16, height: 1.5),
                      backgroundColor: Colors.white,
                      actionsPadding:
                          const EdgeInsets.only(bottom: 10, right: 10),
                      actions: [
                        TextButton(
                          child: const Text('Yes',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                          onPressed: () async {
                            await _auth.signOut();

                            if (mounted) {
                              Navigator.pushAndRemoveUntil(
                                  contextNew,
                                  MaterialPageRoute(
                                      builder: (context) => const FirstPage()),
                                  (route) => false);
                            }
                          },
                        ),
                        TextButton(
                          child: const Text('No',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 225, 255, 245),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: const Color.fromARGB(255, 225, 255, 245),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // container s textfieldom za search
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchText = value.toLowerCase();
                        });
                      },
                      controller: searchController,
                      style: GoogleFonts.ubuntu(),
                      decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.black),
                          border: InputBorder.none,
                          hintText: 'Search for a note',
                          hintStyle: GoogleFonts.ubuntu()),
                    ),
                  ),

                  // prazan prostor
                  const SizedBox(height: 20),

                  // red s tekstom i tipkama za sortiranje te filtriranje
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // notes tekst
                      Text(
                        'notes',
                        style: GoogleFonts.ubuntu(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // red s tipkama za sortiranje te filtriranje prema tagovima
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // tipka za sortiranje
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.sort),
                            iconColor: Colors.black,
                            color: Colors.white,
                            itemBuilder: (BuildContext context) {
                              return sortingOptions.map((option) {
                                return PopupMenuItem<String>(
                                  value: option['value'],
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        option['label']!,
                                        style: GoogleFonts.ubuntu(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (sortingDropdownValue ==
                                          option['value'])
                                        const Icon(Icons.check,
                                            size: 16, color: Colors.black),
                                    ],
                                  ),
                                );
                              }).toList();
                            },
                            onSelected: (String? newValue) {
                              setState(() {
                                sortingDropdownValue = newValue!;
                              });
                            },
                          ),

                          // tipka za filtriranje prema tagu
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.label),
                            iconColor: Colors.black,
                            color: Colors.white,
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem<String>(
                                  value: 'All',
                                  child: Row(
                                    children: [
                                      Text('All',
                                          style: GoogleFonts.ubuntu(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                ...availableTags.map(
                                  (tag) {
                                    return PopupMenuItem<String>(
                                      value: tag.name,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(tag.name,
                                              style: GoogleFonts.ubuntu(
                                                  color: findTagColor(
                                                      tag.name, availableTags),
                                                  fontWeight: FontWeight.bold)),
                                          if (filteringDropdownValue ==
                                              tag.name)
                                            const Icon(Icons.check, size: 16),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ];
                            },
                            onSelected: (String? newValue) {
                              setState(
                                () {
                                  filteringDropdownValue = newValue ?? '';
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // izgled biljeski kad se dodaju i prikaz biljeski uz filtere
            Expanded(
              child: StreamBuilder(
                stream:
                    DatabaseService(uid: uid).getNotes(sortingDropdownValue),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.black));
                  }

                  // koristenje biljeski iz snapshota, filtriranje prema searchu i tagu
                  final List<QueryDocumentSnapshot> filteredNotes =
                      snapshot.data!.docs.where((note) {
                    final String noteText = note['text'].toLowerCase();
                    final String noteTag = note['tag'];

                    // filtriranje po unesenom tekstu u searchu
                    final bool searchTextMatch =
                        noteText.contains(searchText.toLowerCase());

                    // filtriranje prema odabranom tagu
                    final bool tagMatch = filteringDropdownValue == 'All' ||
                        noteTag == filteringDropdownValue;

                    return searchTextMatch && tagMatch;
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredNotes.length,
                    itemBuilder: (BuildContext context, int index) {
                      final DocumentSnapshot note = filteredNotes[index];

                      return Container(
                        margin: const EdgeInsets.only(
                            bottom: 20, left: 20, right: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            IconButton(
                                icon: Icon(
                                  note['isDone']
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: Colors.green,
                                ),
                                onPressed: () async {
                                  bool isDone = !note['isDone'];
                                  await DatabaseService(uid: uid)
                                      .updateNoteIsDone(note.id, isDone);
                                }),
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  '${note['text']}',
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 18,
                                    color: Colors.black,
                                    decoration: note['isDone']
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      '${note['tag']}',
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 12,
                                        color: findTagColor(
                                            note['tag'], availableTags),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${note['formattedDateTime']}',
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              color: Colors.red,
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return PopScope(
                                      canPop: false,
                                      child: AlertDialog(
                                        title: const Text('Warning',
                                            textAlign: TextAlign.center),
                                        titleTextStyle: GoogleFonts.ubuntu(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28),
                                        content: const Text(
                                            'Are you sure you want to delete this note?',
                                            textAlign: TextAlign.justify),
                                        contentTextStyle: GoogleFonts.ubuntu(
                                            color: Colors.black,
                                            fontSize: 16,
                                            height: 1.5),
                                        backgroundColor: Colors.white,
                                        actionsPadding: const EdgeInsets.only(
                                            bottom: 10, right: 10),
                                        actions: [
                                          TextButton(
                                            child: const Text('Yes',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20)),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              await DatabaseService(uid: uid)
                                                  .deleteNote(note.id);
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('No',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // container s unosom teksta biljeski, tipkom za dodavanje taga i tipkom za unos
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(color: Colors.grey, blurRadius: 10.0)
                ],
              ),
              child: TextField(
                minLines: 1,
                maxLines: 6,
                controller: noteController,
                style: GoogleFonts.ubuntu(),
                decoration: InputDecoration(
                  hintText: 'Add a new note',
                  hintStyle: GoogleFonts.ubuntu(),
                  border: InputBorder.none,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.new_label),
                        color: Colors.black,
                        onPressed: () {
                          showTagSelectionDialog(context);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_box),
                        color: Colors.black,
                        onPressed: () async {
                          String trimmedText = noteController.text.trim();
                          // ako su uneseni tekst i tag, dodaje se biljeska
                          if (trimmedText.isNotEmpty && selectedTag != null) {
                            await DatabaseService(uid: uid)
                                .addNote(trimmedText, selectedTag!, false);
                            noteController.clear();
                            selectedTag = null;
                          }
                          // ako su biljeska i tag prazni
                          else if (trimmedText.isEmpty && selectedTag == null) {
                            noteController.clear();
                            selectedTag = null;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please enter a non-empty note and select a tag.',
                                  style: GoogleFonts.ubuntu(fontSize: 16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 20),
                              ),
                            );
                          }
                          // ako nije unesen tekst/dodani su samo razmaci
                          else if (trimmedText.isEmpty) {
                            noteController.clear();
                            selectedTag = null;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please enter a non-empty note.',
                                  style: GoogleFonts.ubuntu(fontSize: 16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 20),
                              ),
                            );
                          }
                          // ako nije odabran tag
                          else {
                            noteController.clear();
                            selectedTag = null;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please select a tag for your note.',
                                  style: GoogleFonts.ubuntu(fontSize: 16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 20),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
