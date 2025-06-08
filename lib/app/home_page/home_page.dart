import 'package:agreement_app/app/agreement/create_agreement.dart';
import 'package:agreement_app/app/bicycle/add_bicycle_page.dart';
import 'package:agreement_app/app/home_page/home_view_model.dart';
import 'package:agreement_app/app/models/userModel.dart';
import 'package:agreement_app/app/visitors_page/visitors_page.dart';
import 'package:agreement_app/core/constant/firebase_client.dart';
import 'package:agreement_app/core/helpers.dart';
import 'package:agreement_app/core/widgets/agreement_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    final agreementProvider = ref.watch(homeViewModelProvider.notifier);

    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Card(
              color: Colors.indigo[200]!.withOpacity(0.3),
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  'Visitors',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onTap: () => Helpers.navigateToPush(context, VisitorsPage()),
              ),
            ),
            Card(
              color: Colors.indigo[200]!.withOpacity(0.3),
              child: ListTile(
                leading: Icon(Icons.bike_scooter_rounded),
                title: Text(
                  'Add Bicycle',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onTap: () => Helpers.navigateToPush(context, AddBicyclePage()),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: agreements.when(
          loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
          data: (data) {
            final activeAgreements = data.agreements!
                .where((a) => a.state == AgreementState.ACTIVE)
                .toList();
            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(homeViewModelProvider.notifier).getAgreements(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      ListView.builder(
                        itemCount: activeAgreements.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final agreement = activeAgreements[index];

                          final isActive = _isAgreementActive(agreement);

                          return AgreementCard(
                              agreement: agreement,
                              agreementState: _getAgreementStateText(
                                  agreement.state ?? AgreementState.ACTIVE),
                              stateColor:
                                  isActive ? Colors.green : Colors.orange,
                              startDate:
                                  '${_formatDateTime(agreement.timeStart)}',
                              endDate:
                                  '${{_formatDateTime(agreement.timeEnd)}}',
                              onTap: () async {
                                try {
                                  // 1. Get reference to the visitor document
                                  final visitorRef = FirebaseFirestore.instance
                                      .collection('visitors')
                                      .doc(agreement.userId.toString());

                                  // 2. Get current agreements
                                  final doc = await visitorRef.get();
                                  final allAgreements =
                                      List<Map<String, dynamic>>.from(
                                          doc['agreements'] ?? []);

                                  // 3. Find the EXACT agreement in Firestore by unique identifier
                                  final clickedAgreement =
                                      agreement; // The agreement from your card
                                  final firestoreIndex =
                                      allAgreements.indexWhere((a) {
                                    // Convert Firestore Timestamp to DateTime for comparison
                                    final firestoreDateTime = a['timeStart']
                                            is Timestamp
                                        ? (a['timeStart'] as Timestamp).toDate()
                                        : a['timeStart'] as DateTime?;

                                    return firestoreDateTime != null &&
                                        clickedAgreement.timeStart != null &&
                                        firestoreDateTime.isAtSameMomentAs(
                                            clickedAgreement.timeStart!) &&
                                        a['userId'] == clickedAgreement.userId;
                                  });

                                  if (firestoreIndex == -1)
                                    throw Exception(
                                        'Agreement not found in Firestore');

                                  // 4. Create updated agreement with ALL original fields
                                  final updatedAgreement = {
                                    ...allAgreements[
                                        firestoreIndex], // Keep all original data
                                    'state': agreementStateValues
                                        .reverse[AgreementState.EXPIRED],
                                  };

                                  // 5. Update using transaction for safety
                                  await FirebaseFirestore.instance
                                      .runTransaction((transaction) async {
                                    transaction.update(visitorRef, {
                                      'agreements': FieldValue.arrayRemove(
                                          [allAgreements[firestoreIndex]])
                                    });
                                    transaction.update(visitorRef, {
                                      'agreements': FieldValue.arrayUnion(
                                          [updatedAgreement])
                                    });
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Successfully updated agreement')),
                                  );
                                  Helpers.navigateToPushAndRemoveUntil(
                                      context, HomePage());
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Error: ${e.toString()}')),
                                  );
                                }
                              });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          error: (error, stack) {
            print(error);
            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(homeViewModelProvider.notifier).getAgreements(),
              child: Padding(
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

  bool _isAgreementActive(Agreement agreement) {
    final now = DateTime.now();
    final start = agreement.timeStart ?? now;
    final end = agreement.timeEnd ?? now;

    return now.isAfter(start) && now.isBefore(end);
  }
}
