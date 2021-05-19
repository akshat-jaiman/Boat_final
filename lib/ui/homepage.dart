import 'package:boat/ui/pdfview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userid = FirebaseAuth.instance.currentUser.email;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    var datajson = await rootBundle.loadString("assets/boatdata.json");
    var decodedData = jsonDecode(datajson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: CircleAvatar(
                child: Icon(Icons.verified_user),
                radius: 35,
              ),
            ),
            ListTile(
              onTap: () {
                print('pdf tapped');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PdfView()));
              },
              leading: Icon(Icons.picture_as_pdf),
              title: Text('Open pdf'),
            ),
            ListTile(
              onTap: () {
                print('Log out');
                _signOut();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              leading: Icon(Icons.exit_to_app),
              title: Text('Log Out'),
            ),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amberAccent,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Center(
                          child: Text(
                            '1 Jan 2021',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Divider(
                          height: 10,
                          thickness: 1,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueAccent,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('Time')),
                            DataColumn(label: Text('m')),
                            DataColumn(label: Text('Time')),
                            DataColumn(label: Text('Gate')),
                          ],
                          rows: [
                            DataRow(cells: <DataCell>[
                              DataCell(Text('06:44')),
                              DataCell(Text('1.5')),
                              DataCell(Text('02:58')),
                              DataCell(Text('Raise')),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(Text('12:09')),
                              DataCell(Text('7.9')),
                              DataCell(Text('08:59')),
                              DataCell(Text('Lower')),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(Text('19:13')),
                              DataCell(Text('1.4')),
                              DataCell(Text('15:22')),
                              DataCell(Text('Raise')),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(Text('-')),
                              DataCell(Text('-')),
                              DataCell(Text('21:34')),
                              DataCell(Text('Lower')),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: Divider(
                  height: 10,
                  thickness: 5,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amberAccent,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Center(
                          child: Text(
                            '2 Jan 2021',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Divider(
                          height: 10,
                          thickness: 1,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueAccent,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('Time')),
                            DataColumn(label: Text('m')),
                            DataColumn(label: Text('Time')),
                            DataColumn(label: Text('Gate')),
                          ],
                          rows: [
                            DataRow(cells: <DataCell>[
                              DataCell(Text('0:30')),
                              DataCell(Text('7.3')),
                              DataCell(Text('3:38')),
                              DataCell(Text('Raise')),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(Text('7:22')),
                              DataCell(Text('1.6')),
                              DataCell(Text('9:38')),
                              DataCell(Text('Lower')),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(Text('12:50')),
                              DataCell(Text('7.9')),
                              DataCell(Text('16:03')),
                              DataCell(Text('Raise')),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(Text('19:54')),
                              DataCell(Text('1.4')),
                              DataCell(Text('22:17')),
                              DataCell(Text('Lower')),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: Divider(
                  height: 10,
                  thickness: 5,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amberAccent,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Center(
                          child: Text(
                            '3 Jan 2021',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Divider(
                          height: 10,
                          thickness: 1,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueAccent,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('Time')),
                            DataColumn(label: Text('m')),
                            DataColumn(label: Text('Time')),
                            DataColumn(label: Text('Gate')),
                          ],
                          rows: [
                            DataRow(cells: <DataCell>[
                              DataCell(Text('06:44')),
                              DataCell(Text('1.5')),
                              DataCell(Text('02:58')),
                              DataCell(Text('Raise')),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(Text('12:09')),
                              DataCell(Text('7.9')),
                              DataCell(Text('08:59')),
                              DataCell(Text('Lower')),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(Text('19:13')),
                              DataCell(Text('1.4')),
                              DataCell(Text('15:22')),
                              DataCell(Text('Raise')),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(Text('-')),
                              DataCell(Text('-')),
                              DataCell(Text('21:34')),
                              DataCell(Text('Lower')),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: Divider(
                  height: 10,
                  thickness: 5,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amberAccent,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Center(
                          child: Text(
                            '4 Jan 2021',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Divider(
                          height: 10,
                          thickness: 1,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueAccent,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('Time')),
                            DataColumn(label: Text('m')),
                            DataColumn(label: Text('Time')),
                            DataColumn(label: Text('Gate')),
                          ],
                          rows: [
                            DataRow(cells: <DataCell>[
                              DataCell(Text('06:44')),
                              DataCell(Text('1.5')),
                              DataCell(Text('02:58')),
                              DataCell(Text('Raise')),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(Text('12:09')),
                              DataCell(Text('7.9')),
                              DataCell(Text('08:59')),
                              DataCell(Text('Lower')),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(Text('19:13')),
                              DataCell(Text('1.4')),
                              DataCell(Text('15:22')),
                              DataCell(Text('Raise')),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(Text('-')),
                              DataCell(Text('-')),
                              DataCell(Text('21:34')),
                              DataCell(Text('Lower')),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: Divider(
                  height: 10,
                  thickness: 5,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amberAccent,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Center(
                          child: Text(
                            '5 Jan 2021',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Divider(
                          height: 10,
                          thickness: 1,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueAccent,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('Time')),
                            DataColumn(label: Text('m')),
                            DataColumn(label: Text('Time')),
                            DataColumn(label: Text('Gate')),
                          ],
                          rows: [
                            DataRow(cells: <DataCell>[
                              DataCell(Text('06:44')),
                              DataCell(Text('1.5')),
                              DataCell(Text('02:58')),
                              DataCell(Text('Raise')),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(Text('12:09')),
                              DataCell(Text('7.9')),
                              DataCell(Text('08:59')),
                              DataCell(Text('Lower')),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(Text('19:13')),
                              DataCell(Text('1.4')),
                              DataCell(Text('15:22')),
                              DataCell(Text('Raise')),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(Text('-')),
                              DataCell(Text('-')),
                              DataCell(Text('21:34')),
                              DataCell(Text('Lower')),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: Divider(
                  height: 10,
                  thickness: 5,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amberAccent,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Center(
                          child: Text(
                            '6 Jan 2021',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Divider(
                          height: 10,
                          thickness: 1,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueAccent,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('Time')),
                            DataColumn(label: Text('m')),
                            DataColumn(label: Text('Time')),
                            DataColumn(label: Text('Gate')),
                          ],
                          rows: [
                            DataRow(cells: <DataCell>[
                              DataCell(Text('06:44')),
                              DataCell(Text('1.5')),
                              DataCell(Text('02:58')),
                              DataCell(Text('Raise')),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(Text('12:09')),
                              DataCell(Text('7.9')),
                              DataCell(Text('08:59')),
                              DataCell(Text('Lower')),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(Text('19:13')),
                              DataCell(Text('1.4')),
                              DataCell(Text('15:22')),
                              DataCell(Text('Raise')),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(Text('-')),
                              DataCell(Text('-')),
                              DataCell(Text('21:34')),
                              DataCell(Text('Lower')),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: Divider(
                  height: 10,
                  thickness: 5,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
