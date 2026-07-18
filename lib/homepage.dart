import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_database/add_note_page.dart';
import 'package:sqlite_database/dbhelper.dart';
import 'package:sqlite_database/dbprovider.dart';
import 'package:sqlite_database/setting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Map<String, dynamic>> allNotes = [];
  // DBHelper? dbRef;

  @override
  void initState() {
    super.initState();

    // ❌ Wrong
    // context.read<DBProvider>().getInitialNotes;

    // ✅ Correct
    context.read<DBProvider>().getInitialNotes();

    // dbRef = DBHelper.getInstanse;
    // getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF344955),
        title: const Text(
          "SQLite",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == "settings") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingPage()),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem<String>(value: "settings", child: Text("Settings")),
            ],
          ),
        ],
      ),

      body: Consumer<DBProvider>(
        builder: (_, provider, __) {
          List<Map<String, dynamic>> allNotes = provider.getNotes();

          return allNotes.isNotEmpty
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

                        title: Text(
                          allNotes[index][DBHelper.COLUMN_NOTE_TITLE]
                              .toString(),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF263238),
                          ),
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            allNotes[index][DBHelper.COLUMN_NOTE_DESC]
                                .toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddNotePage(
                                      isUpdate: true,
                                      title:
                                          allNotes[index][DBHelper
                                              .COLUMN_NOTE_TITLE],
                                      desc:
                                          allNotes[index][DBHelper
                                              .COLUMN_NOTE_DESC],
                                      sno:
                                          allNotes[index][DBHelper
                                              .COLUMN_NOTE_SNO],
                                    ),
                                  ),
                                );

                                // _titleController.text =
                                //     allNotes[index][DBHelper.COLUMN_NOTE_TITLE];

                                // _descController.text =
                                //     allNotes[index][DBHelper.COLUMN_NOTE_DESC];

                                // showModalBottomSheet(
                                //   context: context,
                                //   isScrollControlled: true,
                                //   builder: (context) {
                                //     return Padding(
                                //       padding: EdgeInsets.only(
                                //         bottom: MediaQuery.of(
                                //           context,
                                //         ).viewInsets.bottom,
                                //       ),
                                //       child: getBottomSheetWidget(
                                //         isUpdate: true,
                                //         sno:
                                //             allNotes[index][DBHelper
                                //                 .COLUMN_NOTE_SNO],
                                //       ),
                                //     );
                                //   },
                                // );
                              },
                              icon: const Icon(
                                Icons.edit_rounded,
                                color: Color(0xFF4A6572),
                              ),
                            ),

                            IconButton(
                              onPressed: () async {
                                // ❌ Old Code
                                // bool check = await dbRef!.deleteNote(
                                //   sno: allNotes[index][DBHelper.COLUMN_NOTE_SNO],
                                // );
                                //
                                // if (check) {
                                //   getNotes();
                                // }

                                // ✅ Provider Code
                                context.read<DBProvider>().deleteNote(
                                  allNotes[index][DBHelper.COLUMN_NOTE_SNO],
                                );
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
              : const Center(child: Text('No Notes Yet!'));
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // _titleController.clear();
          // _descController.clear();

          // showModalBottomSheet(
          //   context: context,
          //   isScrollControlled: true,
          //   builder: (context) {
          //     return Padding(
          //       padding: EdgeInsets.only(
          //         bottom: MediaQuery.of(context).viewInsets.bottom,
          //       ),
          //       child: getBottomSheetWidget(),
          //     );
          //   },
          // );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // ❌ Not needed when using Provider
  // Future<void> getNotes() async {
  //   allNotes = await dbRef!.getNote();
  //   setState(() {});
  // }
}
