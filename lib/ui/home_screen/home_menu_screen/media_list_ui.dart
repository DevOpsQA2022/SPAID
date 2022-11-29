import 'dart:io';

import 'package:empty_widget/empty_widget.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletons/skeletons.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/widgets/uploads_list_card.dart';
import 'package:universal_html/html.dart' as html;

class MediaListScreen extends StatefulWidget {
  int type;
  List<Map<String, dynamic>> imagefiles;
  bool imageLoad;

  MediaListScreen(this.type, this.imagefiles, this.imageLoad);

  @override
  _MediaListScreenState createState() => _MediaListScreenState();
}

class _MediaListScreenState extends State<MediaListScreen> {
  @override
  void initState() {
    /*if(widget.type==Constants.images){
      setState(() {
        loadImages();
      });
    }
    if(widget.type==Constants.videos){
      setState(() {
        loadVideos();
      });
    }
    if(widget.type==Constants.files){
      setState(() {
        loadFiles();
      });
    }*/
    super.initState();
  }

  /*Future<List<Map<String, dynamic>>> loadImages() async {
    List<Map<String, dynamic>> files = [];
    FirebaseStorage storage = FirebaseStorage.instance;

    final ListResult result = await storage.ref().child('image/').listAll();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();

      print(fileUrl);
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "extension": fileMeta.customMetadata['extension'] ?? '',
        "title": fileMeta.customMetadata['title'] ?? '',
        "description":
        fileMeta.customMetadata['description'] ?? ''
      });
    });
setState(() {
  imagefiles=files;
});
    return files;
  }
  Future<List<Map<String, dynamic>>> loadVideos() async {
    List<Map<String, dynamic>> files = [];
    FirebaseStorage storage = FirebaseStorage.instance;

    final ListResult result = await storage.ref().child('video/').listAll();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();

      print(fileUrl);
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "extension": fileMeta.customMetadata['extension'] ?? '',
        "title": fileMeta.customMetadata['title'] ?? '',
        "description":
        fileMeta.customMetadata['description'] ?? ''
      });
    });
    setState(() {
      imagefiles=files;
    });
    return files;
  }

  Future<List<Map<String, dynamic>>> loadFiles() async {
    List<Map<String, dynamic>> files = [];
    FirebaseStorage storage = FirebaseStorage.instance;

    final ListResult result = await storage.ref().child('file/').listAll();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();

      print(fileUrl);
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "extension": fileMeta.customMetadata['extension'] ?? '',
        "title": fileMeta.customMetadata['title'] ?? '',
        "description":
        fileMeta.customMetadata['description'] ?? ''
      });
    });
    setState(() {
      imagefiles=files;
    });
    return files;
  }

  */
  Future<void> delete(String ref) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    await storage.ref(ref).delete();
    // Rebuild the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: MyColors.white,
      /* appBar:  CustomAppBar(
              title: MyStrings.videoList,
              iconLeft: MyIcons.backwardArrow,tooltipMessageLeft: MyStrings.back,
              onClickLeftImage: () {
                Navigator.of(context).pop();
              },
            ),*/
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(getValueForScreenType<bool>(
            context: context,
            mobile: false,
            tablet: true,
            desktop: true,
          )
              ? PaddingSize.headerPadding1
              : PaddingSize.headerPadding2),
          child: Container(
            width: size.width,
            constraints: BoxConstraints(minHeight: size.height - 30),
            child: widget.imageLoad
                ? SkeletonListView()
                : widget.imagefiles == null || widget.imagefiles.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        child: EmptyWidget(
                          image: null,
                          packageImage: PackageImage.Image_3,
                          title: 'No Data',
                          subTitle: null,
                          titleTextStyle: TextStyle(
                            fontSize: 22,
                            color: Color(0xff9da9c7),
                            fontWeight: FontWeight.w500,
                          ),
                          subtitleTextStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xffabb8d6),
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child: GridView.builder(
                                padding: EdgeInsets.only(bottom: 56),
                            shrinkWrap: true,
                            //physics: ScrollPhysics(),
                            itemCount: widget.imagefiles.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 4.0),
                            itemBuilder: (BuildContext context, int index) {
                              return UploadsListCard(
                                onDelete: (url) {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) =>
                                          FancyDialog(
                                            gifPath: MyImages.team,
                                            okFun: () async => {
                                              Navigator.of(context).pop(),
                                              delete(widget.imagefiles[index]
                                                  ["path"]),
                                              setState(() {
                                                widget.imagefiles
                                                    .removeAt(index);
                                              }),
                                            },
                                            cancelFun: () =>
                                                {Navigator.of(context).pop()},
                                            cancelColor: MyColors.red,
                                            title: MyStrings.conformDelete,
                                          ));
                                },
                                onPressed: () {
                                  if (widget.type == Constants.images) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                            child: PhotoView(
                                          initialScale:
                                              PhotoViewComputedScale.contained *
                                                  0.8,
                                          imageProvider: NetworkImage(
                                              widget.imagefiles[index]["url"]),
                                        ));
                                      },
                                    );
                                  }
                                  if (widget.type == Constants.videos) {
                                    kIsWeb
                                        ? html.window.open(
                                            widget.imagefiles[index]["url"],
                                            "_blank")
                                        : Navigation.navigateWithArgument(
                                            context,
                                            MyRoutes.videoPlayerScreen,
                                            widget.imagefiles[index]["url"]);
                                  }
                                  if (widget.type == Constants.files) {
                                    if (kIsWeb) {
                                      html.window.open(
                                          widget.imagefiles[index]["url"],
                                          "_blank");
                                      /*  html.AnchorElement anchorElement =  new html.AnchorElement(href: widget.imagefiles[index]["url"]);
                                anchorElement.download = widget.imagefiles[index]["url"];
                                anchorElement.click();*/
                                    } else {
                                      downloadFile(widget.imagefiles[index]
                                          ["reference"]);
                                    }
                                  }
                                },
                                desc: widget.imagefiles[index]["description"],
                                title: widget.imagefiles[index]["title"],
                                fileURL: widget.imagefiles[index]["url"],
                                type: widget.type,
                                extension: widget.imagefiles[index]
                                    ["extension"],
                              );
                            },
                          )),
                        ],
                      ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: widget.type == Constants.images
            ? MyStrings.tooltipAddImage
            : widget.type == Constants.videos
                ? MyStrings.tooltipAddVideo
                : widget.type == Constants.files
                    ? MyStrings.tooltipAddFile
                    : "",
        onPressed: () => {
          Navigation.navigateWithArgument(
              context, MyRoutes.addMediaScreen, widget.type)
        },
        foregroundColor: MyColors.white,
        backgroundColor: MyColors.kPrimaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> downloadFile(imagefil) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final File tempFile = File(appDocPath + '/' + imagefil.name);
    try {
      await imagefil.writeToFile(tempFile);
      await tempFile.create();
      await OpenFile.open(tempFile.path);
    } on FirebaseException {
      /* ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error, file tidak bisa diunduh',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      );*/
    }
  }
}
