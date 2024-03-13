class Sale {
  int quantity;
  String product;
  String mode;
  int ciCustomer;
  Sale(this.quantity, this.product, this.mode, this.ciCustomer);

  Map generateMap() {
    Map finalProduct = {
      'quantity': quantity,
      'product': product,
      'mode': mode,
      'ciCustomer': ciCustomer
    };
    return finalProduct;
  }
}
