import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class KakaoMapService {
  /// 주소를 기반으로 검색 후 마커를 반환하는 함수
  Future<Set<Marker>> getMarkersFromAddress(
      KakaoMapController controller, String address) async {
    Set<Marker> markers = {};

    try {
      // 요청 시작 로그
      debugPrint("Starting address search for: $address");

      final request = AddressSearchRequest(
        addr: address,
        analyzeType: AnalyzeType.exact,
      );

      // 주소 검색 요청
      final result = await controller.addressSearch(request);

      // 결과 로그 출력
      debugPrint("Address search completed. Result: ${result.toString()}");

      if (result.list.isNotEmpty) {
        for (var item in result.list) {
          // 좌표 변환 시도
          try {
            LatLng latLng = LatLng(
              double.parse(item.y ?? '0'),
              double.parse(item.x ?? '0'),
            );

            // 마커 생성 및 추가
            markers.add(Marker(
                markerId: item.id ?? UniqueKey().toString(),
                width: 30,
                height: 40,
                latLng: latLng,
                infoWindowFirstShow: true,
                markerImageSrc:
                    'https://cdn4.iconfinder.com/data/icons/e-commerce-404/512/location-1024.png'));

            // 마커 생성 로그
            debugPrint(
                "Marker created for address: ${item.addressName} at $latLng");
          } catch (e) {
            // 좌표 변환 오류 처리
            debugPrint(
                "Error creating LatLng for item: ${item.toString()}, Error: $e");
          }
        }
      } else {
        debugPrint("No results found for the given address.");
      }
    } catch (e) {
      // 전체 프로세스 오류 처리
      debugPrint("Error during address search: $e");
    }

    // 반환 전 마커 로그 출력
    debugPrint("Markers to return: ${markers.length}");
    return markers;
  }
}
