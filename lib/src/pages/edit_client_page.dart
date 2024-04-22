// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:real_me_fitness_center/src/models/membership.dart';
import 'package:real_me_fitness_center/src/providers/delete.dart';
import 'package:real_me_fitness_center/src/providers/membership.dart';
import '../models/client.dart';

class EditDialog extends StatefulWidget {
  EditDialog({
    required this.client,
    required this.nameCtrl,
    required this.icCtrl,
    required this.bDateCtrl,
  });

  final Client client;
  final TextEditingController nameCtrl;
  final TextEditingController icCtrl;
  final TextEditingController bDateCtrl;

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late bool delete;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AlertDialog(
          title: Text(widget.client.name),
          content: SingleChildScrollView(
              child: SizedBox(
                  height: 400,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                            controller: widget.nameCtrl,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Nombre')),
                            maxLines: null),
                        TextFormField(
                            controller: widget.icCtrl,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Cédula')),
                            maxLines: null),
                        TextFormField(
                            controller: widget.bDateCtrl,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Fecha de Nacimiento')),
                            maxLines: null)
                      ]))),
          actions: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ChangeNotifierProvider(
                  create: ((context) => DeleteOption()),
                  child: Builder(builder: (context) {
                    delete = Provider.of<DeleteOption>(context).needDelete;
                    return delete
                        ? ConfirmButton(client: widget.client)
                        : DeleteButton();
                  })),
              TextButton(
                  onPressed: () async {
                    widget.client.name = widget.nameCtrl.text;
                    widget.client.ic = widget.icCtrl.text;
                    widget.client.BDate = widget.bDateCtrl.text;
                    setState(() => _isLoading = true);
                    bool isCorrect = await widget.client.postClient();
                    isCorrect
                        ? Navigator.pop(context)
                        : setState(() {
                            _isLoading = false;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: const Text('Ocurrió un error')));
                          });
                  },
                  child: Text('Guardar'))
            ])
          ]),
      if (_isLoading)
        Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(child: CircularProgressIndicator()))
    ]);
  }
}

class DeleteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        Provider.of<DeleteOption>(context, listen: false).needDelete = true;
      },
      child: Text('Eliminar'),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  ConfirmButton({
    required this.client,
  });

  final Client client;
  late Membership membership = Membership(id: '0');

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await membership.deleteMembership("client_id", client.id);
        bool isCorrect = await client.deleteClient("id", client.id);
        isCorrect ? Navigator.pop(context) : null;
      },
      child: BounceInDown(
          duration: Duration(milliseconds: 500), child: Text('Confirmar')),
    );
  }
}

class MembershipDialog extends StatefulWidget {
  const MembershipDialog({required this.client});

  final Client client;

  @override
  State<MembershipDialog> createState() => _MembershipDialogState();
}

class _MembershipDialogState extends State<MembershipDialog> {
  bool _isLoading = false;
  bool _isCompleted = false;
  @override
  Widget build(BuildContext context) {
    Membership membership = Membership(id: widget.client.id);
    return ChangeNotifierProvider(
        create: (context) => SelectedDateModel(),
        child: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            DateTime iDate = Provider.of<SelectedDateModel>(context).iDate;
            DateTime fDate = Provider.of<SelectedDateModel>(context).fDate;

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              Map<String, dynamic> datos;
              try {
                datos = (snapshot.data! as List)
                    .map((item) => (item as Map<String, dynamic>).map(
                        (key, value) =>
                            MapEntry(key.toString(), value.toString())))
                    .elementAt(0);
              } catch (e) {
                datos = {
                  'id': '0',
                  'start_date': iDate.toString(),
                  'end_date': fDate.toString()
                };
              }
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!_isCompleted) {
                  Provider.of<SelectedDateModel>(context, listen: false).iDate =
                      DateTime.parse(
                          datos['start_date'].toString().substring(0, 10));
                  Provider.of<SelectedDateModel>(context, listen: false).fDate =
                      DateTime.parse(
                          datos['end_date'].toString().substring(0, 10));
                }
                _isCompleted = true;
              });

              return Stack(
                children: [
                  AlertDialog(
                    title: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle,
                            color: validateDate(DateTime.now(),
                                    DateTime.parse(datos['end_date']))
                                ? Colors.green
                                : Colors.red,
                            size: 20,
                          ),
                          Text(widget.client.name)
                        ],
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: SizedBox(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Text(
                                    'Desde: ${iDate.toString().substring(0, 10)}'),
                                IconButton(
                                    onPressed: () {
                                      DatePicker.showDatePicker(
                                        context,
                                        showTitleActions: true,
                                        minTime: DateTime(2024),
                                        maxTime: DateTime(2030),
                                        onConfirm: (date) {
                                          Provider.of<SelectedDateModel>(
                                                  context,
                                                  listen: false)
                                              .iDate = date;
                                        },
                                        currentTime: iDate,
                                        locale: LocaleType.es,
                                      );
                                    },
                                    icon: Icon(Icons.edit)),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                    'Hasta: ${fDate.toString().substring(0, 10)}'),
                                IconButton(
                                    onPressed: () {
                                      DatePicker.showDatePicker(
                                        context,
                                        showTitleActions: true,
                                        minTime: DateTime(2024),
                                        maxTime: DateTime(2030),
                                        onConfirm: (date) {
                                          Provider.of<SelectedDateModel>(
                                                  context,
                                                  listen: false)
                                              .fDate = date;
                                        },
                                        currentTime: fDate,
                                        locale: LocaleType.es,
                                      );
                                    },
                                    icon: Icon(Icons.edit)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: validateDate(iDate, fDate)
                            ? () async {
                                Membership membresia = Membership(
                                    id: datos['id']!,
                                    client_id: widget.client.id,
                                    iDate: iDate.toString(),
                                    fDate: fDate.toString());
                                setState(() => _isLoading = true);
                                bool isCorrect =
                                    await membresia.postMembership();
                                isCorrect
                                    ? Navigator.pop(context)
                                    : setState(() {
                                        _isLoading = false;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: const Text(
                                                    'Ocurrió un error')));
                                      });
                              }
                            : null,
                        child: Text('Guardar'),
                      ),
                    ],
                  ),
                  if (_isLoading)
                    Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Center(child: CircularProgressIndicator()))
                ],
              );
            }
          },
          future: membership.getMembership(),
        ));
  }

  bool validateDate(DateTime iDate, DateTime fDate) {
    bool isValid = iDate.isBefore(fDate) ? true : false;
    return isValid;
  }
}
