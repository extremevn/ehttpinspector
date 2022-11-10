# e_http_inspector

A Flutter package that inspects http call requests, responses which made by [dio package](https://pub.dev/packages/dio). This package show notifications on each call and UI screen.

## Features

- Show notification on each http call
- Show history http call list, and call detail in UI screen
- Copy http call detail to clipboard

##### Under construction:

- Export http call to postman format or open api

<table>
  <tr>
      <td>
        <img src="./screen_capture/http_call_history_sample.png">
      </td>
      <td>
        <img src="./screen_capture/http_call_detail_history_sample.png" >
      </td>
    </tr>
 </table>

## Getting Started

This package works with dio package

## Usage

### Add dependencies

```yaml
dependencies:
  e_http_inspector: ^1.1.0
```

### Config and use in application

- Init EHttpInspector

```dart
void main() {
  EHttpInspector.init(_dio, _navigatorKey, "EHttpInspector", "EHttpInspector",
      "EHttpInspector channel");
  runApp(const MyApp());
}
```

or init inspector and notification

```dart
var _dio = Dio();
EHttpInspector.initInterceptor(_dio);
...

await EHttpInspector.initNotification(_navigatorKey, "Your channel key", "Your channel name", "You channel description");
```

- Make sure `_navigatorKey` which is used in root MaterialApp.navigatorKey

```dart
MaterialApp(navigatorKey: _navigatorKey);
```

- For other push notification setup please follow [this plugin](https://pub.dev/packages/flutter_local_notifications)

## Issues and feedback

Create issues and add appropriate label on Github issues or into our [mailing list]
For more detail see [CONTRIBUTING](CONTRIBUTING.md)

## Contributor

- [Justin Lewis](https://github.com/justin-lewis) (Maintainer)
- [Chau VP](https://github.com/chauvu1000) (Developer)

## License

[MIT](LICENSE)

[mailing list]: https://groups.google.com/g/ehttpinspector-group

