import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/game_event_response/game_availablity_response.dart';
import 'package:spaid/model/response/game_event_response/player_availability_response.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/ui/availability_screen/availability_listview_provider.dart';
import 'package:spaid/ui/availability_screen/available_player_screen_ui.dart';
import 'package:spaid/ui/home_screen/home_menu_screen/media_list_ui.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_availability_tabbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_media_tabbar.dart';

class MediaPlayerTabScreen extends StatefulWidget {
  int tabId;
  MediaPlayerTabScreen(this.tabId);



  @override
  _MediaPlayerTabScreenState createState() =>
      _MediaPlayerTabScreenState();
}

class _MediaPlayerTabScreenState extends BaseState<MediaPlayerTabScreen>
    with SingleTickerProviderStateMixin
     {
  //region Private Members
  TabController? _tabController;
  int _selectedTab = 0;

  String _userRole = "";
  List<Map<String, dynamic>> imagefiles = [];
  List<Map<String, dynamic>> videofiles = [];
  List<Map<String, dynamic>> documentfile = [];
  bool imageLoad=false;
  bool videoLoad=false;
  bool fileLoad=false;

//endregion
  @override
  void initState() {
    if( widget.tabId != null) {
      imageLoad = true;
      videoLoad = true;
      fileLoad = true;
      loadImages();
      loadVideos();
      loadFiles();
    }else{
      imagefiles =Constants.imagefiles;
          videofiles =Constants.videofiles;
          documentfile=Constants.documentfile;
          setState(() {

          });
    }
    _tabController = TabController(initialIndex:  widget.tabId != null? widget.tabId:0, length: 3, vsync: this);
    _getDataAsync();

    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) {
        setState(() {
          _selectedTab = _tabController!.index;
        });
      }
    });

    super.initState();
  }


       Future<List<Map<String, dynamic>>> loadImages() async {
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
             "reference": file,
             "extension": fileMeta.customMetadata['extension'] ?? '',
             "title": fileMeta.customMetadata['title'] ?? '',
             "description":
             fileMeta.customMetadata['description'] ?? ''
           });
           setState(() {
             imagefiles=files;
             imageLoad=false;
           });
         });
         Constants.imagefiles=files;

          setState(() {
           imageLoad=false;
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
             "reference": file,
             "extension": fileMeta.customMetadata['extension'] ?? '',
             "title": fileMeta.customMetadata['title'] ?? '',
             "description":
             fileMeta.customMetadata['description'] ?? ''
           });
           setState(() {
             videofiles=files;
             videoLoad=false;
           });
         });
         Constants.videofiles=files;

         setState(() {
           videoLoad=false;
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
             "reference": file,
             "extension": fileMeta.customMetadata['extension'] ?? '',
             "title": fileMeta.customMetadata['title'] ?? '',
             "description":
             fileMeta.customMetadata['description'] ?? ''
           });
           setState(() {
             documentfile=files;
             fileLoad=false;
           });
         });
         Constants.documentfile=files;

          setState(() {
           fileLoad=false;
         });
         return files;
       }

       @override
       void onSuccess(any, {int? reqId}) {
         ProgressBar.instance.stopProgressBar(context);
         switch (reqId) {
           case ResponseIds.GET_PLAYER_AVAILABILITY:


             break;

         }
       }
       _getDataAsync() async {
         try {
           _userRole =
           await SharedPrefManager.instance.getStringAsync(Constants.roleId);
         } catch (e) {
           print(e);
         }
       }
       @override
       void onFailure(BaseResponse error) {
         ProgressBar.instance.stopProgressBar(context);
         CodeSnippet.instance.showMsg(error.errorMessage!);
       }

  @override
  Widget build(BuildContext context) {
    return TopBar(
      child: WebCard(
        marginVertical: 20,
        marginhorizontal: 40,
        child: Scaffold(
          backgroundColor: MyColors.white,
          appBar: AppBar(
            leading: IconButton(
              iconSize: ImageSize.standardIconSize,
              icon: Icon(
                Icons.arrow_back,
                color: MyColors.white,
              ),
              tooltip: 'Back',
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: true,
            title: Text(MyStrings.uploads),
            bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height * .1),
              child: Column(
                children: <Widget>[
                  Material(
                    color: MyColors.kPrimaryColor,
                    child: Padding(
                      padding: EdgeInsets.all(PaddingSize.headerPadding2),
                      child: CustomMediaTabBar(
                        tabController: _tabController,
                        selectedTab: _selectedTab,
                        firstTabName: "Images",
                        secondTabName: "Videos",
                        thirdTabName: "Documents",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: DefaultTabController(
            length: 3,
            child: Column(
              children: <Widget>[
                Expanded(
                  child:TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      MediaListScreen(Constants.images,imagefiles,imageLoad),
                      MediaListScreen(Constants.videos,videofiles,videoLoad),
                      MediaListScreen(Constants.files,documentfile,fileLoad),
                      // SabhaListEvent(_tabController)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
