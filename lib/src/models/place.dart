/// 장소 정보를 담는 모델 클래스
class Place {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String? description;
  final String? category;
  final String? iconUrl;
  
  const Place({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.description,
    this.category,
    this.iconUrl,
  });
  
  /// JSON으로부터 Place 객체 생성
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      description: json['description'],
      category: json['category'],
      iconUrl: json['iconUrl'],
    );
  }
  
  /// Place 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'category': category,
      'iconUrl': iconUrl,
    };
  }
}
