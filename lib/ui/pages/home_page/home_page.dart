import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riset_operasional/core/provider/dijkstra_provider.dart';
import 'package:riset_operasional/core/provider/graph_provider.dart';
import 'package:riset_operasional/ui/pages/home_page/components/graph_view.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '3');
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final graph = ref.watch(graphProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dijkstra'),
      ),
      body: Scrollbar(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: [
            const Text(
              'Jumlah Node',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    final n = int.tryParse(_controller.text) ?? 0;

                    if (n < 3) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Jumlah node harus lebih dari 3'),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      ref.watch(graphProvider.notifier).buildGraph(n);
                    }
                  },
                  child: const Text('Buat'),
                ),
                const SizedBox(width: 10),
                if (graph.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      ref.watch(graphProvider.notifier).reset();
                      ref.watch(dijkstraProvider.notifier).reset();
                    },
                    child: const Text('Reset'),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      ref.watch(graphProvider.notifier).useTestGraph();
                      ref.watch(dijkstraProvider.notifier).updateSource(0);
                      ref.watch(dijkstraProvider.notifier).updateDestination(4);
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green),
                    ),
                    child: const Text('Use test data'),
                  ),
              ],
            ),
            const SizedBox(height: 30),
            const GraphView(),
            const SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: graph.isNotEmpty,
        child: ElevatedButton(
          onPressed: () {
            final graph = ref.watch(graphProvider.notifier).toGraph();
            ref.watch(dijkstraProvider.notifier).calculate(graph: graph);

            context.go('/results');
          },
          child: const Text('Calculate'),
        ),
      ),
    );
  }
}
