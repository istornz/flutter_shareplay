import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shareplay/models/data_model.dart';
import 'package:shareplay/models/participant_model.dart';
import 'package:shareplay/models/session_model.dart';
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
  final num kParticipantCount = 2;
  final num kWinningPercentage = 0.15;
  final double kBubbleSize = 50.0;
  final double kBubbleMove = 20.0;

  // Subscriptions to SharePlay events.
  StreamSubscription<SPDataModel>? _dataSubscription;
  StreamSubscription<SPSession>? _newSessionSubscription;
  StreamSubscription<List<SPParticipant>>? _participantsSubscription;
  StreamSubscription<SPSessionState>? _sessionStateSubscription;

  // Create a SharePlay instance.
  final _shareplayPlugin = Shareplay();

  // Game state
  SPSession? _session;
  SPSessionState _sessionState = SPSessionState.invalidated;
  int _participantCount = 0;
  bool get _gameStarted =>
      _session != null &&
      _sessionState == SPSessionState.joined &&
      _participantCount == kParticipantCount;
  num _bubbleTop = 0;
  bool _isHost = false;

  @override
  void initState() {
    super.initState();

    // Check if a session exists, then join it.
    _shareplayPlugin.currentSession().then((currentSession) {
      if (currentSession != null) {
        _shareplayPlugin.join();
      }
    });

    // Register session state listener to receive session state updates.
    _sessionStateSubscription =
        _shareplayPlugin.sessionStateStream().listen((sessionState) {
      setState(() {
        _sessionState = sessionState;
      });
    });

    // Register data listener to receive data from other participants.
    _dataSubscription = _shareplayPlugin.dataStream().listen((data) {
      setState(() {
        _bubbleTop = double.parse(data.message);
      });

      _checkIfGameFinished();
    });

    // Register session listener to receive new session updates.
    _newSessionSubscription =
        _shareplayPlugin.newSessionStream().listen((data) {
      setState(() {
        _session = data;
      });

      _checkIfGameStarted();
    });

    // Register participants listener to receive participants updates.
    _participantsSubscription =
        _shareplayPlugin.participantsStream().listen((data) {
      setState(() {
        _participantCount = data.length;
      });

      _checkIfGameStarted();
    });
  }

  _checkIfGameStarted() {
    if (_gameStarted) {
      setState(() {
        _bubbleTop = MediaQuery.of(context).size.height / 2;
      });
    }
  }

  @override
  void dispose() {
    _shareplayPlugin.leave();

    _participantsSubscription?.cancel();
    _dataSubscription?.cancel();
    _newSessionSubscription?.cancel();
    _sessionStateSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Column(
          children: [
            Expanded(
              child: !_gameStarted
                  ? SizedBox.expand(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/logo.png', width: 250),
                          const SizedBox(height: 30),
                          TextButton(
                            child: const Text('🚀 Start a new session'),
                            onPressed: () async {
                              await _shareplayPlugin.start(
                                  title: 'Tap the bubble 🚀');
                              _shareplayPlugin.join();

                              setState(() {
                                _isHost = true;
                              });
                            },
                          ),
                          TextButton(
                            child: const Text('📡 Join an existing session'),
                            onPressed: () {
                              _shareplayPlugin.join();

                              setState(() {
                                _isHost = false;
                              });
                            },
                          ),
                          TextButton(
                            child: const Text('🚨 End activity'),
                            onPressed: () async {
                              _endGameActivity();
                            },
                          ),
                          // const SizedBox(height: 20),
                          // Text('Session state: $_sessionState'),
                          // Text('Session data: $_session'),
                          // Text('Participants: $_participantCount'),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();

                        setState(() {
                          _isHost
                              ? _bubbleTop += kBubbleMove
                              : _bubbleTop -= kBubbleMove;

                          _shareplayPlugin.send(_bubbleTop.toString());
                          _checkIfGameFinished();
                        });
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    kWinningPercentage,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(color: Colors.white),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    kWinningPercentage,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.greenAccent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOutQuad,
                            left: 0,
                            right: 0,
                            top: (MediaQuery.of(context).size.height -
                                    (kBubbleSize / 2)) -
                                _bubbleTop,
                            child: Container(
                              height: kBubbleSize,
                              width: kBubbleSize,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // SafeArea(
                          //   child: Column(
                          //     children: [
                          //       Text('Session state: $_sessionState'),
                          //       Text('Session data: $_session'),
                          //       Text('Participants: $_participantCount'),
                          //       Text('Bubble top: $_bubbleTop'),
                          //       TextButton(
                          //         onPressed: () {
                          //           _endGameActivity();
                          //         },
                          //         child: const Text('End'),
                          //       ),
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _checkIfGameFinished() async {
    bool greenWin =
        (_bubbleTop <= MediaQuery.of(context).size.height * kWinningPercentage);
    bool blueWin = (_bubbleTop >=
        MediaQuery.of(context).size.height * (1 - kWinningPercentage));

    if (blueWin || greenWin) {
      HapticFeedback.heavyImpact();

      if (blueWin) {
        await _showGameFinishedDialog("blue");
      } else {
        await _showGameFinishedDialog("green");
      }

      _endGameActivity();
    }
  }

  _endGameActivity() {
    setState(() {
      _bubbleTop = 0;
      _participantCount = 0;
      _isHost = false;
      _session = null;
    });

    _shareplayPlugin.end();
  }

  Future<void> _showGameFinishedDialog(String winner) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game finished!'),
          content: Text('The winner is: $winner'),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
