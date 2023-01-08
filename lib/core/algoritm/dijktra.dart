const int kMaxInt = 32767;

class Dijkstra {
  final int vertexCount;

  static Dijkstra instance(int vertexCount) =>
      Dijkstra(vertexCount: vertexCount);

  const Dijkstra({
    required this.vertexCount,
  });

  int minDistance(List<int> dist, List<bool> sptSet) {
    // initialisasi nilai minimal
    int min = kMaxInt, minIndex = -1;

    for (int i = 0; i < vertexCount; i++) {
      if (sptSet[i] == false && dist[i] <= min) {
        min = dist[i];
        minIndex = i;
      }
    }

    return minIndex;
  }

  ResultsDijsktra dijkstra(List<List<int>> graph, int source, int destination) {
    List<int> dist = [];

    List<bool> sptSet = [];

    List<Step> steps = [];

    /// Inisialisasi semua jarak dengan jarak maksimal
    /// dan mengisi semua nilai di sptSet false
    for (int i = 0; i < vertexCount; i++) {
      dist.add(kMaxInt);
      sptSet.add(false);
    }

    /// Jarak dari sumber vertex itu sendiri adalah 0
    dist[source] = 0;

    /// Mencari jalur terpendek dari semua vertex
    for (int count = 0; count < vertexCount; count++) {
      /// Memilih nilai jarak terkecil dari semua nilai
      /// vertex yang belum di proses
      int u = minDistance(dist, sptSet);

      /// Menandai kalo nilai dari vertex telah diproses
      sptSet[u] = true;

      /// Memperbaharui nilai jarak dari vertex yang terpilih
      for (int v = 0; v < vertexCount; v++) {
        /// Memperbaharui nilai jarak/ dist[i] hanya jika tidak ada di sptSet
        /// ada sisi dari u ke v, dan total nilai
        /// jalur dari source ke v melalui u adalah
        /// lebih kecil dari nilai dist[v] saat ini
        if (!sptSet[v] &&
            graph[u][v] != 0 &&
            dist[u] != kMaxInt &&
            dist[u] + graph[u][v] < dist[v]) {
          dist[v] = dist[u] + graph[u][v];
          steps.add(Step(dist.indexOf(dist[v]), u, dist[v]));
        }
      }
    }

    int currentBackStep = destination;
    List<int> backStep = [];
    List<int> distances = [];
    for (int i = steps.length - 1; i > 0; i--) {
      final step = steps[i];

      if (step.index == currentBackStep) {
        distances.add(step.value);
        backStep.add(step.index);
        currentBackStep = step.fromIndex;
        if (step.fromIndex == source) {
          backStep.add(source);
          distances.add(0);
        }
      }
    }

    return ResultsDijsktra(
      source: source,
      destination: destination,
      steps: backStep.reversed.toList(),
      distances: distances.reversed.toList(),
    );
  }
}

class Step {
  final int index;
  final int fromIndex;
  final int value;

  const Step(this.index, this.fromIndex, this.value);

  @override
  String toString() =>
      'Step(index = $index, fromIndex = $fromIndex, value = $value)';
}

class ResultsDijsktra {
  final int source;
  final int destination;
  final List<int> steps;
  final List<int> distances;

  const ResultsDijsktra({
    required this.source,
    required this.destination,
    required this.steps,
    required this.distances,
  });

  factory ResultsDijsktra.empty() => const ResultsDijsktra(
        source: 0,
        destination: 1,
        steps: [],
        distances: [],
      );

  @override
  String toString() =>
      "ResultsDijsktra(source: $source, destination: $destination, steps: $steps,distances: $distances)";

  ResultsDijsktra copyWith({
    int? source,
    int? destination,
    List<int>? steps,
    List<int>? distances,
  }) {
    return ResultsDijsktra(
      source: source ?? this.source,
      destination: destination ?? this.destination,
      steps: steps ?? this.steps,
      distances: distances ?? this.distances,
    );
  }
}
