import 'package:agreement_app/app/agreement/create_agreement.dart';
import 'package:agreement_app/app/models/userModel.dart';
import 'package:agreement_app/app/visitors_page/visitors_view_model.dart';
import 'package:agreement_app/core/widgets/agreement_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class VisitorDetails extends ConsumerWidget {
  final List<Agreement> agreements;
  const VisitorDetails({super.key, required this.agreements});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visitor Details'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: agreements.length,
            itemBuilder: (context, index) {
              final agreement = agreements[index];
              final isActive = _isAgreementActive(agreement);
              return FutureBuilder<UserModel?>(
                future: ref
                    .read(visitorsViewModelProvider.notifier)
                    .fetchVisitorById(agreement.userId.toString()),
                builder: (context, snapshot) {
                  return AgreementCard(
                    agreement: agreement,
                    agreementState: _getAgreementStateText(
                        agreement.state ?? AgreementState.ACTIVE),
                    stateColor: isActive ? Colors.green : Colors.orange,
                    startDate: '${_formatDateTime(agreement.timeStart)}',
                    endDate: '${_formatDateTime(agreement.timeEnd)}',
                    onTap: () {},
                    userModel: snapshot.data,
                    isCheckShown: false,
                  );
                },
              );
            },
          ))
        ],
      ),
    );
  }

  bool _isAgreementActive(Agreement agreement) {
    final now = DateTime.now();
    final start = agreement.timeStart ?? now;
    final end = agreement.timeEnd ?? now;

    return now.isAfter(start) && now.isBefore(end);
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

  // Format time as HH:MM (24-hour format)
  static String formatTime(DateTime? time) {
    if (time == null) return '--:--';
    return DateFormat('HH:mm').format(time);
  }

  // Format date as YYYY-MM-DD
  static String formatDate(DateTime? date) {
    if (date == null) return '--';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-- --:--';
    return '${formatDate(dateTime)} ${formatTime(dateTime)}';
  }
}
