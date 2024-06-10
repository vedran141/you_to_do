import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Tag {
  final String name;
  final Color color;

  Tag({required this.name, required this.color});
}

class DatabaseService {
  final String uid;
  late BuildContext context;

  DatabaseService({required this.uid});

  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('users');

  // funkcija za dodavanje biljeski
  Future<void> addNote(String text, Tag tag, bool isDone) async {
    try {
      final CollectionReference notesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notes');

      DateTime now = DateTime.now();
      String dateAndTime = DateFormat('dd. MM. yyyy. | HH:mm').format(now);

      await notesCollection.add({
        'text': text,
        'isDone': isDone,
        'tag': tag.name,
        'dateandtime': now,
        'formattedDateTime': dateAndTime
      });
    } catch (e) {
      showErrorDialog('Error adding note: $e');
    }
  }

  // funkcija za prikaz biljeski ovisno o odabranom sortiranju
  Stream<QuerySnapshot> getNotes(String? sortingOption) {
    Query notesQuery = notesCollection.doc(uid).collection('notes');

    if (sortingOption == 'newest') {
      notesQuery = notesQuery.orderBy('dateandtime', descending: true);
    } else if (sortingOption == 'oldest') {
      notesQuery = notesQuery.orderBy('dateandtime', descending: false);
    } else if (sortingOption == 'az') {
      notesQuery = notesQuery.orderBy('text', descending: false);
    } else if (sortingOption == 'za') {
      notesQuery = notesQuery.orderBy('text', descending: true);
    }

    return notesQuery.snapshots();
  }

  // funkcija za brisanje biljeski
  Future<void> deleteNote(String noteId) async {
    try {
      await notesCollection.doc(uid).collection('notes').doc(noteId).delete();
    } catch (e) {
      showErrorDialog('Error deleting note: $e');
    }
  }

  // funkcija za oznacavanje biljeske kao odradene
  Future<void> updateNoteIsDone(String noteId, bool isDone) async {
    try {
      await notesCollection
          .doc(uid)
          .collection('notes')
          .doc(noteId)
          .update({'isDone': isDone});
    } catch (e) {
      showErrorDialog('Error updating note: $e');
    }
  }

  // void funkcija za ispis errora u dialogu prilikom gore navedenih funkcija
  void showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          titleTextStyle: GoogleFonts.ubuntu(
              color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
          content: Text(errorMessage, textAlign: TextAlign.justify),
          contentTextStyle: GoogleFonts.ubuntu(
              color: Colors.black, fontSize: 16, height: 1.5),
          backgroundColor: Colors.white,
          actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK',
                  style: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
