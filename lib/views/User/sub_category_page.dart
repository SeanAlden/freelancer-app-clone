import 'package:flutter/material.dart'; // Mengimpor paket Flutter untuk pembuatan UI
import 'package:clone_freelancer_mobile/controllers/service_controller.dart'; // Mengimpor kontroler untuk mendapatkan data subkategori
import 'package:clone_freelancer_mobile/views/User/display_search_page.dart'; // Mengimpor halaman pencarian untuk menampilkan layanan berdasarkan subkategori
import 'package:get/get.dart'; // Mengimpor GetX untuk manajemen state dan navigasi

// Halaman SubCategoryPage menerima categoryId dan categoryName sebagai parameter
class SubCategoryPage extends StatefulWidget {
  final int categoryId; // ID dari kategori yang dipilih
  final String categoryName; // Nama dari kategori yang dipilih

  const SubCategoryPage(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

// State dari SubCategoryPage untuk menyimpan state dinamis
class _SubCategoryPageState extends State<SubCategoryPage> {
  late Future
      futureAllSubCategory; // Future untuk mendapatkan data subkategori dari API
  final ServiceController serviceController =
      Get.put(ServiceController()); // Instansiasi ServiceController dengan GetX

  @override
  void initState() {
    super.initState();
    // Memanggil fungsi getAllSubCategory pada ServiceController dengan categoryId
    futureAllSubCategory =
        serviceController.getAllSubCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName, // Menampilkan nama kategori di AppBar
          style: TextStyle(
              color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder(
        future:
            futureAllSubCategory, // Future yang digunakan untuk mendapatkan data subkategori
        builder: (context, snapshot) {
          // Jika ada error saat mengambil data
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Menampilkan pesan error
          }
          // Jika data berhasil diambil
          else if (snapshot.hasData) {
            final data = snapshot.data; // Menyimpan data yang diterima dari API
            return ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider(); // Menambahkan garis pemisah di antara item
              },
              shrinkWrap: true,
              scrollDirection: Axis.vertical, // Membuat ListView vertikal
              itemCount: data
                  .length, // Jumlah item sesuai dengan panjang data yang diterima
              itemBuilder: (context, index) {
                return InkWell(
                  // Ketika item diklik
                  onTap: () {
                    // Navigasi ke halaman DisplaySearchPage dengan GetX dan mengirimkan data subkategori
                    Get.to(
                      () => DisplaySearchPage(
                        subCategoryId: data[index]
                            ['subcategory_id'], // Mengirimkan ID subkategori
                        subCategoryText: data[index][
                            'subcategory_name'], // Mengirimkan nama subkategori
                        searchText:
                            null, // Nilai searchText diinisialisasi sebagai null
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      data[index]
                          ['subcategory_name'], // Menampilkan nama subkategori
                    ),
                    trailing: const Icon(Icons
                        .arrow_forward_ios), // Menambahkan ikon panah di sebelah kanan item
                  ),
                );
              },
            );
          }
          // Jika data masih dalam proses diambil
          else {
            return const Center(
              child:
                  CircularProgressIndicator(), // Menampilkan loading indicator saat data belum ada
            );
          }
        },
      ),
    );
  }
}
