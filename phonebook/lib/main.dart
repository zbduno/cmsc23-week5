import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

void main() => runApp(FlutterContactsExample());

class FlutterContactsExample extends StatefulWidget {
  const FlutterContactsExample({super.key});

  @override
  FlutterContactsExampleState createState() => FlutterContactsExampleState();
}

class FlutterContactsExampleState extends State<FlutterContactsExample> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future _fetchContacts() async {
    //Check if the app already has read/write permissions
    if (!await FlutterContacts.requestPermission(readonly: false)) {
      setState(() => _permissionDenied = true);
    } else {
      //If the app is permitted, retrieve the contacts using getContacts()
      //set the state of the app to the retrieved contacts
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: const Text('flutter_contacts_example')),
          body: _body()));

  //method to create the body.
  //different scenarios and different displays for when there is no permission.
  //and display a Listview when the contact list is not empty
  Widget _body() {
    if (_permissionDenied) {
      return const Center(child: Text('Permission denied'));
    }
    if (_contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _contacts!.length,
                itemBuilder: (context, i) => ListTile(
                      title: Text(_contacts![i].displayName),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          _contacts![i].delete();
                        },
                      ),
                    )),
          ),
        ],
      ),
    );
  }
}
