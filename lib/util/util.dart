import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class Util {
  static void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
  static Future<void> downloadAndShareGif(String url, ValueNotifier downloadProgressNotifier) async {
    try {
      downloadProgressNotifier.value = 0;
      // Get the directory to save the GIF file
      final directory = await getTemporaryDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final filePath = '${directory.path}/$timestamp.gif';

      // Download the GIF using Dio
      final dio = Dio();
      await dio.download(url, filePath,
          onReceiveProgress: (actualBytes, int totalBytes) {
        downloadProgressNotifier.value =
            (actualBytes / totalBytes * 100).floor();
      });

      // Share the downloaded file
      final result = await Share.shareXFiles([XFile(filePath)]);
      if (result.status == ShareResultStatus.success) {
        // After sharing, delete the file
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
          print('GIF file deleted after sharing');
        }
      } else {
        print('Failed to share GIF');
      }
    } catch (e) {
      print('Error downloading or sharing the GIF: $e');
    }
  }
}
