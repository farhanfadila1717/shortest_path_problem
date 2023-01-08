import 'dart:async';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riset_operasional/core/provider/dijkstra_provider.dart';

class ResultsPage extends ConsumerStatefulWidget {
  const ResultsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResultsPageState();
}

class _ResultsPageState extends ConsumerState<ResultsPage>
    with AfterLayoutMixin {
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    _controllerCenter.play();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final dijkstra = ref.watch(dijkstraProvider);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Resutls'),
          ),
          body: SizedBox.expand(
            child: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                      child: Text(
                        'Step yang dilalui dari source ke final destination',
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: size.width,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemBuilder: (_, index) {
                          final item = dijkstra.steps[index];

                          return SizedBox.square(
                            dimension: 50,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == dijkstra.source
                                    ? Colors.amber
                                    : index == dijkstra.destination
                                        ? Colors.green
                                        : Colors.blue,
                              ),
                              child: Center(
                                  child: Text(
                                '$item',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            ),
                          );
                        },
                        separatorBuilder: (_, index) {
                          final dist = dijkstra.distances[index + 1];
                          return SizedBox(
                            height: 50,
                            width: 45,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                                ColoredBox(
                                    color: Colors.white, child: Text('$dist')),
                              ],
                            ),
                          );
                        },
                        itemCount: dijkstra.steps.length,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                      child: Text('Total jarak ${dijkstra.distances.last}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/');
                        },
                        child: const Text('Hitung kembali'),
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _controllerCenter,
                    blastDirectionality: BlastDirectionality
                        .explosive, // don't specify a direction, blast randomly
                    shouldLoop:
                        true, // start again as soon as the animation is finished
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple
                    ], // manually specify the colors to be used
                    createParticlePath: drawStar, // define a custom shape/path.
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
