// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/controllers/seller_controller.dart';
import 'package:clone_freelancer_mobile/views/seller/Portfolio/edit_portfolio_dialog.dart';
import 'package:get/get.dart';

class ShowPortfolioDialog extends StatefulWidget {
  const ShowPortfolioDialog(
      {super.key, this.onClose, required this.portfolioId, required this.user});
  final Function(dynamic)? onClose;
  final int portfolioId;
  final String user;

  @override
  State<ShowPortfolioDialog> createState() => _ShowPortfolioDialogState();
}

class _ShowPortfolioDialogState extends State<ShowPortfolioDialog> {
  late Future futurePortfolio;
  final SellerController sellerController = Get.put(SellerController());

  void fetchData() async {
    print('Fetching data');
    setState(() {
      futurePortfolio = sellerController.fetchPortfolioById(
          portfolioId: widget.portfolioId.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void editPortfolio(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => EditPortfolioDialog(
        futurePortfolio: futurePortfolio,
        onClose: (result) {
          Navigator.pop(context, result);
        },
      ),
    );

    if (result != null) {
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context, true),
          ),
          actions: [
            widget.user == 'freelancer'
                ? PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem<int>(
                          value: 0,
                          child: Text("Edit Portfolio"),
                        ),
                        const PopupMenuItem<int>(
                          value: 1,
                          child: Text("Delete Portfolio"),
                        ),
                      ];
                    },
                    onSelected: (value) async {
                      if (value == 0) {
                        editPortfolio(context);
                      } else {
                        await sellerController
                            .deletePortfolio(
                                portfolioId: widget.portfolioId.toString())
                            .then((value) => Navigator.pop(context, true));
                      }
                    },
                  )
                : Container()
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
            future: futurePortfolio,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final data = snapshot.data;
                final dataInfo = data['portfolio'];
                final dataPic = data['portfolio_img'];
                final dataFreelancer = data['freelanceer'];
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${dataInfo['title']}'.capitalize!,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                dataFreelancer['piclink'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(dataFreelancer['name'])
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text('${dataInfo['description']}'.capitalize!),
                      ListView.separated(
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 16,
                          );
                        },
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data['portfolio_img'].length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            dataPic[index]['piclink'],
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
