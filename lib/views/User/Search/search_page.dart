import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/controllers/service_controller.dart';
import 'package:clone_freelancer_mobile/models/chat_user_data.dart';
import 'package:clone_freelancer_mobile/models/package.dart';
import 'package:clone_freelancer_mobile/views/User/Search/result_page.dart';
import 'package:get/get.dart';

class Searchpage extends StatefulWidget {
  const Searchpage({super.key});

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class DetailsData {
  final int serviceId;
  final String title;
  final String desc;
  final UserData user;
  final List<Package> packages;
  final double rating;
  final int count;
  final bool fav;
  final String email;
  final String subCategory;
  final bool customOrder;
  final String type;
  final String location;

  DetailsData({
    required this.serviceId,
    required this.title,
    required this.desc,
    required this.user,
    required this.packages,
    required this.rating,
    required this.count,
    required this.fav,
    required this.email,
    required this.subCategory,
    required this.customOrder,
    required this.type,
    required this.location,
  });
}

class AutoComplete {
  final int serviceId;
  final String title;

  AutoComplete({
    required this.serviceId,
    required this.title,
  });

  factory AutoComplete.fromJson(Map<String, dynamic> json) {
    return AutoComplete(
      serviceId: json['service_id'] ?? 0,
      title: json['suggestion'] ?? '',
    );
  }
}

class _SearchpageState extends State<Searchpage> {
  TextEditingController searchController = TextEditingController();
  final ServiceController serviceController = Get.put(ServiceController());
  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();
  bool check = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                autofocus: true,
                textInputAction: TextInputAction.search,
                controller: searchController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search Services',
                ),
                onSubmitted: (value) {
                  if (value.length < 3) {
                    setState(() {
                      check = true;
                      tooltipkey.currentState?.ensureTooltipVisible();
                    });
                  } else {
                    Get.off(() => ResultPage(keyword: value));
                  }
                },
              ),
            ),
            Tooltip(
              key: tooltipkey,
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
              message: 'Please enter a minimum of 3 characters',
              child: Icon(
                Icons.info_outline,
                color: !check ? Colors.transparent : Colors.red,
              ),
            ),
          ],
        ),
        // TypeAheadField<AutoComplete>(
        //   hideOnError: true,
        //   hideOnLoading: true,
        //   textFieldConfiguration: TextFieldConfiguration(
        //     autofocus: true,
        //     textInputAction: TextInputAction.search,
        //     controller: searchController,
        //     decoration: InputDecoration(
        //       border: InputBorder.none,
        //       hintText: 'Search Services',
        //     ),
        //   ),
        //   itemBuilder: (context, AutoComplete suggestion) {
        //     return ListTile(
        //       title: Text(
        //         suggestion.title,
        //         style: Theme.of(context).textTheme.bodyLarge,
        //       ),
        //     );
        //   },
        //   loadingBuilder: (context) {
        //     return const Center(
        //       child: CircularProgressIndicator(),
        //     );
        //   },
        //   noItemsFoundBuilder: (context) => const Text('No items found!'),
        //   onSuggestionSelected: (suggestion) {
        //     print('Selected: ${suggestion.title}');
        //   },
        //   suggestionsCallback: (String pattern) async {
        //     var temp = await serviceController.getSuggestion(pattern);
        //     return temp;
        //   },
        // ),
      ),
    );
  }
}
