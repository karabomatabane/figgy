import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../models/gif.model.dart';
import '../util/util.dart';

class GifCard extends StatefulWidget {
  final Gif gif;

  const GifCard({super.key, required this.gif});

  @override
  State<GifCard> createState() => _GifCardState();
}

class _GifCardState extends State<GifCard> {
  ValueNotifier downloadProgressNotifier = ValueNotifier(0);
  bool _isDownloading = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Stack(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: widget.gif.url,
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: Container(
                color: Colors.grey[300],
                height: widget.gif.height,
                width: widget.gif.width,
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Positioned(
            bottom: 8.0,
            right: 8.0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      _isDownloading = true;
                    });
                    await Util.downloadAndShareGif(
                        widget.gif.url, downloadProgressNotifier);
                    setState(() {
                      _isDownloading = false;
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          // Semi-transparent background
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: const Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4.0),
                GestureDetector(
                  onTap: () {
                    //copy to clipboard
                    Util.copyToClipboard(widget.gif.url);
                    Fluttertoast.showToast(
                        msg: 'Copied to clipboard',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                        textColor: Colors.black,
                        fontSize: 16.0
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          // Semi-transparent background
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: const Icon(
                          Icons.copy,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          if (_isDownloading)
            //linear progress indicator at the top of the gif card
            Positioned(
              top: 8.0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ValueListenableBuilder(
                  valueListenable: downloadProgressNotifier,
                  builder: (BuildContext context, value, Widget? child) {
                    return LinearPercentIndicator(
                      barRadius: const Radius.circular(10),
                      center: Text(
                        '${downloadProgressNotifier.value}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                      lineHeight: 15.0,
                      percent: downloadProgressNotifier.value / 100,
                      backgroundColor: Colors.grey[300],
                      progressColor: Colors.blue,
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
