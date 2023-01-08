import 'package:equatable/equatable.dart';

import 'node.dart';

class Distances extends Equatable {
  final Node toNode;
  final int distance;

  const Distances({
    required this.toNode,
    required this.distance,
  });

  Distances copyWith({
    Node? toNode,
    int? distance,
  }) {
    return Distances(
      toNode: toNode ?? this.toNode,
      distance: distance ?? this.distance,
    );
  }

  @override
  String toString() => "Distances(toNode: $toNode, distance : $toNode)";

  @override
  List<Object?> get props => [
        toNode,
        distance,
      ];
}
