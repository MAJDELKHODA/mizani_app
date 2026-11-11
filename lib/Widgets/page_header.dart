import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onBack;

  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onBack != null)
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(14),

            child: Container(
              width: 42,
              height: 42,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),

              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Color(0xff6D3CE8),
              ),
            ),
          ),



          const SizedBox(width: 8),
        Expanded(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff241653),
                ),
              ),

              const SizedBox(height: 3),

              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff9A91B1),
                ),
              ),
            ],
          ),
        ),


      ],
    );
  }
}