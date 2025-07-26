# Rise and Glow - Flutter Beauty & Wellness App

A comprehensive Flutter application for booking beauty and wellness services with integrated Paytm payment gateway.

## Features

### 🏠 Home Screen
- Beautiful gradient header with search functionality
- Service categories with category chips
- Featured services carousel with auto-play
- Popular services listing
- Real-time search with results display

### 💅 Services Screen
- Complete service catalog with filtering by category
- Sort services by rating, price, or duration
- Service cards with ratings, prices, and duration
- "All" category option to view all services

### 📅 Service Detail Screen
- Comprehensive service information
- Service features and what's included
- Customer reviews and ratings
- Expandable service header with gradient background
- Direct booking functionality

### 📝 Booking Screen
- Interactive calendar for date selection
- Available time slots display
- Customer information form with validation
- Booking summary with total cost
- Confirmation dialog with booking details

### 🗓️ My Bookings Screen
- Tabbed view: Upcoming, Past, and Cancelled bookings
- Booking status indicators with color coding
- Cancel and reschedule options for upcoming bookings
- Empty state messages for each tab
- Detailed booking cards with service information

### 👤 Profile Screen
- User profile with photo, stats, and member information
- Profile statistics (bookings, completed, rating)
- Settings menu with various options:
  - Personal Information
  - Booking History
  - Favorite Services
  - Payment Methods
  - Notifications
  - Saved Addresses
  - Help & Support
  - About
  - Logout functionality

### 💳 Payment Integration
- Integrated Paytm payment gateway
- Multiple payment methods support:
  - Paytm Wallet
  - Credit/Debit Cards
  - Net Banking
  - UPI (GooglePay, PhonePe, Paytm UPI)
- Secure payment processing with encryption
- Payment fee calculation and display
- Transaction status tracking
- Payment success/failure handling
- Receipt generation with transaction ID

## Technical Implementation

### Architecture
- **Models**: Service and Booking models with JSON serialization
- **Services**: DataService singleton for state management
- **Screens**: Modular screen architecture with proper navigation
- **Widgets**: Reusable components (ServiceCard, CategoryChip, BookingCard)

### Key Dependencies
- `google_fonts`: Custom typography with Poppins font
- `table_calendar`: Interactive calendar for booking dates
- `carousel_slider`: Auto-playing featured services carousel
- `flutter_rating_bar`: Star ratings display and input
- `intl`: Date and time formatting
- `shared_preferences`: Local data persistence
- `image_picker`: Profile picture selection capability
- `paytm_allinonesdk`: Paytm payment gateway integration
- `crypto`: Cryptographic hashing for payment security
- `http`: HTTP client for API communication
- `uuid`: Unique identifier generation for orders

### Design Features
- **Material 3**: Modern Material Design 3 implementation
- **Custom Theme**: Pink/purple gradient color scheme
- **Responsive Design**: Optimized for various screen sizes
- **Smooth Animations**: Page transitions and carousel animations
- **Consistent UI**: Unified design language throughout the app

## Sample Data

The app includes comprehensive sample data:
- **6 Services** across 5 categories (Hair, Skincare, Nails, Beauty, Makeup)
- **Service Categories**: Hair, Skincare, Nails, Beauty, Makeup
- **Price Range**: ₹200 - ₹2000
- **Duration Range**: 30 - 180 minutes
- **Ratings**: 4.3 - 4.8 stars with review counts

## Getting Started

### Prerequisites
- Flutter SDK (>=3.2.5)
- Dart SDK
- Chrome/Edge browser (for web) or Android/iOS device

### Installation
1. Clone the repository
2. Navigate to the project directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   ```bash
   flutter run
   ```

### Available Platforms
- ✅ Web (Chrome, Edge)
- ✅ Android
- ✅ iOS
- ✅ Windows Desktop

## Project Structure
```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── service.dart         # Service model
│   └── booking.dart         # Booking model
├── services/                # Business logic
│   ├── data_service.dart    # Data management service
│   └── payment_service.dart # Paytm payment integration
├── screens/                 # App screens
│   ├── main_screen.dart     # Bottom navigation container
│   ├── home_screen.dart     # Home with search and featured content
│   ├── services_screen.dart # Service catalog with filtering
│   ├── service_detail_screen.dart # Individual service details
│   ├── booking_screen.dart  # Appointment booking flow
│   ├── payment_screen.dart  # Payment processing with Paytm
│   ├── bookings_screen.dart # User bookings management
│   └── profile_screen.dart  # User profile and settings
└── widgets/                 # Reusable UI components
    ├── service_card.dart    # Service display card
    └── category_chip.dart   # Category filter chip
```

## Future Enhancements
- User authentication and registration
- Real-time notifications
- Payment integration
- Location-based salon discovery
- Staff selection for appointments
- Review and rating system
- Social sharing features
- Multi-language support
- Dark mode theme
- Push notifications for appointment reminders

## Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License
This project is licensed under the MIT License - see the LICENSE file for details.

---

Built with ❤️ using Flutter
