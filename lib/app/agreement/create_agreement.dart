import 'package:agreement_app/app/agreement/create_agreement_view_model.dart';
import 'package:agreement_app/app/models/userModel.dart';
import 'package:agreement_app/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateAgreementPage extends ConsumerWidget {
  CreateAgreementPage({Key? key}) : super(key: key);
  final TextEditingController vistorNameController = TextEditingController();
  final TextEditingController vistorNumberController = TextEditingController();
  final TextEditingController vistorIdController = TextEditingController();
  final TextEditingController bicycleNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  List<Agreement> agreements = [];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createAgreementViewModel =
        ref.watch(createAgreementViewModelProvider);
    final createAgreementProvider =
        ref.watch(createAgreementViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Agreement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Agreement Details',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Visteor Details',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              CustomTextField(
                  lableText: 'name', controller: vistorNameController),
              const SizedBox(height: 16),
              CustomTextField(
                lableText: 'number',
                controller: vistorNumberController,
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                lableText: 'ID',
                controller: vistorIdController,
                textInputType: TextInputType.number,
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              const SizedBox(height: 16),
              Text(
                'Agreement Details',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                lableText: 'bicycle name',
                controller: bicycleNameController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                lableText: 'description',
                controller: descriptionController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                lableText: 'duratuion in minutes',
                controller: durationController,
                textInputType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () {
                  final agreement = Agreement(
                    bicycleName: bicycleNameController.text,
                    description: descriptionController.text,
                    duration: int.parse(durationController.text),
                    timeStart: DateTime.now(),
                    timeEnd: DateTime.now().add(
                        Duration(minutes: int.parse(durationController.text))),
                    userId: int.parse(vistorIdController.text),
                    state: AgreementState.ACTIVE,
                  );
                  agreements.add(agreement);
                  agreements.forEach((element) {
                    print('user id: ${element.userId}');
                  });

                  final userModel = UserModel(
                      name: vistorNameController.text,
                      phoneNumber: int.parse(vistorNumberController.text),
                      userId: int.parse(vistorIdController.text),
                      agreements: agreements);
                  // Handle save action
                  createAgreementProvider.createAgreement(userModel, context);
                },
                child: const Text('Save Agreement'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
