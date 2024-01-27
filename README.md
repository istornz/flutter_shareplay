<div align="center">
  <img alt="flutter ios 15 shareplay logo" src="https://github.com/istornz/flutter_shareplay/blob/main/images/logo.jpg?raw=true" />
</div>
<br />

<div align="center" style="display: flex;align-items: center;justify-content: center;">
  <a href="https://pub.dev/packages/shareplay"><img src="https://img.shields.io/pub/points/shareplay?style=for-the-badge" style="margin-right: 10px" /></a>
  <a href="https://pub.dev/packages/shareplay"><img src="https://img.shields.io/pub/likes/shareplay?style=for-the-badge" style="margin-right: 10px" /></a>
  <a href="https://pub.dev/packages/shareplay"><img src="https://img.shields.io/pub/popularity/shareplay?style=for-the-badge" style="margin-right: 10px" /></a>
  <a href="https://pub.dev/packages/shareplay"><img src="https://img.shields.io/pub/v/shareplay?style=for-the-badge" style="margin-right: 10px" /></a>
  <a href="https://github.com/istornz/shareplay"><img src="https://img.shields.io/github/stars/istornz/shareplay?style=for-the-badge" /></a>
</div>
<br />

<div align="center">
  <a href="https://radion-app.com" target="_blank" alt="Radion - Ultimate gaming app">
    <img src="https://raw.githubusercontent.com/istornz/flutter_shareplay/main/images/radion.png" width="600px" alt="Radion banner - Ultimate gaming app" />
  </a>
</div>

<br />

A Flutter plugin to use iOS 15.0+ real-time connection **SharePlay** on a FaceTime call 🎥.

## 🧐 What is it ?

This plugin use official [iOS GroupActivities API](https://developer.apple.com/documentation/GroupActivities/).

**share_play** can be used to communicate data over devices in a Flutter apps using iOS SharePlay features.

Why using iOS SharePlay?
- ⚡️ It's **fast**.
- 🍀 **Reliable** (using Apple server).
- 💰 It's "**free**" (including in your paid Apple Developer subscription).
- 😌 Very **easy** to implement (in 3 lines of code you can share data!).
- 🙌 Works accros **iOS**, **macOS** & **tvOS**.

> ⚠️ **share_play** is only intended to use with **iOS 15.0+**!
> It will simply do nothing on other platform & < iOS 15.0

<br />
<div align="center" style="display: flex;align-items: center;justify-content: center;">
  <img alt="flutter ios 15 shareplay group activities preview" src="https://github.com/istornz/flutter_shareplay/blob/main/images/demo.gif?raw=true" width="800px" />
</div>
<br />

## 👻 Getting started

> ℹ️ You can check into the [**example repository**](https://github.com/istornz/flutter_shareplay/tree/main/example) for a full example.

- Open the Xcode workspace project ```ios/Runner.xcworkspace```.
- Enable "**Group Activities**" capabilities on the main ```Runner``` app.
  
<img alt="enable group activities capabilities xcode" src="https://github.com/istornz/flutter_shareplay/blob/main/images/tutorial/group_activities_capability.gif?raw=true" width="700px" />

- Import ```share_play``` & create an instance of the Plugin.

```dart
import 'package:shareplay/shareplay.dart';

// [...]

final _shareplayPlugin = SharePlay();
```

## ℹ️ Quick start

- Add listener when a new message is received (in ```initState()``` method for *ex*).

```dart
@override
void initState() {
  super.initState();
  
  // [...]

  _shareplayPlugin.dataStream().listen((data) {
    // do what you want here :)
  });
}
```

- Start a new activity 🏁.

```dart
_shareplayPlugin.start(title: 'My Activity');
```

- Join activity from another device 📲.

```dart
_shareplayPlugin.join();
```

> ℹ️ By tapping on the ```SharePlay``` banner on top of the screen, you don't need to call ```join()``` method!

- Send your first message.

```dart
_shareplayPlugin.send('Hello from Flutter');
```

> ℹ️ For more, check documentation below or [**example**](https://github.com/istornz/share_play/tree/main/example).

## 📘 Documentation

| Name | Description | Returned value |
| ---- | ----------- | -------- |
| ```.start()``` | Create an activity when a FaceTime call is active  | ```Future<bool>``` State of the new activity is created or not |
| ```.join()``` | Starts the shared activity on the current device, not necessary if user tap on the ```SharePlay``` banner  | ```Future``` When a new activity was joined |
| ```.localParticipant()``` | Use this property to differentiate the participant on the current device from participants on other devices  | ```Future<SPParticipant?>``` The participant on the current device including participant id |
| ```.end()``` | Ends the activity for the entire group  | ```Future``` When the activity was stopped |
| ```.leave()``` | Leaves the current activity  | ```Future``` When the activity was leaved |
| ```.send()``` | Send a message to all other participants  | ```Future``` When the message was sent |
| ```.currentSession()``` | Get the current session on the device  | ```Future<SPSession?>``` Current session including session id & activity title |
| ```.dataStream()``` | The stream of messages received from other participants  | ```Stream<SPDataModel>``` Source participant & message data |
| ```.newSessionStream()``` | A stream of all created sessions  | ```Stream<SPSession>``` Created session including session id & activity title |
| ```.participantsStream()``` | A stream of all active participants in the current session  | ```Stream<List<SPParticipant>>``` All active participants in the activity |
| ```.sessionStateStream()``` | A stream of the current session state.  | ```Stream<SPSessionState>``` Session state (```SPSessionState.waiting```, ```SPSessionState.joined``` or ```SPSessionState.invalidated```)  |
<br />

## 👥 Contributions

Contributions are welcome. Contribute by creating a PR or create an issue 🎉.

## 🎯 Roadmap

- [ ] Add method to check if SharePlay is available.
- [ ] Display a custom error when SharePlay is not available on older iOS version.
- [ ] Implement ```prepareForActivation()``` method.
- [x] Create stream to handle message data & new session created.
- [x] Get local data like participant & session state.
- [x] Leave & end activity.
- [x] Send a message accros SharePlay.
- [x] Join an activity.
- [x] Start a new activity.