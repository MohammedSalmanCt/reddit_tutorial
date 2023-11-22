import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/contants/constants.dart';
import 'package:reddit_tutorial/features/community/controller/comminity_controller.dart';
import 'package:reddit_tutorial/models/community_model.dart';

import '../../../core/theme/pallet.dart';
import '../../../core/utils.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  const EditCommunityScreen({super.key, required this.name});
  final String name;

  @override
  ConsumerState createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {

  File? bannerFile;
  File? profileFile;
  void selectBannerImage()
  async{
    final res=await filePicker();
    if(res!=null)
      {
setState(() {
  bannerFile=File(res.files.first.path!);
  
});
      }
  }

  void selectProfileImage()
  async{
    final res=await filePicker();
    if(res!=null)
    {
      setState(() {
        profileFile=File(res.files.first.path!);

      });
    }
  }

  void save( Community community)
  {
    ref.read(communityControllerProvider.notifier).editCommunity(context: context, community: community, profileFile: profileFile, bannerFile: bannerFile);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading=ref.watch(communityControllerProvider);
    String cummunityName = Uri.decodeComponent(widget.name);
    return ref.watch(getCommunityByNameProvider(cummunityName)).when(
      data: (data) {
        return Scaffold(
          backgroundColor: Pallete.darkModeAppTheme.backgroundColor,
          appBar: AppBar(
            title: const Text("Edit Community"),
            centerTitle: false,
            actions: [TextButton(onPressed: () {
              save(data);
            }, child: const Text("Save"))],
          ),
          body: isLoading?Loader()
         : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                      children: [
                    GestureDetector(
                      onTap: () => selectBannerImage(),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        color: Pallete.darkModeAppTheme.textTheme.bodyText2!.color!,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: bannerFile!=null ?Image.file(bannerFile!) :data.banner.isEmpty ||
                                  data.banner == Constants.bannerDefault
                              ? const Center(
                                  child:
                                      Icon((Icons.camera_alt_outlined), size: 40),
                                )
                              : Image.network(data.banner),
                        ),
                      ),
                    ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: GestureDetector(
                            onTap: () => selectProfileImage(),
                            child: profileFile!=null
                                ?CircleAvatar(
                              backgroundImage: FileImage(profileFile!),
                              radius: 32,
                            )
                                :CircleAvatar(
                              backgroundImage: NetworkImage(data.avatar),
                              radius: 32,
                            ),
                          ),
                        )
                  ]),
                )
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return Loader();
      },
    );
  }
}
