import 'package:flutter/material.dart';
import 'package:nexbanak/app/constants/app_constants.dart';
import 'package:nexbanak/app/theme/app_colors.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';

class NexBankLogo extends StatelessWidget {
  const NexBankLogo({
    super.key,
    this.compact = false,
    this.light = false,
    this.size = 40,
    this.showTagline = false,
  });

  final bool compact;
  final bool light;
  final double size;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    final Color foreground = light ? AppColors.white : AppColors.primaryNavy;
    final Color accent = light ? AppColors.gold : AppColors.secondaryBlue;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                light ? AppColors.secondaryBlue : AppColors.primaryNavy,
                light ? AppColors.primaryNavy : AppColors.secondaryBlue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(size * 0.28),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: accent.withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Icon(Icons.account_balance_rounded,
                  color: AppColors.white, size: size * 0.52),
              Positioned(
                right: size * 0.12,
                bottom: size * 0.14,
                child: Container(
                  width: size * 0.16,
                  height: size * 0.16,
                  decoration: const BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!compact) ...<Widget>[
          SizedBox(width: size * 0.28),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  AppConstants.appName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: foreground,
                    letterSpacing: 1.2,
                    fontSize: size * 0.5,
                  ),
                ),
                if (showTagline)
                  Text(
                    AppConstants.tagline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: light ? AppColors.gold : AppColors.textSecondary,
                      fontSize: size * 0.19,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
