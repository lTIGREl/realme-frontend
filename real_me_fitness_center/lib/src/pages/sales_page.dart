// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _QuantityControl(),
          _DropDownButton(label: 'Producto', isProduct: true, items: [
            'Diario',
            'Proteina',
            'Agua pequeña',
            'Agua grande',
            'Pre-entreno',
            'Mensualidad'
          ]),
          _DropDownButton(
              label: 'Pago',
              isProduct: false,
              items: ['Efectivo', 'App', 'Fiado']),
          _CustomerData(),
          ElevatedButton(onPressed: () {}, child: Text('Registrar'))
        ],
      ),
    );
  }
}

class _CustomerData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Cliente'),
        SizedBox(
          width: 150,
          height: 75,
          child: TextField(
            onChanged: (value) {},
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }
}

class _QuantityControl extends StatelessWidget {
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
                onPressed: () => model.quantity--, icon: Icon(Icons.remove)),
            Container(
                alignment: Alignment.center,
                width: 50,
                child: Text(model.quantity.toString())),
            IconButton(
                onPressed: () => model.quantity++, icon: Icon(Icons.add)),
          ],
        ),
      ],
    );
  }
}

class _DropDownButton extends StatelessWidget {
  final bool isProduct;
  final List<String> items;
  final String label;

  const _DropDownButton(
      {required this.items, required this.isProduct, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Consumer<SelectedItemSale>(
          builder: (context, model, child) {
            return DropdownButton<String>(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              value: isProduct ? model.product : model.mode,
              hint: Text('Elige un producto'),
              onChanged: (String? newValue) {
                if (isProduct) {
                  model.product = newValue!;
                } else {
                  model.mode = newValue!;
                }
              },
              items: items.map<DropdownMenuItem<String>>((String value) {
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
