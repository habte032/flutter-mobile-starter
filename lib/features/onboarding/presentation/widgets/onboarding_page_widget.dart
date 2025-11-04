import 'package:flutter/material.dart';
import '../../../../core/utils/constants/ui_constants.dart';
import '../../domain/entities/onboarding_page_entity.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPageEntity page;

  const OnboardingPageWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image placeholder (you can replace with actual images)
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _getIconForIndex(),
              size: 120,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          kVerticalGap48,
          Text(
            page.title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          kVerticalGap16,
          Text(
            page.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.6),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getIconForIndex() {
    // Return different icons based on page content
    if (page.title.toLowerCase().contains('welcome')) {
      return Icons.waving_hand;
    } else if (page.title.toLowerCase().contains('connected')) {
      return Icons.people;
    } else {
      return Icons.apps;
    }
  }
}

