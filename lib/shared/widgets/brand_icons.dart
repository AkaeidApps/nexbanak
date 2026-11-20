import 'package:flutter/material.dart';

/// Pixel-perfect vector brand logos and icons for banking, MFS, telcos, utilities, and cards.
class BrandIcons {
  BrandIcons._();

  /// bKash Origami Pink Bird Logo
  static Widget bkash({double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE2136E),
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFFE2136E).withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: CustomPaint(
          size: Size(size * 0.65, size * 0.65),
          painter: _BkashPainter(),
        ),
      ),
    );
  }

  /// Nagad Orange-Red Flame Swoosh Logo
  static Widget nagad({double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFFF7941D), Color(0xFFED1C24)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFFED1C24).withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: CustomPaint(
          size: Size(size * 0.65, size * 0.65),
          painter: _NagadPainter(),
        ),
      ),
    );
  }

  /// Rocket Dutch-Bangla Purple Rocket Logo
  static Widget rocket({double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF8C1D40),
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF8C1D40).withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.rocket_launch_rounded,
          color: Colors.white,
          size: size * 0.55,
        ),
      ),
    );
  }

  /// Upay Cyan U-Emblem Logo
  static Widget upay({double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF00A896), Color(0xFF028090)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Center(
        child: Text(
          'u',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.6,
            fontFamily: 'sans-serif',
            height: 1,
          ),
        ),
      ),
    );
  }

  /// Grameenphone Ribbon Bloom
  static Widget grameenphone({double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF00A3E0),
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Center(
        child: CustomPaint(
          size: Size(size * 0.6, size * 0.6),
          painter: _GpPainter(),
        ),
      ),
    );
  }

  /// Robi Red-Orange Slanted Cube Logo
  static Widget robi({double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFFE4002B), Color(0xFFFF5900)],
        ),
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Center(
        child: Icon(
          Icons.interests_rounded,
          color: Colors.white,
          size: size * 0.6,
        ),
      ),
    );
  }

  /// Banglalink Orange Tiger Stripe Logo
  static Widget banglalink({double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFFF6600),
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Center(
        child: Text(
          'bl',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: size * 0.45,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  /// Teletalk Green Flag Logo
  static Widget teletalk({double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF008751),
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Center(
        child: Container(
          width: size * 0.35,
          height: size * 0.35,
          decoration: const BoxDecoration(
            color: Color(0xFFF42A41),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  /// Airtel Red Circle Logo
  static Widget airtel({double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE40000),
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Center(
        child: Text(
          'a',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.55,
          ),
        ),
      ),
    );
  }

  /// Visa Badge
  static Widget visa({double size = 32}) {
    return Container(
      width: size * 1.5,
      height: size,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F71),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          'VISA',
          style: TextStyle(
            color: const Color(0xFFF7B600),
            fontWeight: FontWeight.w900,
            fontSize: size * 0.45,
            fontStyle: FontStyle.italic,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  /// Mastercard Interlocking Circles
  static Widget mastercard({double size = 32}) {
    return SizedBox(
      width: size * 1.5,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            left: size * 0.15,
            child: Container(
              width: size * 0.65,
              height: size * 0.65,
              decoration: const BoxDecoration(
                color: Color(0xFFEB001B),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: size * 0.15,
            child: Container(
              width: size * 0.65,
              height: size * 0.65,
              decoration: BoxDecoration(
                color: const Color(0xFFF79E1B).withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// American Express Badge
  static Widget amex({double size = 32}) {
    return Container(
      width: size * 1.5,
      height: size,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF006FCF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          'AMEX',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.35,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  /// Bank Emblem helper (City Bank, BRAC, DBBL, Islami, EBL, NexBank)
  static Widget bankLogo(String bankName, {double size = 32}) {
    final String key = bankName.toLowerCase();
    if (key.contains('city')) {
      return _bankBadge('CITY', const Color(0xFFD32F2F), Colors.white, size);
    } else if (key.contains('brac')) {
      return _bankBadge('BRAC', const Color(0xFF003875), const Color(0xFFFFC72C), size);
    } else if (key.contains('dbbl') || key.contains('dutch')) {
      return _bankBadge('DBBL', const Color(0xFF006837), Colors.white, size);
    } else if (key.contains('islami')) {
      return _bankBadge('IBBL', const Color(0xFF008450), Colors.white, size);
    } else if (key.contains('ebl') || key.contains('eastern')) {
      return _bankBadge('EBL', const Color(0xFF002F6C), const Color(0xFFE5A823), size);
    }
    return _bankBadge('NEX', const Color(0xFF0B1F3A), const Color(0xFF1D4ED8), size);
  }

  static Widget _bankBadge(String label, Color bg, Color fg, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: bg.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: fg,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.32,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  /// Utility logos (DESCO, DPDC, WASA, Titas, Internet)
  static Widget utilityLogo(String utilityType, {double size = 32}) {
    final String key = utilityType.toLowerCase();
    if (key.contains('electricity') || key.contains('desco') || key.contains('dpdc')) {
      return _utilityBadge(Icons.bolt_rounded, const Color(0xFFF59E0B), size);
    } else if (key.contains('water') || key.contains('wasa')) {
      return _utilityBadge(Icons.water_drop_rounded, const Color(0xFF0284C7), size);
    } else if (key.contains('gas') || key.contains('titas')) {
      return _utilityBadge(Icons.local_fire_department_rounded, const Color(0xFFEF4444), size);
    } else if (key.contains('internet') || key.contains('broadband')) {
      return _utilityBadge(Icons.wifi_rounded, const Color(0xFF10B981), size);
    }
    return _utilityBadge(Icons.receipt_long_rounded, const Color(0xFF6366F1), size);
  }

  static Widget _utilityBadge(IconData icon, Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(size * 0.25),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Icon(icon, color: color, size: size * 0.55),
    );
  }
}

class _BkashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final Path path = Path()
      ..moveTo(size.width * 0.1, size.height * 0.5)
      ..lineTo(size.width * 0.5, size.height * 0.1)
      ..lineTo(size.width * 0.9, size.height * 0.4)
      ..lineTo(size.width * 0.6, size.height * 0.85)
      ..lineTo(size.width * 0.4, size.height * 0.55)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NagadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final Path path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.3, size.width * 0.6, size.height * 0.1)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.5, size.width * 0.85, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.6, size.height * 0.9, size.width * 0.2, size.height * 0.8)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GpPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final Path path = Path()
      ..moveTo(size.width * 0.5, size.height * 0.1)
      ..lineTo(size.width * 0.85, size.height * 0.5)
      ..lineTo(size.width * 0.5, size.height * 0.9)
      ..lineTo(size.width * 0.15, size.height * 0.5)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
