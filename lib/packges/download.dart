import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

downloadFile(String url, String name) async {
  
  if (await Permission.storage.request().isGranted) {
    //final tempdir = await getApplicationDocumentsDirectory();
    final tempdir = await getTemporaryDirectory();
    final path = '${tempdir.path}/$name';
    bool fileExists = await File(path).exists();
    if(fileExists){
      OpenFile.open(path);

    }else{
    await Dio().download(url, path);
     OpenFile.open(path);
        }
    }
}
