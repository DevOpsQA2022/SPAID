// class JsonResponce {
//   String? iD;
//   String? fromImage;
//   String? image;
//   String? isImageSelected;
//   String? isImage;
//   String? text;
//   String? painter;
//   String? mode;
//   List<List>? offset;
//
//   JsonResponce({this.iD, this.fromImage, this.image, this.isImageSelected, this.isImage, this.text, this.painter, this.mode, this.offset});
//
//   JsonResponce.fromJson(Map<String, dynamic> json) {
//     iD = json['ID'];
//     fromImage = json['FromImage'];
//     image = json['Image'];
//     isImageSelected = json['IsImageSelected'];
//     isImage = json['IsImage'];
//     text = json['Text'];
//     painter = json['Painter'];
//     mode = json['Mode'];
//     if (json['Offset'] != null) {
//       offset = <List>[];
//       json['Offset'].forEach((v) { offset!.add(new List.fromJson(v)); });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['ID'] = this.iD;
//     data['FromImage'] = this.fromImage;
//     data['Image'] = this.image;
//     data['IsImageSelected'] = this.isImageSelected;
//     data['IsImage'] = this.isImage;
//     data['Text'] = this.text;
//     data['Painter'] = this.painter;
//     data['Mode'] = this.mode;
//     if (this.offset != null) {
//       data['Offset'] = this.offset!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Offset {
//
//
//   Offset({});
//
// Offset.fromJson(Map<String, dynamic> json) {
// }
//
// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   return data;
// }
// }
