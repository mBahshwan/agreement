import 'package:agreement_app/app/bicycle/add_bicycle_view_model.dart';
import 'package:agreement_app/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBicyclePage extends ConsumerWidget {
  AddBicyclePage({Key? key}) : super(key: key);
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bicycle'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                lableText: "name",
                controller: _controller,
                onChanged: (value) => ref
                    .read(addBicycleViewModelProvider.notifier)
                    .setName(value),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => ref
                    .watch(addBicycleViewModelProvider.notifier)
                    .addBicycle(context),
                child: const Text('Add bicycle'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
