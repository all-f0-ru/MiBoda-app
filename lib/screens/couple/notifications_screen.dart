import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../navigation/shells.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../theme/tokens.dart';
import '../../widgets/layout.dart';
import 'couple_profile_screen.dart' show noticeColors;

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(title: 'Notificaciones'),
      body: ListView(
        children: [
          for (final (label, items) in Mock.notifications) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.screen, 16, Space.screen, 6),
              child: OverlineLabel(label),
            ),
            for (final n in items)
              Material(
                color: n.unread ? AppColors.backgroundSecondary : Colors.transparent,
                child: InkWell(
                  onTap: () => goTo(context, n.route),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Space.screen, vertical: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(builder: (_) {
                          final (bg, fg) = noticeColors(n.tone);
                          return Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                            child: Icon(n.icon, size: 20, color: fg),
                          );
                        }),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(n.text, style: AppText.bodyM),
                              const SizedBox(height: 2),
                              Text(n.time, style: AppText.muted(AppText.bodyS)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
