import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/controllers/service_controller.dart';
import 'package:clone_freelancer_mobile/views/User/display_search_page.dart';
import 'package:get/get.dart';

class SubCategoryPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  const SubCategoryPage(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  late Future futureAllSubCategory;
  final ServiceController serviceController = Get.put(ServiceController());

  @override
  void initState() {
    super.initState();
    futureAllSubCategory =
        serviceController.getAllSubCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
        ),
      ),
      body: FutureBuilder(
        future: futureAllSubCategory,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final data = snapshot.data;
            return ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider();
              },
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Get.to(
                      () => DisplaySearchPage(
                        subCategoryId: data[index]['subcategory_id'],
                        subCategoryText: data[index]['subcategory_name'],
                        searchText: null,
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      data[index]['subcategory_name'],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
