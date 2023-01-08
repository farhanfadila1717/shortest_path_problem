// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'distances.dart';

class Node extends Equatable {
  final int id;
  final List<Distances> distances;

  const Node({
    required this.id,
    required this.distances,
  });

  Node copyWith({
    int? id,
    List<Distances>? distances,
  }) {
    return Node(
      id: id ?? this.id,
      distances: distances ?? this.distances,
    );
  }

  @override
  List<Object?> get props => [id, distances];
}
