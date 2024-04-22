// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:real_me_fitness_center/src/models/client.dart';
import 'package:real_me_fitness_center/src/pages/edit_client_page.dart';
import 'package:real_me_fitness_center/src/providers/search.dart';

class ClientsPage extends StatelessWidget {
  String column = '';
  String value = '';
  @override
  Widget build(BuildContext context) {
    Client clients = Client();
    return Scaffold(
        body: Stack(children: [
      Column(children: [SizedBox(height: 250), Expanded(child: ClientsList())]),
      _Header(),
      Positioned(top: 225, left: 0, right: 0, child: _SearchTab()),
      Positioned(
          top: 0,
          right: 0,
          child: SafeArea(
              child: IconButton(
                  onPressed: () {
                    openDialogCreate(context);
                  },
                  icon: FaIcon(FontAwesomeIcons.plus,
                      size: 30, color: Colors.white))))
    ]));
  }

  void openDialogCreate(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateDialogClient();
      },
    );
  }
}

class CreateDialogClient extends StatefulWidget {
  const CreateDialogClient({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateDialogClient> createState() => _CreateDialogClientState();
}

class _CreateDialogClientState extends State<CreateDialogClient> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String nombre = '';
  String cedula = '';
  String fecha = '';
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AlertDialog(
          title: Text('Nuevo cliente'),
          content: SizedBox(
              height: 400,
              width: 200,
              child: ListView(children: [
                SizedBox(
                    height: 400,
                    child: Form(
                        key: formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.person, size: 60),
                              TextFormField(
                                validator: ((value) => (value!.isEmpty)
                                    ? 'Ingrese el nombre'
                                    : null),
                                onSaved: (value) => nombre = value!,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Nombre',
                                    hintText: 'Cliente',
                                    prefixIcon: Icon(Icons.person)),
                              ),
                              TextFormField(
                                  validator: ((value) => (value!.isEmpty)
                                      ? 'Ingrese la cedula'
                                      : null),
                                  onSaved: (value) => cedula = value!,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Cédula',
                                      hintText: 'CI',
                                      prefixIcon:
                                          Icon(Icons.document_scanner))),
                              TextFormField(
                                  validator: ((value) => (value!.isEmpty)
                                      ? 'Ingrese la fecha'
                                      : null),
                                  onSaved: (value) => fecha = value!,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Fecha de nacimiento',
                                      hintText: 'Fecha',
                                      prefixIcon: Icon(Icons.date_range))),
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
                                      setState(() => _isLoading = true);
                                      bool isCorrect =
                                          await client.postClient();
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
                                  })
                            ])))
              ]))),
      if (_isLoading)
        Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(child: CircularProgressIndicator()))
    ]);
  }
}

class ClientsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String column = '';
    String value = '';
    return FutureBuilder(
        future: Provider.of<SearchOption>(context).fetchData(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          column = Provider.of<SearchOption>(context).column;
          value = Provider.of<SearchOption>(context).value;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Map<String, String>> datos = (snapshot.data!)
                .map((item) => (item as Map<String, dynamic>).map(
                    (key, value) => MapEntry(key.toString(), value.toString())))
                .toList();
            return _CustomersGrid(items: datos);
          }
        });
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        color: Colors.blue,
      ),
      width: double.infinity,
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Familia', style: TextStyle(color: Colors.white, fontSize: 40)),
          Text('Real Me', style: TextStyle(color: Colors.white, fontSize: 40)),
        ],
      ),
    );
  }
}

class _SearchTab extends StatelessWidget {
  TextEditingController searchCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      margin: EdgeInsets.symmetric(horizontal: 40),
      height: 50,
      width: 300,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: TextField(
                controller: searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Buscar',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              if (searchCtrl.text.length == 0) {
                Provider.of<SearchOption>(context, listen: false).needSearch =
                    false;
              } else {
                Provider.of<SearchOption>(context, listen: false).column =
                    'name';
                Provider.of<SearchOption>(context, listen: false).value =
                    searchCtrl.text;
                Provider.of<SearchOption>(context, listen: false).needSearch =
                    true;
              }
            },
          ),
        ],
      ),
    );
  }
}

class _CustomersGrid extends StatelessWidget {
  final List items;
  const _CustomersGrid({
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    List<Client> clients = [];
    for (var item in items) {
      Client clientTemp = Client();
      clientTemp.id = item['id'];
      clientTemp.name = item['name'];
      clientTemp.ic = item['ic'];
      clientTemp.BDate = item['BDate'];
      clients.add(clientTemp);
    }
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: clients.length,
      itemBuilder: (context, index) => _CustomerCardItem(clients[index]),
    );
  }
}

class _CustomerCardItem extends StatelessWidget {
  Client client;
  _CustomerCardItem(this.client);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              'assets/icon_male.svg',
              width: 100,
            ),
            Column(
              children: [
                Text(client.name),
                Text('CI: ${client.ic}'),
                Text('Fecha: ${client.BDate.toString().split('T')[0]}'),
              ],
            ),
            Column(
              children: [
                IconButton(
                    onPressed: () {
                      openDialogEdit(context);
                    },
                    icon: Icon(Icons.edit)),
                IconButton(
                  onPressed: () {
                    openDialogMembership(context);
                  },
                  icon: Icon(Icons.verified_user),
                  color: Colors.green,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void openDialogEdit(BuildContext context) {
    TextEditingController nameCtrl = TextEditingController();
    nameCtrl.text = client.name;
    TextEditingController icCtrl = TextEditingController();
    icCtrl.text = client.ic;
    TextEditingController bDateCtrl = TextEditingController();
    bDateCtrl.text = client.BDate.toString().split('T')[0];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditDialog(
            client: client,
            nameCtrl: nameCtrl,
            icCtrl: icCtrl,
            bDateCtrl: bDateCtrl);
      },
    );
  }

  void openDialogMembership(BuildContext context) {
    TextEditingController nameCtrl = TextEditingController();
    nameCtrl.text = client.name;
    TextEditingController icCtrl = TextEditingController();
    icCtrl.text = client.ic;
    TextEditingController bDateCtrl = TextEditingController();
    bDateCtrl.text = client.BDate.toString().split('T')[0];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MembershipDialog(client: client);
      },
    );
  }
}
