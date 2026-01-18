import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/controllers/service_controller.dart';
import 'package:clone_freelancer_mobile/views/User/Search/search_page.dart';
import 'package:clone_freelancer_mobile/views/User/sub_category_page.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart'; // GetX package for state management and navigation

// Widget utama yang akan menampilkan halaman kategori
class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Future
      futureAllCategory; // Deklarasi variabel untuk menyimpan data kategori yang akan diambil secara asynchronous
  final ServiceController serviceController = Get.put(
      ServiceController()); // Inisialisasi controller untuk mengakses layanan

  @override
  void initState() {
    super.initState();
    // Mengambil semua kategori ketika halaman diinisialisasi
    futureAllCategory = serviceController.getAllCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar di bagian atas layar dengan judul dan ikon pencarian
      // appBar: AppBar(
      //   title: const Text(
      //     'Categories', // Judul AppBar
      //   ),
      //   actions: [
      //     IconButton(
      //         onPressed: () {
      //           // Navigasi ke halaman pencarian saat ikon search ditekan
      //           Get.to(() => const Searchpage());
      //         },
      //         icon: const Icon(Icons.search, color: Colors.white,)), // Ikon pencarian di sebelah kanan
      //   ],
      // ),
      appBar: AppBar(
        // backgroundColor: Color.fromARGB(255, 93, 82, 255),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'categories'.tr, // Judul AppBar
          style: TextStyle(
            color: Colors.white, // Ganti dengan warna yang diinginkan
            fontSize: 20, // Ukuran teks bisa disesuaikan
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigasi ke halaman pencarian saat ikon search ditekan
              Get.to(() => const Searchpage());
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ), // Ikon pencarian di sebelah kanan
          ),
        ],
      ),

      // FutureBuilder digunakan untuk menampilkan data secara asynchronous
      body: FutureBuilder(
        future:
            futureAllCategory, // Future yang akan digunakan untuk mendapatkan data kategori
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
                'Error: ${snapshot.error}'); // Menampilkan error jika ada masalah dalam pengambilan data
          } else if (snapshot.hasData) {
            final data = snapshot.data; // Menyimpan data kategori dari snapshot
            return ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider(); // Menyisipkan divider antar item dalam list
              },
              shrinkWrap: true, // Menyesuaikan ukuran list dengan kontennya
              scrollDirection: Axis
                  .vertical, // ListView akan menampilkan item secara vertikal
              itemCount: data
                  .length, // Jumlah item yang akan ditampilkan berdasarkan data kategori
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // Navigasi ke halaman subkategori saat item kategori ditekan
                    Get.to(
                      () => SubCategoryPage(
                        categoryId: data[index]
                            ['category_id'], // Mengirim ID kategori
                        categoryName: data[index]
                            ['category_name'], // Mengirim nama kategori
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      data[index]['category_name'], // Menampilkan nama kategori
                    ),
                    trailing: const Icon(
                        Icons.arrow_forward_ios), // Ikon panah di sebelah kanan
                  ),
                );
              },
            );
          } else {
            // Menampilkan indikator loading saat data sedang diambil
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
