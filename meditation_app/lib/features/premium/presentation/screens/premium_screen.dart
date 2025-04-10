import 'package:flutter/material.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:meditation_app/features/premium/domain/models/subscription_package.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  int _selectedPackageIndex = 1; // Default to the most popular option
  bool _isProcessing = false;

  final List<SubscriptionPackage> _packages = [
    SubscriptionPackage(
      id: 'monthly',
      name: 'Monthly',
      description: 'Pay monthly, cancel anytime',
      price: 9.99,
      period: 'month',
      features: [
        'Unlimited access to all meditations',
        'Sleep stories and sounds',
        'Mindfulness exercises',
        'Progress tracking',
      ],
    ),
    SubscriptionPackage(
      id: 'yearly',
      name: 'Yearly',
      description: 'Pay yearly, save 50%',
      price: 59.99,
      period: 'year',
      features: [
        'Everything in Monthly plan',
        'Exclusive premium content',
        'Offline downloads',
        'Advanced statistics',
        'Priority support',
      ],
      isMostPopular: true,
      discountPercentage: 50,
    ),
    SubscriptionPackage(
      id: 'lifetime',
      name: 'Lifetime',
      description: 'One-time payment',
      price: 199.99,
      period: 'lifetime',
      features: [
        'Everything in Yearly plan',
        'Future updates for life',
        'Family sharing (up to 6 accounts)',
        'Personal meditation coach',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Get Premium',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3F414E),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Unlock all features and content',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 16,
                          color: Color(0xFFA1A4B2),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      _buildPremiumFeatures(),
                      const SizedBox(height: 30),
                      _buildSubscriptionOptions(),
                      const SizedBox(height: 20),
                      _buildTermsText(),
                    ],
                  ),
                ),
              ),
            ),
            _buildSubscribeButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumFeatures() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8E97FD), Color(0xFF6B75CA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text(
            'Premium Benefits',
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          _buildFeatureItem('Unlimited access to all meditations'),
          _buildFeatureItem('Exclusive sleep stories and sounds'),
          _buildFeatureItem('Advanced statistics and insights'),
          _buildFeatureItem('Offline downloads for on-the-go'),
          _buildFeatureItem('New content added weekly'),
          _buildFeatureItem('Ad-free experience'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Color(0xFF8E97FD),
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'HelveticaNeue',
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionOptions() {
    return Column(
      children: [
        const Text(
          'Choose Your Plan',
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3F414E),
          ),
        ),
        const SizedBox(height: 20),
        ...List.generate(_packages.length, (index) {
          final package = _packages[index];
          final isSelected = _selectedPackageIndex == index;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPackageIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: isSelected ? Color.fromRGBO(142, 151, 253, 0.1) : Colors.white,
                border: Border.all(
                  color: isSelected ? AppColors.primary : const Color(0xFFE5E5E5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? AppColors.primary : const Color(0xFFA1A4B2),
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              package.name,
                              style: const TextStyle(
                                fontFamily: 'HelveticaNeue',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF3F414E),
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (package.isMostPopular)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'BEST VALUE',
                                  style: TextStyle(
                                    fontFamily: 'HelveticaNeue',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          package.description,
                          style: const TextStyle(
                            fontFamily: 'HelveticaNeue',
                            fontSize: 14,
                            color: Color(0xFFA1A4B2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (package.discountPercentage != null)
                        Text(
                          '\$${package.originalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: 'HelveticaNeue',
                            fontSize: 14,
                            color: Color(0xFFA1A4B2),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Text(
                        '\$${package.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3F414E),
                        ),
                      ),
                      Text(
                        package.period == 'lifetime'
                            ? 'one-time'
                            : '/${package.period}',
                        style: const TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 14,
                          color: Color(0xFFA1A4B2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTermsText() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'By continuing, you agree to our Terms of Service and Privacy Policy. Subscriptions automatically renew unless auto-renew is turned off at least 24 hours before the end of the current period.',
        style: TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 12,
          color: Color(0xFFA1A4B2),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSubscribeButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: _isProcessing
              ? null
              : () {
                  _processSubscription();
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: _isProcessing
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Subscribe Now',
                  style: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  void _processSubscription() {
    setState(() {
      _isProcessing = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        // Show success dialog
        _showSuccessDialog();
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                'Subscription Successful!',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3F414E),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'You now have access to all premium features with the ${_packages[_selectedPackageIndex].name} plan.',
                style: const TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 16,
                  color: Color(0xFFA1A4B2),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Close premium screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Start Exploring',
                    style: TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
