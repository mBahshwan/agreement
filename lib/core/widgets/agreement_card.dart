import 'package:agreement_app/app/models/userModel.dart';
import 'package:flutter/material.dart';

class AgreementCard extends StatelessWidget {
  final Agreement agreement;
  final String agreementState;
  final Color stateColor;
  final String startDate;
  final String endDate;
  final VoidCallback onTap;
  const AgreementCard(
      {super.key,
      required this.agreement,
      required this.agreementState,
      required this.stateColor,
      required this.startDate,
      required this.endDate,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () => print(agreement.userId),
      child: Card(
        color: Colors.indigo[200]!.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: 60,
                        decoration: BoxDecoration(
                            color: stateColor,
                            //isActive ? Colors.green : Colors.orange,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          agreementState,
                          // _getAgreementStateText(
                          //     agreement.state ?? AgreementState.ACTIVE),
                          style: textTheme.bodySmall
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            agreement.bicycleName.toString() ?? '',
                            style: textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: onTap,
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                  ))
                ],
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Duration: ${agreement.duration.toString() ?? ''}',
                    style: textTheme.bodyMedium,
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Start $startDate',
                    //   'Start: ${_formatDateTime(agreement.timeStart)}',
                    style: textTheme.bodyMedium,
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'End $endDate',
                    //   'End: ${_formatDateTime(agreement.timeEnd)}',
                    style: textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
