class RequestItem {
  String method;
  String url;
  dynamic param;

  RequestItem({required this.method, required this.url, this.param = ""});
}
