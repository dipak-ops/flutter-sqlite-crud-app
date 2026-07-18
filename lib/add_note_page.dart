import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_database/dbhelper.dart';
import 'package:sqlite_database/dbprovider.dart';

class AddNotePage extends StatelessWidget {
  bool isUpdate;
  String title;
  String desc;
  int sno;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  List<Map<String, dynamic>> allNotes = [];
  //DBHelper? dbRef=DBHelper.getInstanse;

  AddNotePage({
    this.isUpdate = false,
    this.title = "",
    this.desc = "",
    this.sno = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (isUpdate) {
      _titleController.text = title;
      _descController.text = desc;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isUpdate ? "UPDATENOTE" : 'ADDNOTE',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 40),
              // Text(
              //   isUpdate ? "UPDATENOTE" : 'ADDNOTE',
              //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              // ),
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
                        // ❌ Wrong braces
                        // if(isUpdate)
                        // context.read<DBProvider>().updateNote(title, desc, sno);
                        // }else{
                        //   context.read<DBProvider>().addNote(title, desc);
                        // }

                        // ✅ Correct
                        if (isUpdate) {
                          context.read<DBProvider>().updateNote(
                            title,
                            desc,
                            sno,
                          );
                        } else {
                          context.read<DBProvider>().addNote(title, desc);
                        }

                        Navigator.pop(context);

                        // bool check = await (isUpdate
                        //     ? dbRef!.updateNote(
                        //         mTitle: title,
                        //         mDesc: desc,
                        //         sno: sno,
                        //       )
                        //     : dbRef!.addNote(mTitle: title, mDesc: desc));
                        // if (check) {
                        //   Navigator.pop(context);
                        // }
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
      ),
    );
  }
}
