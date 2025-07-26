import 'package:flutter/material.dart';
import '../models/service.dart';
import '../services/data_service.dart';
import '../widgets/service_card.dart';
import '../widgets/category_chip.dart';
import 'service_detail_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final DataService _dataService = DataService();
  String _selectedCategory = 'All';
  List<Service> _filteredServices = [];

  @override
  void initState() {
    super.initState();
    _filteredServices = _dataService.services;
  }

  void _filterServices(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'All') {
        _filteredServices = _dataService.services;
      } else {
        _filteredServices = _dataService.getServicesByCategory(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['All', ..._dataService.categories];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Categories Filter
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CategoryChip(
                          category: category,
                          isSelected: _selectedCategory == category,
                          onTap: () => _filterServices(category),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Services Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_filteredServices.length} services found',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    // Sort/Filter options
                    _showSortOptions();
                  },
                  icon: const Icon(Icons.sort),
                ),
              ],
            ),
          ),

          // Services List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredServices.length,
              itemBuilder: (context, index) {
                return ServiceCard(
                  service: _filteredServices[index],
                  onTap: () => _navigateToServiceDetail(_filteredServices[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToServiceDetail(Service service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailScreen(service: service),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort by',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Rating'),
                onTap: () {
                  _sortByRating();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.currency_rupee),
                title: const Text('Price: Low to High'),
                onTap: () {
                  _sortByPriceLowToHigh();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.currency_rupee),
                title: const Text('Price: High to Low'),
                onTap: () {
                  _sortByPriceHighToLow();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Duration'),
                onTap: () {
                  _sortByDuration();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _sortByRating() {
    setState(() {
      _filteredServices.sort((a, b) => b.rating.compareTo(a.rating));
    });
  }

  void _sortByPriceLowToHigh() {
    setState(() {
      _filteredServices.sort((a, b) => a.price.compareTo(b.price));
    });
  }

  void _sortByPriceHighToLow() {
    setState(() {
      _filteredServices.sort((a, b) => b.price.compareTo(a.price));
    });
  }

  void _sortByDuration() {
    setState(() {
      _filteredServices.sort((a, b) => a.duration.compareTo(b.duration));
    });
  }
}
