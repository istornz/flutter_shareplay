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

  // Create a SharePlay instance.
  final _shareplayPlugin = Shareplay();

  // Store the current session state.
  SPSessionState _sessionState = SPSessionState.invalidated;

  @override
  void initState() {
    super.initState();
    
    // Check if a session exists, then join it.
    _shareplayPlugin.currentSession().then((currentSession) {
      if (currentSession != null) {
        _shareplayPlugin.join();
      }
    });

    // Register data listener to receive data from other participants.
    _shareplayPlugin.dataStream().listen((data) {
      showMessageDialog(data);
    });
    
    // Register session listener to receive new session updates.
    _shareplayPlugin.newSessionStream().listen((data) {
      print('New session: ${data.id}, ${data.title}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SharePlay Flutter'),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_sessionState.toString()),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Start a new activity with a custom title (visible by all participants).
                _shareplayPlugin.start(title: 'My Activity');
              },
              child: const Text('Start'),
            ),
            ElevatedButton(
              onPressed: () {
                // Join any available activity.
                _shareplayPlugin.join();
              },
              child: const Text('Join'),
            ),
            ElevatedButton(
              onPressed: () {
                // Leave the current activity.
                _shareplayPlugin.leave();
              },
              child: const Text('Leave'),
            ),
            ElevatedButton(
              onPressed: () {
                // End the current activity for all participant.
                _shareplayPlugin.end();
              },
              child: const Text('End'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Get the current session state.
                final state = await _shareplayPlugin.sessionState();
                setState(() {
                  _sessionState = state;
                });
              },
              child: const Text('Session state'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Get the current local participant.
                final participant = await _shareplayPlugin.localParticipant();
                print(participant?.id);
              },
              child: const Text('Local participant'),
            ),
            ElevatedButton(
              onPressed: () {
                // Send a message to all participants
                // (it will automatically include the local participant ID).
                _shareplayPlugin.send('Hello from Flutter');
              },
              child: const Text('Send message'),
            ),
          ],
        ),
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
