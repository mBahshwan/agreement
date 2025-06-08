import 'package:agreement_app/app/home_page/home_view_model.dart';
import 'package:agreement_app/app/models/userModel.dart';
import 'package:agreement_app/app/visitors_page/visitor_details.dart';
import 'package:agreement_app/app/visitors_page/visitors_view_model.dart';
import 'package:agreement_app/core/helpers.dart';
import 'package:agreement_app/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VisitorsPage extends ConsumerStatefulWidget {
  const VisitorsPage({super.key});

  @override
  ConsumerState<VisitorsPage> createState() => _VisitorsPageState();
}

class _VisitorsPageState extends ConsumerState<VisitorsPage> {
  late TextEditingController _search = TextEditingController();
  List<UserModel> _filteredVisitors = [];
  void _filterVisitors(String value, List<UserModel> list) {
    final query = value;

    setState(() {
      _filteredVisitors = list.where((visitor) {
        return visitor.userId!.toString().startsWith(query) ||
            visitor.phoneNumber!.toString().startsWith(query);
      }).toList();
    });
  }

  @override
  void initState() {
    // _search.addListener(_filteredVisitors);
    ref.read(visitorsViewModelProvider.notifier).getVisitors();
    super.initState();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visitors = ref.watch(visitorsViewModelProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'visitors',
          style: textTheme.displaySmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomTextField(
              lableText: 'Search by User ID or Phone no...',
              controller: _search,
              prefixIcon: Icon(Icons.search),
              onChanged: (value) => _filterVisitors(_search.text, visitors),
              textInputType: TextInputType.number,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredVisitors.isEmpty
                    ? visitors.length
                    : _filteredVisitors.length,
                itemBuilder: (context, index) {
                  final visitor = visitors[index];

                  return InkWell(
                    onTap: () {
                      Helpers.navigateToPush(
                        context,
                        VisitorDetails(
                          agreements: _filteredVisitors.isEmpty
                              ? (visitor.agreements ?? [])
                              : (_filteredVisitors[index].agreements ?? []),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.indigo.shade100,
                              Colors.blue.shade100
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _filteredVisitors.isEmpty
                                        ? visitor.name ?? 'Visitor'
                                        : _filteredVisitors[index].name!,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo.shade900,
                                    ),
                                  ),
                                  Chip(
                                    backgroundColor: Colors.indigo.shade50,
                                    label: Text(
                                      _filteredVisitors.isEmpty
                                          ? visitor.visitingCount.toString()
                                          : _filteredVisitors[index]
                                              .visitingCount
                                              .toString(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Text(
                                _filteredVisitors.isEmpty
                                    ? 'phone no. ${visitor.phoneNumber}'
                                    : 'phone no. ${_filteredVisitors[index].phoneNumber}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo.shade900,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
