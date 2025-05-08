import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


class AvgPage extends StatefulWidget {
  const AvgPage({super.key, this.fetchFnOverride});

  
  final Future<int> Function()? fetchFnOverride;

  @override
  State<AvgPage> createState() => _AvgPageState();
}

class _AvgPageState extends State<AvgPage> {
  final _names = ['Ana', 'Bruno', 'Carla', 'Diego', 'Eduarda'];
  Stream<double>? _avg$;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Média')),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ElevatedButton(
              onPressed: () => setState(
                () => _avg$ = average(
                  _names,
                  fetchFn: widget.fetchFnOverride, 
                ),
              ),
              child: const Text('Calcular'),
            ),
            const SizedBox(height: 20),
            if (_avg$ != null)
              StreamBuilder<double>(
                stream: _avg$,
                builder: (_, snap) => Text(
                  snap.hasData
                      ? 'Média: ${snap.data!.toStringAsFixed(2)}'
                      : snap.connectionState == ConnectionState.waiting
                          ? 'Buscando...'
                          : 'Concluído',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
          ]),
        ),
      );
}

Future<int> fetchScore() async => Future.delayed(
      Duration(milliseconds: 500 + Random().nextInt(1500)),
      () => 50 + Random().nextInt(51),
    );


Stream<double> average(List<String> names,
    {Future<int> Function()? fetchFn}) async* {
  var sum = 0;
  final getScore = fetchFn ?? fetchScore;
  for (var i = 0; i < names.length; i++) {
    sum += await getScore();
    yield sum / (i + 1);
  }
}

void main() {
  group('average() – lógica pura', () {
    test('emite uma média por nome', () async {
      const names = ['Ana', 'Bruno', 'Carla'];
      final fixed = [80, 90, 70];
      var idx = 0;
      Future<int> fakeFetch() async => fixed[idx++];

      final result = await average(names, fetchFn: fakeFetch).toList();
      expect(result, [80.0, 85.0, 80.0]);
    });
  });

  group('AvgPage – widget', () {
    testWidgets('fluxo visual básico', (tester) async {
      
      Future<int> fakeFetch() async => 100;

      await tester.pumpWidget(
        MaterialApp(home: AvgPage(fetchFnOverride: fakeFetch)),
      );

      
      expect(find.text('Calcular'), findsOneWidget);

      await tester.tap(find.text('Calcular'));
      await tester.pump(); // 1º frame: “Buscando...”
      expect(find.text('Buscando...'), findsOneWidget);

      
      await tester.pumpAndSettle();
      expect(find.text('Buscando...'), findsNothing);
      expect(find.text('Média: 100.00'), findsOneWidget);
    });
  });
}
