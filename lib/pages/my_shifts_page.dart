import 'package:flutter/material.dart';
import 'package:mila_app/models/shift.dart';
import 'package:mila_app/services/services.dart';

class MyShiftsPage extends StatefulWidget {
  const MyShiftsPage({Key? key}) : super(key: key);

  @override
  _MyShiftsPageState createState() => _MyShiftsPageState();
}

class _MyShiftsPageState extends State<MyShiftsPage> {

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
              child: Text('Von Schicht abmelden'),
              style: ElevatedButton.styleFrom(primary: Colors.deepOrange[900]),
              onPressed: () => _removeRegistrationDialog(shift),
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Shift>>(
      future: Services.of(context)
        .shiftService.getShiftsOfUser()
        .catchError((e){Future.error(e);}),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final shifts = (snapshot.data ?? []) // ?? means if non-null else
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
    );
  }  // _HomeBody.build

  Future<void> _removeRegistrationDialog(Shift shift) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
                title: Text('Bestätigung'),
                contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Ich möchte mich von der Teilnahme an der'
                          ' folgenden Schicht abmelden:'),
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
                      await Services.of(context).shiftService.removeUserShift(shift);
                      setState((){});
                      Navigator.pop(context, 'OK');
                    },
                    child: const Text('OK'),
                  ),
                ])
    );
  }

}  // _HomeBody