import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:mila_app/pages/my_shifts_page.dart';
import 'navigation.dart';
import 'package:mila_app/models/shift.dart';
import 'package:mila_app/services/services.dart';

class ChooseShiftsPage extends StatefulWidget {
  ChooseShiftsPage({Key? key}) : super(key: key);
  @override
  _ChooseShiftsPageState createState() => _ChooseShiftsPageState();
}

class _ChooseShiftsPageState extends State<ChooseShiftsPage> {

  Widget _shiftCard(Shift shift) {
    return Card(
        child: ListTile(
            title: Text(shift.type),
            subtitle: Text(shift.getTimeSpan())
        )
    );
  }

  Widget _shiftCardExpandable(Shift shift) {
    TextStyle titleStyle = TextStyle(
        color: Theme.of(context).textTheme.bodyText1!.color
    );
    TextStyle subtitleStyle = TextStyle(
        color: Theme.of(context).textTheme.caption!.color
    );
    return Card(
        child: ExpansionTile(
          title: Text(shift.type, style: titleStyle),
          subtitle: Text(shift.getTimeSpan(), style: subtitleStyle),
          expandedAlignment: Alignment.topLeft,  // Put column to the top-left
          expandedCrossAxisAlignment: CrossAxisAlignment.start,  // Align children within column
          childrenPadding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
          children: <Widget>[
            Text('Ort: MILA Mini Markt'),
            Text('Anmeldungen: ${shift.registrations}/${shift.registrationsWanted}'),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Für Schicht anmelden'),
              style: ElevatedButton.styleFrom(primary: Colors.green[900]),
              onPressed: () => _createRegistrationDialog(shift),
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('Verfügbare Schichten',
              style: TextStyle(color: Colors.black)
          ),
          /*leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("logo_small.png"),
          )*/
      ),
      body: FutureBuilder<List<Shift>>(
        future: Services.of(context)
            .shiftService.getAvailableShifts()
            .catchError((e){Future.error(e);}),  // Display errors
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final shifts = (snapshot.data ?? [])  // ?? means if non-null else
              ..sort((x, y) => x.start.compareTo(y.start));
            return ListView(
              padding: const EdgeInsets.all(10.0),
              children: shifts.map(_shiftCardExpandable).toList(),
              );
          } else {
            return Center(
              child: CircularProgressIndicator()
            );
          }
        }  // FutureBuilder.builder
      )
    );
  }

  Future<void> _createRegistrationDialog(Shift shift) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
                title: Text('Bestätigung'),
                contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Ich möchte mich für die Teilnahme an der'
                          ' folgenden Schicht anmelden:'),
                      SizedBox(height: 10),
                      _shiftCard(shift)
                    ]
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Abbrechen'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await Services.of(context)
                          .shiftService
                          .createUserShift(shift);
                      setState((){});
                      Navigator.pop(context, 'OK');  // TODO Understand message
                      Navigator.pop(context);  // TODO Better approach?
                    },
                    child: const Text('OK'),
                  ),
                ])
    );
  }

}