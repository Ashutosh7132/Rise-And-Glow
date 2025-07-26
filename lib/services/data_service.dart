import '../models/service.dart';
import '../models/booking.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // Sample data for services
  final List<Service> _services = [
    Service(
      id: '1',
      name: 'Hair Cut & Styling',
      description: 'Professional hair cut and styling service',
      price: 500.0,
      duration: 60,
      category: 'Hair',
      imageUrl: 'https://via.placeholder.com/300x200/FF69B4/FFFFFF?text=Hair+Cut',
      rating: 4.5,
      reviewCount: 120,
    ),
    Service(
      id: '2',
      name: 'Facial Treatment',
      description: 'Deep cleansing and rejuvenating facial',
      price: 800.0,
      duration: 90,
      category: 'Skincare',
      imageUrl: 'https://via.placeholder.com/300x200/87CEEB/FFFFFF?text=Facial',
      rating: 4.7,
      reviewCount: 85,
    ),
    Service(
      id: '3',
      name: 'Manicure & Pedicure',
      description: 'Complete nail care and styling',
      price: 600.0,
      duration: 75,
      category: 'Nails',
      imageUrl: 'https://via.placeholder.com/300x200/DDA0DD/FFFFFF?text=Manicure',
      rating: 4.3,
      reviewCount: 95,
    ),
    Service(
      id: '4',
      name: 'Eyebrow Threading',
      description: 'Professional eyebrow shaping',
      price: 200.0,
      duration: 30,
      category: 'Beauty',
      imageUrl: 'https://via.placeholder.com/300x200/98FB98/FFFFFF?text=Eyebrows',
      rating: 4.6,
      reviewCount: 150,
    ),
    Service(
      id: '5',
      name: 'Hair Coloring',
      description: 'Professional hair coloring service',
      price: 1200.0,
      duration: 120,
      category: 'Hair',
      imageUrl: 'https://via.placeholder.com/300x200/FFB6C1/FFFFFF?text=Hair+Color',
      rating: 4.4,
      reviewCount: 78,
    ),
    Service(
      id: '6',
      name: 'Bridal Makeup',
      description: 'Complete bridal makeup package',
      price: 2000.0,
      duration: 180,
      category: 'Makeup',
      imageUrl: 'https://via.placeholder.com/300x200/F0E68C/FFFFFF?text=Bridal+Makeup',
      rating: 4.8,
      reviewCount: 65,
    ),
  ];

  final List<Booking> _bookings = [];

  List<Service> get services => List.unmodifiable(_services);
  List<Booking> get bookings => List.unmodifiable(_bookings);

  List<Service> getServicesByCategory(String category) {
    return _services.where((service) => service.category == category).toList();
  }

  List<String> get categories {
    return _services.map((service) => service.category).toSet().toList();
  }

  Service? getServiceById(String id) {
    try {
      return _services.firstWhere((service) => service.id == id);
    } catch (e) {
      return null;
    }
  }

  void addBooking(Booking booking) {
    _bookings.add(booking);
  }

  List<Booking> getUserBookings(String userId) {
    return _bookings.where((booking) => booking.userId == userId).toList();
  }

  void updateBookingStatus(String bookingId, BookingStatus status) {
    final bookingIndex = _bookings.indexWhere((booking) => booking.id == bookingId);
    if (bookingIndex != -1) {
      final booking = _bookings[bookingIndex];
      final updatedBooking = Booking(
        id: booking.id,
        userId: booking.userId,
        service: booking.service,
        dateTime: booking.dateTime,
        customerName: booking.customerName,
        customerPhone: booking.customerPhone,
        customerEmail: booking.customerEmail,
        status: status,
        notes: booking.notes,
        createdAt: booking.createdAt,
      );
      _bookings[bookingIndex] = updatedBooking;
    }
  }

  List<Service> searchServices(String query) {
    return _services.where((service) =>
        service.name.toLowerCase().contains(query.toLowerCase()) ||
        service.description.toLowerCase().contains(query.toLowerCase()) ||
        service.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
