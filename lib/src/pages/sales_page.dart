// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:real_me_fitness_center/src/models/client.dart';
import 'package:real_me_fitness_center/src/models/product.dart';
import 'package:real_me_fitness_center/src/models/sale.dart';
import 'package:real_me_fitness_center/src/providers/sales_add.dart';

import '../widgets/radial_progress.dart';

class SalesPage extends StatefulWidget {
  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('es_MX');
    String date = DateFormat('d MMMM y', 'es_MX').format(DateTime.now());
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
          ),
          _Header(
            date: date,
            leftArrow: _leftButton,
            rightArrow: _rightButton,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) => _currentPage = page,
              physics: BouncingScrollPhysics(),
              children: [
                _SalesSummary(
                  detailsButton: _detailsButton,
                  newSaleButton: _newSaleButton,
                ),
                _NewSale(),
                _SalesDetails()
              ],
            ),
          ),
        ],
      ),
    ));
  }

  _detailsButton() {
    _pageController.animateToPage(2,
        duration: Duration(milliseconds: 200), curve: Curves.ease);
  }

  _newSaleButton() {
    _pageController.animateToPage(1,
        duration: Duration(milliseconds: 200), curve: Curves.ease);
  }

  _leftButton() {
    if (_currentPage != 0) {
      _pageController.animateToPage(_currentPage - 1,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
    }
  }

  _rightButton() {
    if (_currentPage != 2) {
      _pageController.animateToPage(_currentPage + 1,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
    }
  }
}

class _NewSale extends StatelessWidget {
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _payController = TextEditingController();
  final TextEditingController _clientController = TextEditingController();
  final TextEditingController _debtController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _QuantityControl(_qtyController),
          _DropDownButton(
              label: 'Producto',
              isProduct: true,
              controller: _productController),
          _DropDownButton(
              label: 'Pago', isProduct: false, controller: _payController),
          _CustomerData(_clientController),
          _DebtData(_debtController),
          _SendButton(
              clientController: _clientController,
              debtController: _debtController,
              qtyController: _qtyController,
              productController: _productController,
              payController: _payController)
        ],
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required TextEditingController clientController,
    required TextEditingController debtController,
    required TextEditingController qtyController,
    required TextEditingController productController,
    required TextEditingController payController,
  })  : _clientController = clientController,
        _qtyController = qtyController,
        _productController = productController,
        _payController = payController,
        _debtController = debtController;

  final TextEditingController _clientController;
  final TextEditingController _debtController;
  final TextEditingController _qtyController;
  final TextEditingController _productController;
  final TextEditingController _payController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          Sale sale = Sale();
          bool isCorrect = await sale.postSale(
              _qtyController.text,
              _productController.text,
              _payController.text,
              _clientController.text,
              _debtController.text);
          isCorrect
              ? {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SalesPage()))
                }
              : null;
        },
        child: Text('Registrar'));
  }
}

class _DebtData extends StatelessWidget {
  _DebtData(this._debtController);
  TextEditingController _debtController;
  @override
  Widget build(BuildContext context) {
    _debtController.text = '0';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Deuda'),
        SizedBox(
          width: 150,
          height: 75,
          child: TextField(
            controller: _debtController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Deuda',
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomerData extends StatelessWidget {
  _CustomerData(this._clientController);
  TextEditingController _clientController;
  Client client = Client();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Cliente'),
        SizedBox(
          width: 150,
          height: 75,
          child: FutureBuilder(
              future: client.getClients(false, '', ''),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Map<String, String>> datos = (snapshot.data!)
                      .map((item) => (item as Map<String, dynamic>).map(
                          (key, value) =>
                              MapEntry(key.toString(), value.toString())))
                      .toList();
                  List<String> names =
                      datos.map((item) => item['name'] as String).toList();
                  return Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      }
                      return names.where((String option) {
                        return option.contains(textEditingValue.text);
                      });
                    },
                    onSelected: (String selection) {
                      _clientController.text = selection;
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      _clientController.value = textEditingController.value;
                      return TextField(
                        textCapitalization: TextCapitalization.words,
                        controller: textEditingController,
                        focusNode: focusNode,
                        onSubmitted: (String value) {
                          onFieldSubmitted();
                        },
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Nombre',
                        ),
                      );
                    },
                  );
                }
              }),
        ),
      ],
    );
  }
}

class _QuantityControl extends StatefulWidget {
  _QuantityControl(this._qtyController);
  TextEditingController _qtyController;

  @override
  State<_QuantityControl> createState() => _QuantityControlState();
}

class _QuantityControlState extends State<_QuantityControl> {
  @override
  void initState() {
    widget._qtyController.text = '1';
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SelectedItemSale>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Cantidad'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  model.quantity--;
                  widget._qtyController.text = model.quantity.toString();
                },
                icon: Icon(Icons.remove)),
            Container(
                alignment: Alignment.center,
                width: 50,
                child: Text(model.quantity.toString())),
            IconButton(
                onPressed: () {
                  model.quantity++;
                  widget._qtyController.text = model.quantity.toString();
                },
                icon: Icon(Icons.add)),
          ],
        ),
      ],
    );
  }
}

class _DropDownButton extends StatelessWidget {
  final bool isProduct;
  final String label;
  final TextEditingController controller;

  const _DropDownButton(
      {required this.isProduct, required this.label, required this.controller});
  @override
  Widget build(BuildContext context) {
    Product product = Product();
    return isProduct
        ? FutureBuilder(
            future:
                product.getProducts(), // Función que retorna un Future<String>
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Muestra un indicador de carga mientras se espera la respuesta
              } else if (snapshot.hasError) {
                return Text(
                    'Error: ${snapshot.error}'); // Muestra un mensaje de error si hay algún error
              } else {
                List<Map<String, String>> datos = (snapshot.data!)
                    .map((item) => (item as Map<String, dynamic>).map(
                        (key, value) =>
                            MapEntry(key.toString(), value.toString())))
                    .toList();
                List<String> names =
                    datos.map((item) => item['name'] as String).toList();
                List<String> ids =
                    datos.map((item) => item['id'] as String).toList();
                return _DropMenu(
                    ids: ids,
                    controller: controller,
                    label: label,
                    isProduct: isProduct,
                    items: names);
              }
            },
          )
        : _DropMenu(
            ids: [],
            controller: controller,
            label: label,
            isProduct: isProduct,
            items: ['Efectivo', 'App', 'Fiado']);
  }
}

class _DropMenu extends StatefulWidget {
  const _DropMenu({
    required this.controller,
    required this.ids,
    required this.label,
    required this.isProduct,
    required this.items,
  });

  final String label;
  final List<String> ids;
  final bool isProduct;
  final List<String> items;
  final TextEditingController controller;

  @override
  State<_DropMenu> createState() => _DropMenuState();
}

class _DropMenuState extends State<_DropMenu> {
  @override
  void initState() {
    widget.controller.text =
        widget.isProduct ? widget.ids[0] : translateMethod(widget.items[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.label),
        Consumer<SelectedItemSale>(
          builder: (context, model, child) {
            return DropdownButton<String>(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              value: widget.isProduct ? model.product : model.mode,
              hint: Text('Elige un producto'),
              onChanged: (String? newValue) {
                if (widget.isProduct) {
                  model.product = newValue!;
                  widget.controller.text =
                      widget.ids[widget.items.indexOf(model.product)];
                } else {
                  model.mode = newValue!;
                  widget.controller.text = translateMethod(model.mode);
                }
              },
              items: widget.items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  String translateMethod(String method) {
    switch (method) {
      case 'Efectivo':
        return 'cash';
      case 'App':
        return 'transfer';
      case 'Fiado':
        return 'credit';
      default:
        return 'cash';
    }
  }
}

class _SalesDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          floating: true,
          delegate: _SliverCustomHeaderDelegate(
              maxheight: 50, minheight: 50, child: _SliverHeader()),
        ),
        SliverList(delegate: SliverChildListDelegate([_SliverBody()]))
      ],
    );
  }
}

class _SliverBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      child: ListView.builder(
        itemCount: 30,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('2'),
                  Text('Proteína'),
                  Text('5\$'),
                  Text('Efectivo'),
                ],
              ),
            ),
            elevation: 0,
          );
        },
      ),
    );
  }
}

class _SliverHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('#'),
            Text('Detalle'),
            Text('Total'),
            Text('Pago'),
          ],
        ),
      ),
      elevation: 0,
    );
  }
}

class _SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minheight;
  final double maxheight;
  final Widget child;

  _SliverCustomHeaderDelegate(
      {required this.minheight, required this.maxheight, required this.child});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxheight;

  @override
  double get minExtent => minheight;

  @override
  bool shouldRebuild(covariant _SliverCustomHeaderDelegate oldDelegate) {
    return maxheight != oldDelegate.maxheight ||
        minheight != oldDelegate.minheight ||
        child != oldDelegate.child;
  }
}

class _SalesSummary extends StatelessWidget {
  final Function detailsButton;
  final Function newSaleButton;

  const _SalesSummary(
      {required this.detailsButton, required this.newSaleButton});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: RadialProgress(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
              ),
              Text(
                '\$125.25',
                style: TextStyle(fontSize: 40, color: Colors.blue),
              ),
              Text('Ventas totales', style: TextStyle(fontSize: 20)),
              ElevatedButton(
                onPressed: () => detailsButton(),
                child: Text('Detalles'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => newSaleButton(),
                child: Text('Nueva Venta'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              )
            ],
          ),
          porcentaje: 50.0,
          colorPrimario: Colors.blue,
          colorSecundario: Colors.grey),
    );
  }
}

class _Header extends StatelessWidget {
  final Function leftArrow;
  final Function rightArrow;
  final String date;
  const _Header(
      {required this.date, required this.leftArrow, required this.rightArrow});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => leftArrow(),
          icon: Icon(Icons.arrow_back_ios),
        ),
        Column(
          children: [
            Text('Hoy',
                style: TextStyle(
                  fontSize: 40,
                )),
            Text(date),
          ],
        ),
        IconButton(
          onPressed: () => rightArrow(),
          icon: Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }
}
