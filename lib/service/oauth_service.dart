import 'package:capstone_v1/url/api_uri.dart';
import 'package:http/http.dart' as http;

class OAuthService {
  final String naverLoginURL =
      '${ApiInfo.mainBaseUrl}' + '${ApiInfo.naverLoginUri}';
  final String googleLoginURL =
      '${ApiInfo.mainBaseUrl}' + '${ApiInfo.googleLoginUri}';

  Future<String> naverLoginCall() async {
    final uri = Uri.parse(naverLoginURL);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // 로그인 URL 반환
      print(response.body);
      return response.body; // HTML 문서가 있는 URL로 수정해야 할 수도 있습니다.
    } else {
      throw Exception("Failed to load URL");
    }
  }

  Future<String> googleLoginCall() async {
    final uri = Uri.parse(googleLoginURL);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // 로그인 URL 반환
      return response.body; // HTML 문서가 있는 URL로 수정해야 할 수도 있습니다.
    } else {
      throw Exception("Failed to load URL");
    }
  }
}
