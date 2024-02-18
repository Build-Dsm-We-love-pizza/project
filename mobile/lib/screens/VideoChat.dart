import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../helpers/signaling.dart';

class VideoChatScreen extends StatefulWidget {
  const VideoChatScreen({super.key});

  @override
  State<VideoChatScreen> createState() => _VideoChatScreenState();
}

class _VideoChatScreenState extends State<VideoChatScreen> {
  Signaling signaling = Signaling();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to Flutter Explained - WebRTC"),
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              signaling.openUserMedia(_localRenderer, _remoteRenderer);
              setState(() {});
            },
            child: Text("Open camera & microphone"),
          ),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
            onPressed: () async {
              roomId = await signaling.createRoom(_remoteRenderer);
              textEditingController.text = roomId!;
              setState(() {});
            },
            child: Text("Create room"),
          ),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
            onPressed: () {
              // Add roomId
              signaling.joinRoom(
                textEditingController.text.trim(),
                _remoteRenderer,
              );
            },
            child: Text("Join room"),
          ),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
            onPressed: () {
              signaling.hangUp(_localRenderer);
            },
            child: Text("Hangup"),
          ),
          SizedBox(height: 8),
          Container(
              width: 250,
              height: 250,
              child: RTCVideoView(_localRenderer, mirror: true)),
          Container(
              width: 250, height: 250, child: RTCVideoView(_remoteRenderer)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Join the following Room: "),
                Flexible(
                  child: TextFormField(
                    controller: textEditingController,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 8)
        ],
      ),
    );
  }
}
