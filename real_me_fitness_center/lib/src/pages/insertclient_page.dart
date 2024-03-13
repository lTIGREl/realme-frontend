// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:real_me_fitness_center/src/models/client.dart';

class InsertClientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [FormCliente()]);
  }
}

class FormCliente extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String nombre = '';
  String cedula = '';
  String fecha = '';
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.person, size: 60),
            TextFormField(
              validator: ((value) =>
                  (value!.isEmpty) ? 'Ingrese el nombre' : null),
              onSaved: (value) => nombre = value!,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre',
                  hintText: 'Cliente',
                  prefixIcon: Icon(Icons.person)),
            ),
            TextFormField(
              validator: ((value) =>
                  (value!.isEmpty) ? 'Ingrese la cedula' : null),
              onSaved: (value) => cedula = value!,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Cédula',
                  hintText: 'CI',
                  prefixIcon: Icon(Icons.document_scanner)),
            ),
            TextFormField(
              validator: ((value) =>
                  (value!.isEmpty) ? 'Ingrese la fecha' : null),
              onSaved: (value) => fecha = value!,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Fecha de nacimiento',
                  hintText: 'Fecha',
                  prefixIcon: Icon(Icons.date_range)),
            ),
            ElevatedButton(
              child: const Text('Registrar'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  Client client = Client(data: {
                    'id': '0',
                    'name': nombre,
                    'ic': cedula,
                    'BDate': fecha
                  });
                  bool isCorrect = await client.postClient();
                  isCorrect
                      ? {
                          // Provider.of<SearchOption>(context, listen: false)
                          //     .needSearch = false,
                          Navigator.pop(context)
                        }
                      : null;
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
