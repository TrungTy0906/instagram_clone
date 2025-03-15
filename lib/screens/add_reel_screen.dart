import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/screens/reel_editer_screen.dart';
import 'package:photo_manager/photo_manager.dart';

class AddReelScreen extends StatefulWidget {
  const AddReelScreen({super.key});

  @override
  State<AddReelScreen> createState() => _AddReelScreenState();
}

class _AddReelScreenState extends State<AddReelScreen> {
  int indexx = 0;
  final List<Widget> _mediaList = [];
  final List<File> path = [];
  File? _file;
  int currentPage = 0;
  int? lastPage;

  _fetchNewMedia() async {
    lastPage = currentPage;
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      List<AssetPathEntity> album =
          await PhotoManager.getAssetPathList(type: RequestType.video);
      List<AssetEntity> media =
          await album[0].getAssetListPaged(page: currentPage, size: 60);

      for (var asset in media) {
        if (asset.type == AssetType.video) {
          final file = await asset.file;
          if (file != null) {
            path.add(File(file.path));
            _file = path[0];
          }
        }
      }
      List<Widget> temp = [];
      for (var asset in media) {
        temp.add(
          FutureBuilder(
            future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (asset.type == AssetType.video)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          alignment: Alignment.center,
                          width: 35.w,
                          height: 15.h,
                          child: Row(
                            children: [
                              Text(
                                asset.videoDuration.inMinutes.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              Text(
                                ':',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              Text(
                                asset.videoDuration.inSeconds.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                );
              }
              return Container();
            },
          ),
        );
      }
      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Reels',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: _mediaList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 250,
            mainAxisSpacing: 3.h,
            crossAxisSpacing: 3.w,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  setState(() {
                    indexx = index;
                    _file = path[index];
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ReelEditerScreen(_file!)));
                  });
                },
                child: _mediaList[index]);
          },
        ),
      ),
    );
  }
}
