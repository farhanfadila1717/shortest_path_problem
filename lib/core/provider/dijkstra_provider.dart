import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riset_operasional/core/algoritm/dijktra.dart';

final dijkstraProvider =
    StateNotifierProvider<DijkstraNotifier, ResultsDijsktra>(
  (ref) => DijkstraNotifier(),
);

class DijkstraNotifier extends StateNotifier<ResultsDijsktra> {
  DijkstraNotifier() : super(ResultsDijsktra.empty());

  void updateSource(int value) {
    state = state.copyWith(source: value);
  }

  void updateDestination(int value) {
    state = state.copyWith(destination: value);
  }

  void reset() {
    state = ResultsDijsktra.empty();
  }

  void calculate({
    required List<List<int>> graph,
  }) {
    final dijkstra = Dijkstra.instance(graph.length);

    state = dijkstra.dijkstra(graph, state.source, state.destination);
  }
}
