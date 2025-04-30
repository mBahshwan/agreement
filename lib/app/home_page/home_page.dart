import 'package:agreement_app/app/agreement/create_agreement.dart';
import 'package:agreement_app/app/home_page/home_view_model.dart';
import 'package:agreement_app/app/models/userModel.dart';
import 'package:agreement_app/core/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeViewModelProvider.notifier).getAgreements();
    });
    super.initState();
  }

  String _getAgreementStateText(AgreementState state) {
    switch (state) {
      case AgreementState.PENDING:
        return 'Pending';
      case AgreementState.ACTIVE:
        return 'Active';
      case AgreementState.EXPIRED:
        return 'Expired';
    }
  }

  // Format date as YYYY-MM-DD
  static String formatDate(DateTime? date) {
    if (date == null) return '--';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Format time as HH:MM (24-hour format)
  static String formatTime(DateTime? time) {
    if (time == null) return '--:--';
    return DateFormat('HH:mm').format(time);
  }

  // Format date and time together
  static String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-- --:--';
    return '${formatDate(dateTime)} ${formatTime(dateTime)}';
  }

  @override
  Widget build(BuildContext context) {
    final agreements = ref.watch(homeViewModelProvider);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: agreements.when(
          loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
          data: (data) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    ListView.builder(
                      itemCount: data.agreements?.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: 30,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        _getAgreementStateText(
                                            data.agreements![index].state ??
                                                AgreementState.PENDING),
                                        style: textTheme.bodySmall
                                            ?.copyWith(color: Colors.white),
                                      ),
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          data.agreements?[index].bicycleName
                                                  .toString() ??
                                              '',
                                          style: textTheme.titleMedium,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Duration: ${data.agreements?[index].duration.toString() ?? ''}',
                                      style: textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Start: ${_formatDateTime(data.agreements?[index].timeStart)}',
                                      style: textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'End: ${_formatDateTime(data.agreements?[index].timeEnd)}',
                                      style: textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
          error: (error, stack) {
            print(error);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      error.toString(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'create new agreement by clicking the button below',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here
          Helpers.navigateToPush(context, CreateAgreementPage());
        },
        child: const Icon(Icons.add),
      ),
      // SingleChildScrollView(child: Column(children: [ ],),)
    );
  }
}
