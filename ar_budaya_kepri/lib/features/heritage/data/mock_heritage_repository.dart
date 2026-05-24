import '../domain/heritage_model.dart';
import '../domain/heritage_repository.dart';

/// Concrete mock data repository implementation of [HeritageRepository].
/// Provides highly detailed and structured content for Riau Islands cultural items.
class MockHeritageRepository implements HeritageRepository {
  // Predefined mockup data representing the traditional Riau Islands cultural items
  static const List<HeritageModel> _mockHeritages = [
    HeritageModel(
      id: 'zapin',
      title: 'Tari Zapin Penyengat',
      shortDescription: 'A classical Malay dance blending Islamic influence and rich percussion.',
      historicalBackground: 'Originating from the island of Penyengat, Tari Zapin is a classical Malay dance that fuses Arabic musical structures with native Malay kinetic sensibilities. Traditionally performed only by males, this dance is a celebratory and educational art form accompanied by the Gambus (lute) and Marwas (small double-faced drums). It showcases highly synchronized legwork representing respect, discipline, and communal joy.',
      location: 'Penyengat Island, Tanjungpinang',
      category: 'Performing Arts',
      imageUrl: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=600&auto=format&fit=crop&q=80', // Replaceable with local assets later
      audioUrl: 'assets/audio/zapin_narration.mp3',
      videoUrl: 'assets/video/zapin_performance.mp4',
    ),
    HeritageModel(
      id: 'boria',
      title: 'Boria',
      shortDescription: 'A vibrant theatrical art combining coral singing and comedic drama.',
      historicalBackground: 'Boria is a traditional musical drama unique to the Malay community in the Riau Islands and neighboring regions. It features two distinct segments: a short, humorous theatrical skit followed by a dynamic choral dance and song routine led by a solo vocalist (the captain). It traditionally conveys social commentary, historical anecdotes, and local wisdom in an engaging, rhythmic manner.',
      location: 'Batam & Bintan',
      category: 'Theatre & Music',
      imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=600&auto=format&fit=crop&q=80',
      audioUrl: 'assets/audio/boria_narration.mp3',
      videoUrl: 'assets/video/boria_performance.mp4',
    ),
    HeritageModel(
      id: 'gazal',
      title: 'Gazal',
      shortDescription: 'Classical Malay music showcasing string orchestration and poetic lyrics.',
      historicalBackground: 'Introduced by Persian traders and refined in the royal courts of Riau-Lingga, Gazal is an elegant musical genre consisting of a harmonium, violin, guitar, tabla, and a tambourine. The lyrics are composed in highly sophisticated Malay pantun (four-line stanzas), addressing spiritual love, local historical events, and courtly etiquette. Performing Gazal requires extreme vocal precision and instrumental balance.',
      location: 'Daek Lingga & Tanjungpinang',
      category: 'Music',
      imageUrl: 'https://images.unsplash.com/photo-1465847899084-d164df4dedc6?w=600&auto=format&fit=crop&q=80',
      audioUrl: 'assets/audio/gazal_narration.mp3',
      videoUrl: 'assets/video/gazal_performance.mp4',
    ),
    HeritageModel(
      id: 'makyong',
      title: 'Makyong',
      shortDescription: 'An ancient dance-drama form combining ritual, dance, and music.',
      historicalBackground: 'Makyong is an exceptionally rare, UNESCO-recognized ancient performing art combining dance, vocal music, improvised acting, and spiritual rituals. Originally performed to heal illnesses or celebrate royal harvests, Makyong features royal characters, celestial spirits, and court jesters. The performance is guided by the haunting strains of the Rebab (two-stringed bowed lute), custom gongs, and double-headed drums.',
      location: 'Bintan & Karimun',
      category: 'UNESCO Performing Arts',
      imageUrl: 'https://images.unsplash.com/photo-1507676184212-d03ab07a01bf?w=600&auto=format&fit=crop&q=80',
      audioUrl: 'assets/audio/makyong_narration.mp3',
      videoUrl: 'assets/video/makyong_performance.mp4',
    ),
    HeritageModel(
      id: 'mendu',
      title: 'Mendu',
      shortDescription: 'A popular folk theatre depicting the legend of Dewa Mendu.',
      historicalBackground: 'Mendu is a traditional folk theatrical performance popular in the Natuna and Anambas archipelagos. The performance tells the serialized mythological tale of Dewa Mendu and his adventures. It blends storytelling with expressive dances, stylized martial arts (Silat), and traditional song sequences. Historically, a single Mendu show could span several consecutive nights in rural fishing villages.',
      location: 'Natuna Islands',
      category: 'Folk Theatre',
      imageUrl: 'https://images.unsplash.com/photo-1503095396549-807759245b35?w=600&auto=format&fit=crop&q=80',
      audioUrl: 'assets/audio/mendu_narration.mp3',
      videoUrl: 'assets/video/mendu_performance.mp4',
    ),
    HeritageModel(
      id: 'gurindam12',
      title: 'Gurindam 12',
      shortDescription: 'A highly revered code of ethics and literary masterpiece.',
      historicalBackground: 'Written in 1847 by the prominent scholar Raja Ali Haji on Penyengat Island, Gurindam 12 is a monumental 12-chapter poetic work detailing moral, ethical, and religious principles. Each chapter contains pairs of rhyming verses (couplets) instructing leaders, parents, and youth on how to conduct themselves. It is revered as the philosophical backbone of Malay culture and is frequently recited in musical or spoken-word performances.',
      location: 'Penyengat Island, Tanjungpinang',
      category: 'Literature & Philosophy',
      imageUrl: 'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=600&auto=format&fit=crop&q=80',
      audioUrl: 'assets/audio/gurindam_narration.mp3',
      videoUrl: 'assets/video/gurindam_reading.mp4',
    ),
    HeritageModel(
      id: 'mandisafar',
      title: 'Mandi Safar',
      shortDescription: 'A symbolic purification ritual performed during the month of Safar.',
      historicalBackground: 'Mandi Safar is a traditional cleansing ritual observed on the beaches of Lingga. Held on the last Wednesday of the Islamic month of Safar, families gather to bathe in the sea or natural spring pools. The ritual is accompanied by collective prayers asking for protection against misfortunes and diseases. It serves as an active social binding event, uniting community members in spiritual reflection and recreation.',
      location: 'Lingga Islands',
      category: 'Customs & Rituals',
      imageUrl: 'https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?w=600&auto=format&fit=crop&q=80',
      audioUrl: 'assets/audio/mandi_safari_narration.mp3',
      videoUrl: 'assets/video/mandi_safari_video.mp4',
    ),
  ];

  @override
  Future<Heritage?> getHeritageById(String id) async {
    // Artificial latency to simulate a network or database call, keeping UI asynchronous
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockHeritages.firstWhere((h) => h.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Heritage>> getAllHeritages() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockHeritages);
  }
}
