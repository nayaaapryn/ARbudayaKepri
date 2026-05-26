/// Abstract representation of a cultural heritage item.
/// This allows the core system to remain fully decouple from concrete implementations
/// and easily swap in alternative traditions in the future.
abstract class Heritage {
  String get id;
  String get title;
  String get shortDescription;
  String get historicalBackground;
  String get location;
  String get category;
  String get imageUrl;
  
  // High-level media links that can be loaded in Unity or local views
  String get audioUrl;
  String get videoUrl;
  
  Map<String, dynamic> toJson();
}

/// Concrete implementation of the [Heritage] model.
class HeritageModel implements Heritage {
  @override
  final String id;
  @override
  final String title;
  @override
  final String shortDescription;
  @override
  final String historicalBackground;
  @override
  final String location;
  @override
  final String category;
  @override
  final String imageUrl;
  @override
  final String audioUrl;
  @override
  final String videoUrl;

  const HeritageModel({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.historicalBackground,
    required this.location,
    required this.category,
    required this.imageUrl,
    required this.audioUrl,
    required this.videoUrl,
  });

  factory HeritageModel.fromJson(Map<String, dynamic> json) {
    return HeritageModel(
      id: json['id'] as String,
      title: json['title'] as String,
      shortDescription: json['shortDescription'] as String,
      historicalBackground: json['historicalBackground'] as String,
      location: json['location'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      audioUrl: json['audioUrl'] as String,
      videoUrl: json['videoUrl'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'shortDescription': shortDescription,
      'historicalBackground': historicalBackground,
      'location': location,
      'category': category,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'videoUrl': videoUrl,
    };
  }
}
