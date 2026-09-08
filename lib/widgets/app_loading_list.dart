import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class AppLoadingList extends StatelessWidget {
  final int itemCount;

  const AppLoadingList({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (_, _) {
        return Container(
          height: 105,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.softMaroon),
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.softMaroon,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.softMaroon,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),

                    const SizedBox(height: 12),

                    FractionallySizedBox(
                      widthFactor: .55,
                      child: Container(
                        height: 11,
                        decoration: BoxDecoration(
                          color: AppColors.softMaroon,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
