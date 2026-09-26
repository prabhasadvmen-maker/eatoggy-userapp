class GetAddressesRequest {
  final Map<String, dynamic>? queryParameters;

  const GetAddressesRequest({this.queryParameters});

  Map<String, dynamic> toJson() => queryParameters ?? {};
}
