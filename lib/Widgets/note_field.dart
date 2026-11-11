import 'package:flutter/material.dart';

class NoteField extends StatelessWidget {
  final TextEditingController controller;

  const NoteField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.edit_note,
                color: Color(0xff43318F),
                size: 19,
              ),

              SizedBox(width: 5),

              Text(
                "ملاحظة (اختياري)",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          TextField(
            controller: controller,
            maxLines: 2,
            textAlign: TextAlign.right,

            decoration: InputDecoration(
              hintText:
              "أضف أي ملاحظة هنا...",

              filled: true,

              fillColor:
              const Color(0xffFAF8FF),

              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(12),

                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}