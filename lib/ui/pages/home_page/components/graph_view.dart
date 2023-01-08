import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riset_operasional/core/models/distances.dart';
import 'package:riset_operasional/core/models/node.dart';
import 'package:riset_operasional/core/provider/dijkstra_provider.dart';
import 'package:riset_operasional/core/provider/graph_provider.dart';

class GraphView extends ConsumerWidget {
  const GraphView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graph = ref.watch(graphProvider);
    final resultsDijsktra = ref.watch(dijkstraProvider);

    if (graph.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          graph.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Node $index',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SourceButton(
                      selected: resultsDijsktra.source == index,
                      onTap: () => ref
                          .watch(dijkstraProvider.notifier)
                          .updateSource(index),
                    ),
                    const SizedBox(width: 10),
                    DestinationButton(
                      selected: resultsDijsktra.destination == index,
                      onTap: () => ref
                          .watch(dijkstraProvider.notifier)
                          .updateDestination(index),
                    ),
                  ],
                ),
                ...List.generate(graph.length, (destinationIndex) {
                  if (index == destinationIndex) {
                    return const SizedBox.shrink();
                  } else {
                    final node = graph.firstWhere((e) => e.id == index);
                    final distances = node.distances
                        .firstWhere((e) => e.toNode.id == destinationIndex);

                    return GraphItem(node: node, distances: distances);
                  }
                }),
                const Divider(),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class GraphItem extends ConsumerStatefulWidget {
  final Node node;
  final Distances distances;

  const GraphItem({
    super.key,
    required this.node,
    required this.distances,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GraphItemState();
}

class _GraphItemState extends ConsumerState<GraphItem> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant GraphItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.distances != oldWidget.distances) {
      _controller.clear();
      _controller.value = TextEditingValue(
        text: '${widget.distances.distance}',
        selection: TextSelection.collapsed(
          offset: '${widget.distances.distance}'.length,
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text('Jarak ke Node ${widget.distances.toNode.id}'),
        ),
        Expanded(
          child: TextField(
            controller: _controller,
            onChanged: (value) {
              final distance = int.tryParse(value) ?? 0;
              ref.watch(graphProvider.notifier).insertDistances(
                    distance,
                    widget.node.id,
                    widget.distances.toNode.id,
                  );
            },
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              hintText: '${widget.distances.distance}',
            ),
          ),
        ),
      ],
    );
  }
}

class SourceButton extends StatelessWidget {
  const SourceButton({
    super.key,
    required this.selected,
    required this.onTap,
  });

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox.square(
            dimension: 16,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: selected ? Colors.amber : Colors.transparent,
                shape: BoxShape.circle,
                border: selected
                    ? null
                    : Border.all(
                        color: Colors.grey,
                      ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Text('Source'),
        ],
      ),
    );
  }
}

class DestinationButton extends StatelessWidget {
  const DestinationButton({
    super.key,
    required this.selected,
    required this.onTap,
  });

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox.square(
            dimension: 16,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: selected ? Colors.green : Colors.transparent,
                shape: BoxShape.circle,
                border: selected
                    ? null
                    : Border.all(
                        color: Colors.grey,
                      ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          const Text('Destination'),
        ],
      ),
    );
  }
}
