import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/controllers/user_controller.dart';
import 'package:get/get.dart';

class RequestSupportPage extends StatefulWidget {
  const RequestSupportPage({super.key, this.orderId});
  final String? orderId;

  @override
  State<RequestSupportPage> createState() => _RequestSupportPageState();
}

class _RequestSupportPageState extends State<RequestSupportPage> {
  TextEditingController subjectController = TextEditingController();
  TextEditingController issueController = TextEditingController();
  final UserController userController = Get.put(UserController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Support Request', // Judul AppBar
          style: TextStyle(
            color: Colors.white, // Ganti dengan warna yang diinginkan
            fontSize: 20, // Ukuran teks bisa disesuaikan
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/report.jpg',
                    width: width / 1.3,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Subject',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: subjectController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter support subject.';
                      }
                      return null;
                    },
                  ),
                  Text(
                    'What is your issue ?',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: issueController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your issue.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              userController.sendIssue(
                                subject: subjectController.text.trim(),
                                issue: issueController.text.trim(),
                                orderId: widget.orderId,
                              );
                            }
                          },
                          style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue), // Warna latar belakang
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // Warna teks atau ikon
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                          child: Obx(() {
                            return userController.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "Send Request",
                                  );
                          }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
