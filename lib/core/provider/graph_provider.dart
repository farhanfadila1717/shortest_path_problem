import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riset_operasional/core/algoritm/dijktra.dart';
import 'package:riset_operasional/core/models/distances.dart';
import 'package:riset_operasional/core/models/node.dart';

final graphProvider = StateNotifierProvider<GraphNotifier, List<Node>>((ref) {
  return GraphNotifier();
});

const _testGraph = [
  [0, 4, 0, 0, 0, 0, 0, 8, 0],
  [4, 0, 8, 0, 0, 0, 0, 11, 0],
  [0, 8, 0, 7, 0, 4, 0, 0, 2],
  [0, 0, 7, 0, 9, 14, 0, 0, 0],
  [0, 0, 0, 9, 0, 10, 0, 0, 0],
  [0, 0, 4, 14, 10, 0, 2, 0, 0],
  [0, 0, 0, 0, 0, 2, 0, 1, 6],
  [8, 11, 0, 0, 0, 0, 1, 0, 7],
  [0, 0, 2, 0, 0, 0, 6, 7, 0]
];

class GraphNotifier extends StateNotifier<List<Node>> {
  GraphNotifier() : super([]);

  void buildGraph(int node) {
    state = List.generate(
      node,
      (i) => Node(
        id: i,
        distances: List.generate(
          node,
          (v) => Distances(
            toNode: Node(id: v, distances: const []),
            distance: 0,
          ),
        ),
      ),
    );
  }

  void reset() {
    state = [];
  }

  void insertDistances(
    int distance,
    int nodeId,
    int toNodeId,
  ) {
    final node = state.firstWhere((e) => e.id == nodeId);
    final toNode = state.firstWhere((e) => e.id == toNodeId);
    final newDistance = Distances(toNode: toNode, distance: distance);
    final reflectNewDistance = Distances(toNode: node, distance: distance);
    final distances = node.distances;
    final reflectDistances = toNode.distances;

    final distancesUpdate =
        distances.firstWhere((e) => e.toNode.id == toNodeId);
    final distancesUpdateIndex = distances.indexOf(distancesUpdate);

    final reflectDistancesUpdate =
        reflectDistances.firstWhere((e) => e.toNode.id == nodeId);
    final reflectDistancesUpdateIndex =
        reflectDistances.indexOf(reflectDistancesUpdate);

    distances.removeWhere((e) => e == distancesUpdate);
    distances.insert(distancesUpdateIndex, newDistance);

    reflectDistances.removeWhere((e) => e == reflectDistancesUpdate);
    reflectDistances.insert(
      reflectDistancesUpdateIndex,
      reflectNewDistance,
    );

    state = [
      for (final item in state)
        if (item == node) item.copyWith(distances: distances) else item
    ];
  }

  List<List<int>> toGraph() {
    List<List<int>> graph = [];

    for (int i = 0; i < state.length; i++) {
      final Node node = state[i];
      List<int> distances = [];

      for (int y = 0; y < node.distances.length; y++) {
        distances.add(node.distances[y].distance);
      }

      graph.add(distances);
    }

    return graph;
  }

  ResultsDijsktra calculate({
    required int source,
    required int destination,
  }) {
    final graph = toGraph();

    final dijkstra = Dijkstra.instance(graph.length);

    return dijkstra.dijkstra(graph, source, destination);
  }

  void useTestGraph() {
    List<Node> temp = [];
    for (int i = 0; i < _testGraph.length; i++) {
      final node = _testGraph[i];
      List<Distances> distances = [];
      for (int y = 0; y < node.length; y++) {
        distances.add(
          Distances(
            toNode: Node(id: y, distances: const []),
            distance: node[y],
          ),
        );
      }
      temp.add(Node(id: i, distances: distances));
    }

    state = temp;
  }
}
