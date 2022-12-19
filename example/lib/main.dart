import 'package:flutter/material.dart';
import 'package:shareplay/models/data_model.dart';
import 'package:shareplay/models/session_state_enum.dart';
import 'dart:async';

import 'package:shareplay/shareplay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _shareplayPlugin = Shareplay();
  SPSessionState? _sessionState;

  @override
  void initState() {
    super.initState();

    _shareplayPlugin.join();
    _shareplayPlugin.dataStream().listen((data) {
      showMessageDialog(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        children: [
          _sessionState != null
              ? Text(_sessionState.toString())
              : const SizedBox.shrink(),
          ElevatedButton(
            onPressed: () {
              _shareplayPlugin.start(title: 'My Activity');
            },
            child: const Text('Start'),
          ),
          ElevatedButton(
            onPressed: () {
              _shareplayPlugin.join();
            },
            child: const Text('Join'),
          ),
          ElevatedButton(
            onPressed: () {
              _shareplayPlugin.leave();
            },
            child: const Text('Leave'),
          ),
          ElevatedButton(
            onPressed: () async {
              final state = await _shareplayPlugin.sessionState();
              setState(() {
                _sessionState = state;
              });
            },
            child: const Text('Session state'),
          ),
          ElevatedButton(
            onPressed: () {
              _shareplayPlugin.end();
            },
            child: const Text('End'),
          ),
          ElevatedButton(
            onPressed: () async {
              final participant = await _shareplayPlugin.localParticipant();
              print(participant.id);
            },
            child: const Text('Local participant'),
          ),
          ElevatedButton(
            onPressed: () {
              _shareplayPlugin.send('Hello from Flutter');
            },
            child: const Text('Send message'),
          ),
        ],
      ),
    );
  }

  Future showMessageDialog(SPDataModel data) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New message received!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Participant: ${data.participant.id}"),
              Text("Message: ${data.message}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
