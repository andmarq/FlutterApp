import 'package:test/test.dart';

Map<String, double> calcularMedias(Map<String, List<double>> notas) {
  final medias = <String, double>{};

  notas.forEach((aluna, notasAluna) {
    final soma = notasAluna.reduce((a, b) => a + b);
    final media = soma / notasAluna.length;
    medias[aluna] = media;
  });

  return medias;
}

void main() {
  test('Calcular médias', () {
    final notas = {
      'Maria': [9.0, 8.0],
      'Carla': [8.5, 8.5],
      'Elena': [7.5, 9.5],
      'Luiza': [8.0, 9.0],
    };

    final medias = calcularMedias(notas);

    expect(medias, {
      'Maria': 8.5,
      'Carla': 8.5,
      'Elena': 8.5,
      'Luiza': 8.5,
    });
  });
}
