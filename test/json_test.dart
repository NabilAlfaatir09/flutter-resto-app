import 'package:flutter_test/flutter_test.dart';

var sampleRestaurant = {
  "id": "rqdv5juczeskfw1e867",
  "name": "Melting Pot",
  "description":
      "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
  "pictureId": "14",
  "city": "Medan",
  "rating": 4.2
};

void main() {
  test("Test Parsing Json", () async {
    Object? id = sampleRestaurant['id'];
    Object? name = sampleRestaurant['name'];

    expect(id, "rqdv5juczeskfw1e867");
    expect(name, "Melting Pot");
  });
}
