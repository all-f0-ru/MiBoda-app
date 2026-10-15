import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../routes.dart';
import '../../theme/text.dart';
import '../../theme/tokens.dart';
import '../../widgets/items.dart';

class VendorMessagesScreen extends StatelessWidget {
  const VendorMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: Space.xl, bottom: Space.xl),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.screen, 0, Space.screen, 12),
          child: Text('Mensajes', style: AppText.display),
        ),
        for (final c in Mock.vendorConversations)
          ConversationTile(conversation: c, onTap: () => Navigator.pushNamed(context, Routes.requestDetail)),
      ],
    );
  }
}
