import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/controllers/service_controller.dart';
import 'package:clone_freelancer_mobile/views/User/Search/search_page.dart';
import 'package:clone_freelancer_mobile/views/User/sub_category_page.dart';
import 'package:get/get.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Future futureAllCategory;
  final ServiceController serviceController = Get.put(ServiceController());

  @override
  void initState() {
    super.initState();
    futureAllCategory = serviceController.getAllCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const Searchpage());
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: FutureBuilder(
        future: futureAllCategory,
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
                      () => SubCategoryPage(
                        categoryId: data[index]['category_id'],
                        categoryName: data[index]['category_name'],
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      data[index]['category_name'],
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
