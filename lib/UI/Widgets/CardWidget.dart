import 'package:flutter/material.dart';
import 'templateerrorcontainer.dart';

/// A custom widget that displays a list of requests or handles errors.
/// It effectively manages loading states, errors, and empty list scenarios.
class CardWidget extends StatelessWidget {
  final bool loading;
  final bool fetch;
  final String errorText;
  final Future<void>
      fetchData;
  final List<Widget>
      listWidget;

  const CardWidget({
    Key? key,
    required this.loading,
    required this.fetch,
    required this.errorText,
    required this.listWidget,
    required this.fetchData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<void>(
      future: loading ? null : fetchData,
      builder: (context, snapshot) {
        if (!fetch) {
          return Container(
            height: 200,
            width: screenWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child:
                  CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return buildNoRequestsWidget(screenWidth, 'Error: $errorText');
        } else if (fetch) {
          if (listWidget.isEmpty) {
            return buildNoRequestsWidget(screenWidth, errorText);
          } else if (listWidget.isNotEmpty) {
            return Container(
              child: Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: listWidget.length,
                    itemBuilder: (context, index) {
                      print(listWidget[index]);
                      print('Separated');
                      return listWidget[index];
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
        }
        return SizedBox();
      },
    );
  }
}
