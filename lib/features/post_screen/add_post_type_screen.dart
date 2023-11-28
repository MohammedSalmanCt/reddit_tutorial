import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../core/contants/constants.dart';
import '../../core/theme/pallet.dart';
import '../../core/utils.dart';

class AddPostTypeScreen extends StatefulWidget {
  const AddPostTypeScreen({super.key,required this.type});
  final String type;

  @override
  State<AddPostTypeScreen> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends State<AddPostTypeScreen> {
  final titleController=TextEditingController();

  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;
  void selectBannerImage() async {
    final res = await filePicker();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await filePicker();
    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final currentTheme=ref.watch(themeNotifierProvider);
  final isTypeImage=widget.type =="image";
  final isTypeText=widget.type =="text";
  final isTypeLink=widget.type =="link";
    return Scaffold(
      appBar: AppBar(
        title: Text("Post ${widget.type}"),
        centerTitle: true,
        actions: [
          TextButton(onPressed: () {

          }, child: const Text("Share"))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
controller: titleController,
              decoration: const InputDecoration(
                filled: true,
                hintText: "Enter Title here",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(18),
              ),
            ),
            const SizedBox(height: 10,),
            if(isTypeImage)
              GestureDetector(
                onTap: () => selectBannerImage(),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  dashPattern: const [10, 4],
                  strokeCap: StrokeCap.round,
                  color: Pallete
                      .darkModeAppTheme.textTheme.bodyText2!.color!,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)),
                    child: bannerFile != null
                        ? Image.file(bannerFile!)
                        :const Center(
                      child: Icon(
                          (Icons.camera_alt_outlined),
                          size: 40),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
