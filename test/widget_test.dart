import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/data/products_data.dart';

void main() {
  test('product catalogue is loaded', () {
    expect(kProducts.length, 30);
    expect(kProducts.first.name, 'Millennium Falcon Replica');
  });
}
