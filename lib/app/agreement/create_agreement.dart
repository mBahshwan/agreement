import 'package:agreement_app/app/agreement/create_agreement_view_model.dart';
import 'package:agreement_app/app/models/bicycle_model.dart';
import 'package:agreement_app/app/models/userModel.dart';
import 'package:agreement_app/core/widgets/custom_text_field.dart';
import 'package:agreement_app/core/widgets/duration_sluts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// class CreateAgreementPage extends ConsumerWidget {
//   final UserModel? userModel;
//   final Agreement? agreement;
//   CreateAgreementPage({Key? key, this.userModel, this.agreement})
//       : super(key: key);
//   late final TextEditingController visitorNameController;
//   late final TextEditingController visitorNumberController;
//   late final TextEditingController visitorIdController;
//   late final TextEditingController durationController = TextEditingController();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final createAgreementViewModel =
//         ref.watch(createAgreementViewModelProvider);
//     final createAgreementProvider =
//         ref.read(createAgreementViewModelProvider.notifier);
//     final bicycleFields = ref.watch(bicycleFieldsProvider);
//     final bicycleFieldsNotifier = ref.read(bicycleFieldsProvider.notifier);

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (userModel != null) {
//         // Use userModel data here
//         print('User ID: ${userModel!.userId}');
//         print('User Name: ${userModel!.name}');
//         for (var agr in userModel!.agreements!) {
//           if (agr.timeStart == agreement!.timeStart) {
//             print(agr.duration);
//           }
//         }
//         // You can also update your providers with userModel data
//         // createAgreementProvider.setUserData(userModel!);
//       }
//     });
//     visitorIdController =
//         TextEditingController(text: userModel?.userId.toString());
//     visitorNameController = TextEditingController(text: userModel?.name);
//     visitorNumberController =
//         TextEditingController(text: userModel?.phoneNumber.toString());

//     return Scaffold(
//       appBar: AppBar(title: const Text('Create Agreement')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Enter Agreement Details',
//                   style: Theme.of(context).textTheme.headlineMedium),
//               const SizedBox(height: 16),

//               // Visitor Details Section
//               _buildVisitorDetailsSection(context),

//               // Bicycle Details Section
//               _buildBicycleDetailsSection(
//                   context, bicycleFields, bicycleFieldsNotifier),

//               // Duration Selection
//               _buildDurationSection(context, createAgreementProvider),

//               // Save Button
//               _buildSaveButton(context, ref, bicycleFields),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
class CreateAgreementPage extends ConsumerStatefulWidget {
  final UserModel? userModel;
  final Agreement? agreement;

  const CreateAgreementPage({super.key, this.userModel, this.agreement});

  @override
  ConsumerState<CreateAgreementPage> createState() =>
      _CreateAgreementPageState();
}

class _CreateAgreementPageState extends ConsumerState<CreateAgreementPage> {
  // Declare your controllers here. They will be initialized in initState.
  late final TextEditingController visitorNameController;
  late final TextEditingController visitorNumberController;
  late final TextEditingController visitorIdController;
  late final TextEditingController durationController;

  @override
  void initState() {
    super.initState();

    // --- INITIALIZE CONTROLLERS ONCE ---
    // This code now runs only one time when the widget is first created.
    // We use `widget.` to access the properties from the CreateAgreementPage class.
    visitorIdController =
        TextEditingController(text: widget.userModel?.userId.toString());
    visitorNameController = TextEditingController(text: widget.userModel?.name);
    visitorNumberController =
        TextEditingController(text: widget.userModel?.phoneNumber.toString());
    durationController = TextEditingController();

    // --- HANDLE ONE-TIME LOGIC ---
    // This is also a great place for logic that should only run once.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.userModel != null) {
        // Use userModel data here
        print('User ID: ${widget.userModel!.userId}');
        print('User Name: ${widget.userModel!.name}');
        for (var agr in widget.userModel!.agreements!) {
          if (agr.timeStart == widget.agreement!.timeStart) {
            print(agr.duration);
          }
        }
        // You can also update your providers with userModel data
        // ref.read(createAgreementViewModelProvider.notifier).setUserData(widget.userModel!);
      }
    });
  }

  @override
  void dispose() {
    // --- CLEAN UP CONTROLLERS ---
    // This is crucial to prevent memory leaks when the widget is removed.
    visitorNameController.dispose();
    visitorNumberController.dispose();
    visitorIdController.dispose();
    durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // `ref` is now a property of the state class, so you can access it directly.
    final createAgreementViewModel =
        ref.watch(createAgreementViewModelProvider);
    final createAgreementProvider =
        ref.read(createAgreementViewModelProvider.notifier);
    final bicycleFields = ref.watch(bicycleFieldsProvider);
    final bicycleFieldsNotifier = ref.read(bicycleFieldsProvider.notifier);
    final availableBicyclesAsync = ref.watch(bicyclesProvider);

    // The controllers are already initialized, so we don't create them here anymore.
    return Scaffold(
      appBar: AppBar(title: const Text('Create Agreement')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter Agreement Details',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),

              // Visitor Details Section
              _buildVisitorDetailsSection(context),

              // Bicycle Details Section
              _buildBicycleDetailsSection(
                  context, bicycleFields, bicycleFieldsNotifier),

              // Duration Selection
              _buildDurationSection(context, createAgreementProvider),

              // Save Button
              _buildSaveButton(context, ref, bicycleFields),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisitorDetailsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Visitor Details', style: Theme.of(context).textTheme.bodyLarge),
        CustomTextField(lableText: 'name', controller: visitorNameController),
        const SizedBox(height: 16),
        CustomTextField(
          lableText: 'number',
          controller: visitorNumberController,
          textInputType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          lableText: 'ID',
          controller: visitorIdController,
          textInputType: TextInputType.number,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBicycleDetailsSection(
    BuildContext context,
    List<BicycleField> bicycleFields,
    BicycleFieldsNotifier notifier,
  ) {
    final bicyclesAsync = ref.watch(bicyclesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Agreement Details', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        bicyclesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text('Error loading bicycles: $error'),
          data: (availableBicycles) {
            return Column(
              children: [
                ...bicycleFields.asMap().entries.map((entry) {
                  final index = entry.key;
                  final field = entry.value;

                  return Column(
                    children: [
                      // Bicycle Name Dropdown
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Bicycle Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<BicycleModel>(
                            value: field.nameController.text.isEmpty
                                ? null
                                : availableBicycles.firstWhere(
                                    (bike) =>
                                        bike.name == field.nameController.text,
                                    orElse: () => BicycleModel(name: null)),
                            isExpanded: true,
                            hint: const Text('Select a bicycle'),
                            items: availableBicycles.map((BicycleModel bike) {
                              return DropdownMenuItem<BicycleModel>(
                                value: bike,
                                child: Text(bike.name ?? ''),
                              );
                            }).toList(),
                            onChanged: (BicycleModel? newValue) {
                              if (newValue != null && newValue.name != null) {
                                field.nameController.text = newValue.name!;
                                notifier.state = [...notifier.state];
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description Field
                      CustomTextField(
                        lableText: 'description',
                        controller: field.descriptionController,
                      ),

                      // Remove Button (for additional fields)
                      if (index > 0)
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => notifier.removeField(index),
                          ),
                        ),
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList(),

                // Add Bicycle Button
                GestureDetector(
                  onTap: () => notifier.addField(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      const Text('Add one'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ],
    );
  }
  //// Widget _buildBicycleDetailsSection(
  //   BuildContext context,
  //   List<BicycleField> bicycleFields,
  //   BicycleFieldsNotifier notifier,
  // ) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text('Agreement Details', style: Theme.of(context).textTheme.bodyLarge),
  //       const SizedBox(height: 16),
  //       ...bicycleFields.asMap().entries.map((entry) {
  //         final index = entry.key;
  //         final field = entry.value;

  //         return Column(
  //           children: [
  //             CustomTextField(
  //               lableText: 'bicycle name',
  //               controller: field.nameController,
  //             ),
  //             const SizedBox(height: 16),
  //             CustomTextField(
  //               lableText: 'description',
  //               controller: field.descriptionController,
  //             ),
  //             if (index > 0) // Show remove button for additional fields
  //               Align(
  //                 alignment: Alignment.centerRight,
  //                 child: IconButton(
  //                   icon: const Icon(Icons.delete, color: Colors.red),
  //                   onPressed: () => notifier.removeField(index),
  //                 ),
  //               ),
  //             const SizedBox(height: 16),
  //           ],
  //         );
  //       }).toList(),

  //       // Add Bicycle Button
  //       GestureDetector(
  //         onTap: () => notifier.addField(),
  //         child: Row(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Container(
  //               width: 40,
  //               height: 40,
  //               decoration: const BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 color: Colors.blue,
  //               ),
  //               child: const Icon(Icons.add, color: Colors.white),
  //             ),
  //             const SizedBox(width: 8),
  //             const Text('Add one'),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 16),
  //     ],
  //   );
  // }

  Widget _buildDurationSection(
    BuildContext context,
    CreateAgreementViewModel createAgreementProvider,
  ) {
    return Column(
      children: [
        Row(
          children: [
            DurationSluts(
                onTap: () {
                  durationController.text = '30';
                  print(durationController.text);

                  createAgreementProvider.setDuration(durationController.text);
                  // print(
                  //     "the duration : ${createAgreementViewModel.value!.duration} ");
                },
                durationController: durationController,
                value: '30',
                text: '30 mins'),
            SizedBox(width: 10),
            DurationSluts(
                onTap: () {
                  durationController.text = '60';
                  print(durationController.text);

                  createAgreementProvider.setDuration(durationController.text);
                  // print(
                  //     "the duration : ${createAgreementViewModel.value!.duration} ");
                },
                durationController: durationController,
                value: '60',
                text: '60 mins')
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSaveButton(
    BuildContext context,
    WidgetRef ref,
    List<BicycleField> bicycleFields,
  ) {
    return ElevatedButton(
      onPressed: () => _saveAgreement(ref, bicycleFields, context),
      child: const Text('Save Agreement'),
    );
  }

  void _saveAgreement(
      WidgetRef ref, List<BicycleField> bicycleFields, BuildContext context) {
    final duration = int.tryParse(durationController.text) ?? 30;
    final userId = int.tryParse(visitorIdController.text) ?? 0;

    // Collect all bicycle names and descriptions
    final bicycleNames =
        bicycleFields.map((field) => field.nameController.text).toList();
    final bicycleDescriptions =
        bicycleFields.map((field) => field.descriptionController.text).toList();

    // Create a single agreement with lists of bicycles
    final agreement = Agreement(
      bicycleNames: bicycleNames,
      bicycleDesctiptions: bicycleDescriptions,
      duration: duration,
      timeStart: DateTime.now(),
      timeEnd: DateTime.now().add(Duration(minutes: duration)),
      userId: userId,
      state: AgreementState.ACTIVE,
    );

    final userModel = UserModel(
      name: visitorNameController.text,
      phoneNumber: int.tryParse(visitorNumberController.text) ?? 0,
      userId: userId,
      agreements: [agreement], // Single agreement containing all bikes
      visitingCount: 1, // Since it's one agreement with multiple bikes
    );

    ref
        .read(createAgreementViewModelProvider.notifier)
        .createAgreement(userModel, context);
  }
}
