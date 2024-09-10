// import 'package:clone_freelancer_mobile/constant/const.dart';
// import 'package:laravel_echo/laravel_echo.dart';
// import 'package:http/http.dart' as http;

// class LaravelEcho {
//   static LaravelEcho? _singleton;
//   static late Echo _echo;
//   final String token;

//   LaravelEcho._({
//     required this.token,
//   }) {
//     _echo = createLaravelEcho(token);
//   }

//   factory LaravelEcho.init({
//     required String token,
//   }) {
//     if (_singleton == null || token != _singleton?.token) {
//       _singleton = LaravelEcho._(token: token);
//     }

//     return _singleton!;
//   }

//   static Echo get instance => _echo;

//   static String get socketId => _echo.socketId() ?? "11111.11111111";
// }

// class PusherConfig {
//   static const appId = "1706051";
//   static const key = "75e48a8f295a68004bcd";
//   static const secret = "67dd754feb004ce904c9";
//   static const cluster = "ap1";
//   static const hostAuthEndPoint = "$url/api/broadcasting/auth";
//   static const port = 6001;
// }

// void connect() async {
//   try {
//     await pusher.init(
//         apiKey: PusherConfig.key,
//         cluster: PusherConfig.cluster,
//         onConnectionStateChange: onConnectionStateChange,
//         onError: onError,
//         onSubscriptionSucceeded: onSubscriptionSucceeded,
//         onEvent: onEvent,
//         onSubscriptionError: onSubscriptionError,
//         onDecryptionFailure: onDecryptionFailure,
//         onMemberAdded: onMemberAdded,
//         onMemberRemoved: onMemberRemoved,
//         // authEndpoint: "${url}broadcasting/auth",
//         onAuthorizer: onAuthorizer);
//     await pusher.subscribe(channelName: 'private-chat.${widget.chatId}');
//     await pusher.connect();
//   } catch (e) {
//     print("ERROR: $e");
//   }
// }

// PusherClient createPusherClient(String token) {
//   PusherOptions options = PusherOptions(
//     wsPort: PusherConfig.port,
//     encrypted: true,
//     host: url,
//     cluster: PusherConfig.cluster,
//     auth: PusherAuth(
//       PusherConfig.hostAuthEndPoint,
//       headers: {
//         'Authorization': "Bearer $token",
//         'Content-Type': "application/json",
//         'Accept': 'application/json'
//       },
//     ),
//   );

//   PusherClient pusherClient = PusherClient(
//     PusherConfig.key,
//     options,
//     autoConnect: false,
//     enableLogging: true,
//   );

//   return pusherClient;
// }

// Echo createLaravelEcho(String token) {
//   return Echo(
//     client: createPusherClient(token),
//     broadcaster: EchoBroadcasterType.Pusher,
//   );
// }

// dynamic onAuthorizer(
//     String channelName, String socketId, dynamic options) async {
//   var authUrl = await http.post(
//     Uri.parse('${url}broadcasting/auth'),
//     headers: {
//       'Authorization': 'Bearer ${box.read('token')}',
//       'Content-Type': "application/json",
//       'Accept': 'application/json'
//     },
//   );
//   print(authUrl.body);
//   // return {
//   //   "auth": "${PusherConfig.key}:bar",
//   //   "channel_data": '{"user_id": ${box.read('user')['user_id']}}',
//   //   "shared_secret": "foobar"
//   // };
// }

// void onEvent(PusherEvent event) {
//   print("onEvent: $event");
// }

// void onSubscriptionSucceeded(String channelName, dynamic data) {
//   print("onSubscriptionSucceeded: $channelName data: $data");
// }

// void onSubscriptionError(String message, dynamic e) {
//   print("onSubscriptionError: $message Exception: $e");
// }

// void onDecryptionFailure(String event, String reason) {
//   print("onDecryptionFailure: $event reason: $reason");
// }

// void onMemberAdded(String channelName, PusherMember member) {
//   print("onMemberAdded: $channelName member: $member");
// }

// void onMemberRemoved(String channelName, PusherMember member) {
//   print("onMemberRemoved: $channelName member: $member");
// }

// void onConnectionStateChange(dynamic currentState, dynamic previousState) {
//   print("Connection: $currentState");
// }

// void onError(String message, int? code, dynamic e) {
//   print("onError: $message code: $code exception: $e");
// }
