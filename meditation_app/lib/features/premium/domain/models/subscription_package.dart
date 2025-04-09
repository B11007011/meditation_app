class SubscriptionPackage {
  final String id;
  final String name;
  final String description;
  final double price;
  final String period;
  final List<String> features;
  final bool isMostPopular;
  final double? discountPercentage;

  SubscriptionPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.period,
    required this.features,
    this.isMostPopular = false,
    this.discountPercentage,
  });

  // Calculate monthly price for annual subscriptions
  double get monthlyPrice {
    if (period == 'year') {
      return price / 12;
    }
    return price;
  }

  // Calculate savings for discounted packages
  double get savings {
    if (discountPercentage != null) {
      return price * discountPercentage! / 100;
    }
    return 0;
  }

  // Get original price before discount
  double get originalPrice {
    if (discountPercentage != null) {
      return price / (1 - discountPercentage! / 100);
    }
    return price;
  }
}
