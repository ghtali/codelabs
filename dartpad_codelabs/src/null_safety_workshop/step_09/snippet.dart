import 'dart:math';

class RandomStringProvider {
  String? get value =>
    Random().nextBool() ? 'A String!' : null;
}

void printString(String str) => print(str);

void main() {
  final provider = RandomStringProvider();

  if (provider.value == null) {
    print('The value is null.');
  } else {
    print('The value is not null.');
  }

  printString(provider.value);
}
