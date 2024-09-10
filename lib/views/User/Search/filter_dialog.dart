import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key, this.onClose});
  final Function(dynamic)? onClose;

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class FilterResult {
  final int? type;
  final String? lowRange;
  final String? highRange;
  final int? rating;
  final LatLng? position;

  FilterResult(
      {required this.type,
      required this.lowRange,
      required this.highRange,
      required this.rating,
      required this.position});

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'lowRange': lowRange,
      'highRange': highRange,
      'rating': rating,
      'position': position
    };
  }
}

class _FilterDialogState extends State<FilterDialog> {
  bool custom = true;
  final controller1 = GroupButtonController();
  final controller2 = GroupButtonController();
  TextEditingController lowController = TextEditingController();
  TextEditingController highController = TextEditingController();

  @override
  void dispose() {
    lowController.dispose();
    highController.dispose();
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Center(
            child: Text('Filter'),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Service Type'),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Clear",
                            style: Theme.of(context).textTheme.bodySmall,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                controller1.unselectAll();
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.center,
                  child: GroupButton(
                    controller: controller1,
                    options: const GroupButtonOptions(
                      elevation: 1,
                    ),
                    isRadio: true,
                    buttons: const [
                      'Digital Service',
                      "On-Site Service",
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text('Price Range'),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: lowController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "1000",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextField(
                        controller: highController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "50000",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Rating'),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Clear",
                            style: Theme.of(context).textTheme.bodySmall,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                controller2.unselectAll();
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.center,
                  child: GroupButton(
                    controller: controller2,
                    options: const GroupButtonOptions(
                      elevation: 1,
                    ),
                    isRadio: true,
                    buttons: const [
                      '5',
                      "4 above",
                      "3 above",
                      "2 above",
                      "1 above",
                      "No Review",
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Color(0xff6571ff),
                    ),
                  ),
                  onPressed: () async {
                    if (controller1.selectedIndex == 1) {
                      if (await Permission.location.isPermanentlyDenied) {
                        openAppSettings();
                      } else {
                        await Permission.location.request();
                        var position = await GeolocatorPlatform.instance
                            .getCurrentPosition(
                          locationSettings: const LocationSettings(
                            accuracy: LocationAccuracy.high,
                          ),
                        );
                        Navigator.pop(
                          context,
                          FilterResult(
                            type: controller1.selectedIndex,
                            lowRange: lowController.text.trim().isNotEmpty
                                ? lowController.text.trim()
                                : null,
                            highRange: highController.text.trim().isNotEmpty
                                ? highController.text.trim()
                                : null,
                            rating: controller2.selectedIndex != null
                                ? (5 - controller2.selectedIndex!)
                                : null,
                            position:
                                LatLng(position.latitude, position.longitude),
                          ),
                        );
                      }
                    } else {
                      Navigator.pop(
                        context,
                        FilterResult(
                          type: controller1.selectedIndex,
                          lowRange: lowController.text.trim().isNotEmpty
                              ? lowController.text.trim()
                              : null,
                          highRange: highController.text.trim().isNotEmpty
                              ? highController.text.trim()
                              : null,
                          rating: controller2.selectedIndex != null
                              ? (5 - controller2.selectedIndex!)
                              : null,
                          position: null,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Filter',
                    style: TextStyle(color: Colors.white),
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
