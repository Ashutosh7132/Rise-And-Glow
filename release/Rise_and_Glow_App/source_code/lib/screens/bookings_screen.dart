import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart';
import '../services/data_service.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  final DataService _dataService = DataService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allBookings = _dataService.getUserBookings('user_123'); // In real app, get user ID from auth
    final upcomingBookings = allBookings.where((booking) => 
        booking.dateTime.isAfter(DateTime.now()) && 
        (booking.status == BookingStatus.pending || booking.status == BookingStatus.confirmed)
    ).toList();
    final pastBookings = allBookings.where((booking) => 
        booking.dateTime.isBefore(DateTime.now()) || 
        booking.status == BookingStatus.completed
    ).toList();
    final cancelledBookings = allBookings.where((booking) => 
        booking.status == BookingStatus.cancelled
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              text: 'Upcoming (${upcomingBookings.length})',
            ),
            Tab(
              text: 'Past (${pastBookings.length})',
            ),
            Tab(
              text: 'Cancelled (${cancelledBookings.length})',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingsList(upcomingBookings, BookingListType.upcoming),
          _buildBookingsList(pastBookings, BookingListType.past),
          _buildBookingsList(cancelledBookings, BookingListType.cancelled),
        ],
      ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings, BookingListType type) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getEmptyStateIcon(type),
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _getEmptyStateMessage(type),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getEmptyStateSubtitle(type),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return BookingCard(
          booking: bookings[index],
          type: type,
          onCancel: type == BookingListType.upcoming ? () => _cancelBooking(bookings[index]) : null,
          onReschedule: type == BookingListType.upcoming ? () => _rescheduleBooking(bookings[index]) : null,
        );
      },
    );
  }

  IconData _getEmptyStateIcon(BookingListType type) {
    switch (type) {
      case BookingListType.upcoming:
        return Icons.calendar_today;
      case BookingListType.past:
        return Icons.history;
      case BookingListType.cancelled:
        return Icons.cancel_outlined;
    }
  }

  String _getEmptyStateMessage(BookingListType type) {
    switch (type) {
      case BookingListType.upcoming:
        return 'No Upcoming Bookings';
      case BookingListType.past:
        return 'No Past Bookings';
      case BookingListType.cancelled:
        return 'No Cancelled Bookings';
    }
  }

  String _getEmptyStateSubtitle(BookingListType type) {
    switch (type) {
      case BookingListType.upcoming:
        return 'Book a service to see your\nupcoming appointments here';
      case BookingListType.past:
        return 'Your completed appointments\nwill appear here';
      case BookingListType.cancelled:
        return 'Cancelled appointments\nwill appear here';
    }
  }

  void _cancelBooking(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Booking'),
          ),
          TextButton(
            onPressed: () {
              _dataService.updateBookingStatus(booking.id, BookingStatus.cancelled);
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking cancelled successfully')),
              );
            },
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }

  void _rescheduleBooking(Booking booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reschedule feature coming soon!')),
    );
  }
}

enum BookingListType { upcoming, past, cancelled }

class BookingCard extends StatelessWidget {
  final Booking booking;
  final BookingListType type;
  final VoidCallback? onCancel;
  final VoidCallback? onReschedule;

  const BookingCard({
    super.key,
    required this.booking,
    required this.type,
    this.onCancel,
    this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service name and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.service.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    booking.statusText,
                    style: TextStyle(
                      color: _getStatusColor(booking.status),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Date and time
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMM dd, yyyy').format(booking.dateTime),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('hh:mm a').format(booking.dateTime),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Duration and price
            Row(
              children: [
                Icon(
                  Icons.timer,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  '${booking.service.duration} minutes',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.currency_rupee,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  '₹${booking.service.price.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            if (booking.notes != null) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.note,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking.notes!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Action buttons for upcoming bookings
            if (type == BookingListType.upcoming && (onCancel != null || onReschedule != null)) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  if (onReschedule != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onReschedule,
                        child: const Text('Reschedule'),
                      ),
                    ),
                  if (onCancel != null && onReschedule != null)
                    const SizedBox(width: 12),
                  if (onCancel != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onCancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.completed:
        return Colors.blue;
      case BookingStatus.cancelled:
        return Colors.red;
    }
  }
}
