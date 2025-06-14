import 'dart:math';
import 'package:flutter/material.dart';

class LiveAttendanceBadge extends StatefulWidget {
  final VoidCallback onTap;

  const LiveAttendanceBadge({super.key, required this.onTap});

  @override
  State<LiveAttendanceBadge> createState() => _LiveAttendanceBadgeState();
}

class _LiveAttendanceBadgeState extends State<LiveAttendanceBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(); // Continuous blinking
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
            //colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double opacity = 0.6 + 0.4 * sin(_controller.value * 2 * pi);
                return Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 6),
            const Text(
              "Live Attendance",
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),

            Icon(Icons.arrow_forward_ios,color: Colors.white,size: 13,)
          ],
        ),
      ),
    );
  }
}
