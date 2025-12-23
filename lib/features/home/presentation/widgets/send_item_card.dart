import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wasel/core/language/language_cubit.dart';
import 'package:wasel/features/home/presentation/widgets/popular_widget.dart';

class SendItemCard extends StatelessWidget {
  const SendItemCard({super.key, required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.read<LanguageCubit>().getLanguage(context) == 'ar';
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF1E6CFF), const Color(0xFF0F3FAF)],
          // isDark
          //     ? [const Color(0xFF1E6CFF), const Color(0xFF0F3FAF)]
          //     : [const Color(0xFF2F80FF), const Color(0xFF56CCF2)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            print('Send Item Card Tapped');
          },
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: isArabic ? -5 : null,
                right: !isArabic ? -5 : null,
                child: Transform.rotate(
                  angle: isArabic ? -100 : 100,
                  child: Opacity(
                    opacity: 0.15,
                    child: Icon(
                      FontAwesomeIcons.boxOpen,
                      size: 120,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// LEFT CONTENT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ICON
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              FontAwesomeIcons.boxArchive,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// TITLE
                          Text(
                            translate('send_item'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          /// SUBTITLE
                          Text(
                            translate(
                              'courier_documents_gifts_or_anything_else',
                            ),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// BUTTON
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  translate('send_now'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopularWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
