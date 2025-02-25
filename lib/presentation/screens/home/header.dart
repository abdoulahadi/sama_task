import 'package:flutter/material.dart';
import 'package:sama_task/core/constants/app_colors.dart';
import 'package:sama_task/presentation/widgets/priority_card.dart';

class SamaTaskHeader extends StatefulWidget {
  final int lowCount;
  final int mediumCount;
  final int highCount;

  const SamaTaskHeader({
    super.key,
    required this.lowCount,
    required this.mediumCount,
    required this.highCount,
  });

  @override
  State<SamaTaskHeader> createState() => _SamaTaskHeaderState();
}

class _SamaTaskHeaderState extends State<SamaTaskHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 1.2,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/samatask_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            PriorityCard(number: widget.lowCount, priority: 'Basse'),
            PriorityCard(number: widget.mediumCount, priority: 'Moyenne'),
            PriorityCard(number: widget.highCount, priority: 'Elevée'),
          ],
        ),
      ],
    );
  }
}