import 'package:flutter_test/flutter_test.dart';

bool isPrime(int num) {
  if (num < 2) return false;
  for (int i = 2; i * i <= num; i++) {
    if (num % i == 0) {
      return false;
    }
  }
  return true; 
}


int sumDigits(int num) {
  if (num < 0) {
    throw ArgumentError('Número negativo não permitido');
  }
  int sum = 0;
  while (num > 0) {
    sum += num % 10; // Obtém o último dígito e soma
    num ~/= 10; // Remove o último dígito
  }
  return sum;
}

void main() {
  group('Testes de número primo', () {
    test('Verifica se 7 é primo', () {
      expect(isPrime(7), isTrue);
    });

    test('Verifica se 10 não é primo', () {
      expect(isPrime(10), isFalse);
    });

    test('Verifica se 1 não é primo', () {
      expect(isPrime(1), isFalse);
    });
  });

  group('Testes da soma dos dígitos', () {
    test('Soma dos dígitos de 123 deve ser 6', () {
      expect(sumDigits(123), equals(6));
    });

    test('Soma dos dígitos de 987 deve ser 24', () {
      expect(sumDigits(987), equals(24));
    });

    test('Erro ao passar número negativo', () {
      expect(() => sumDigits(-123), throwsArgumentError);
    });
  });
}
