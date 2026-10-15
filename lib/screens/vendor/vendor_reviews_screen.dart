import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../state/app_state.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../widgets/buttons.dart';
import '../../widgets/layout.dart';

class VendorReviewsScreen extends StatelessWidget {
  const VendorReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final pending = Mock.vendorReviews.where((r) => r.reply == null && !state.isReplied(r.id)).length;

    return ScreenList(
      gap: 14,
      children: [
        Text('Reseñas', style: AppText.display),
        AppCard(
          child: Row(
            children: [
              Column(
                children: [
                  Text('4,9', style: AppText.displayNumber),
                  const Text('★★★★★', style: TextStyle(color: AppColors.brass, fontSize: 13)),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('128 reseñas', style: AppText.labelM),
                    Text(
                      pending == 0 ? '96% te recomienda. Todas respondidas.' : '96% te recomienda. $pending esperan tu respuesta.',
                      style: AppText.muted(AppText.bodyS),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        for (final r in Mock.vendorReviews)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(r.author, style: AppText.labelM)),
                    Text('★' * r.stars + '☆' * (5 - r.stars), style: const TextStyle(color: AppColors.brass, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(r.text, style: AppText.bodyM),
                const SizedBox(height: 6),
                Text(r.date, style: AppText.muted(AppText.bodyS).copyWith(fontSize: 12)),
                const SizedBox(height: 8),
                if (r.reply != null || state.isReplied(r.id))
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(color: AppColors.backgroundSecondary, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const OverlineLabel('TU RESPUESTA', color: AppColors.brassText),
                        const SizedBox(height: 4),
                        Text(r.reply ?? Mock.reviewReplies[r.id] ?? '', style: AppText.bodyS),
                      ],
                    ),
                  )
                else
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextLink('Responder', onTap: () => showAppSheet(context, _ReplySheet(reviewId: r.id, author: r.author, text: r.text))),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ReplySheet extends StatelessWidget {
  const _ReplySheet({required this.reviewId, required this.author, required this.text});

  final String reviewId;
  final String author;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Responder reseña',
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.backgroundSecondary, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(author, style: AppText.labelS), const SizedBox(height: 4), Text('“$text”', style: AppText.muted(AppText.bodyS))],
          ),
        ),
        LabeledField(label: 'Tu respuesta', maxLines: 4, initialValue: Mock.reviewReplies[reviewId]),
        Text('Tu respuesta será pública en tu perfil.', style: AppText.muted(AppText.bodyS)),
        AppButton(
          label: 'Publicar respuesta',
          onPressed: () {
            AppScope.of(context).reply(reviewId);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
