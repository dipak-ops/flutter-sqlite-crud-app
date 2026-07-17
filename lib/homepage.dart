import 'package:flutter/material.dart';
import 'package:sqlite_database/dbhelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  List<Map<String, dynamic>> allNotes = [];
  DBHelper? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstanse;
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF344955),
        title: Center(
          child: Text(
            'SQLite',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7F8),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),

                    // Note Number
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF344955),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Title
                    title: Text(
                      allNotes[index][DBHelper.COLUMN_NOTE_TITLE].toString(),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),

                    // Description
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        allNotes[index][DBHelper.COLUMN_NOTE_DESC].toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),

                    // Edit & Delete
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _titleController.text =
                                allNotes[index][DBHelper.COLUMN_NOTE_TITLE];

                            _descController.text =
                                allNotes[index][DBHelper.COLUMN_NOTE_DESC];

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(
                                      context,
                                    ).viewInsets.bottom,
                                  ),
                                  child: getBottomSheetWidget(
                                    isUpdate: true,
                                    sno:
                                        allNotes[index][DBHelper
                                            .COLUMN_NOTE_SNO],
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.edit_rounded,
                            color: Color(0xFF4A6572),
                          ),
                        ),

                        IconButton(
                          onPressed: () async {
                            bool check = await dbRef!.deleteNote(
                              sno: allNotes[index][DBHelper.COLUMN_NOTE_SNO],
                            );

                            if (check) {
                              getNotes();
                            }
                          },
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: Color(0xFFE57373),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(child: Text('Not are not yet!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _titleController.clear();
          _descController.clear();

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: getBottomSheetWidget(),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> getNotes() async {
    allNotes = await dbRef!.getNote();
    setState(() {});
  }

  Widget getBottomSheetWidget({bool isUpdate = false, int sno = 0}) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),
            Text(
              isUpdate ? "UPDATENOTE" : 'ADDNOTE',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(label: Text('Title')),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descController,
              decoration: InputDecoration(label: Text('desc')),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    var title = _titleController.text.toString();
                    var desc = _descController.text.toString();

                    if (title.isNotEmpty && desc.isNotEmpty) {
                      bool check = await (isUpdate
                          ? dbRef!.updateNote(
                              mTitle: title,
                              mDesc: desc,
                              sno: sno,
                            )
                          : dbRef!.addNote(mTitle: title, mDesc: desc));
                      if (check) {
                        getNotes();
                      }
                      Navigator.pop(context);
                    }
                  },

                  child: Text(isUpdate ? "UPDATENOTE" : 'ADDNOTE'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancle'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
