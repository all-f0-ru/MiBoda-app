import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../navigation/shells.dart';
import '../../routes.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../theme/tokens.dart';
import '../../widgets/items.dart';
import '../../widgets/layout.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key, this.empty = false});

  /// Muestra el estado vacío (sin conversaciones).
  final bool empty;

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final List<Conversation> items = widget.empty
        ? const []
        : Mock.coupleConversations.where((c) => c.name.toLowerCase().contains(_query.toLowerCase())).toList();

    return Scaffold(
      appBar: const BackAppBar(title: 'Mensajes'),
      body: widget.empty
          ? Center(
              child: EmptyState(
                title: 'Aún no tienes mensajes',
                text: 'Cuando pidas una cotización, la conversación con el proveedor aparecerá aquí.',
                actionLabel: 'Explorar proveedores',
                onAction: () => goTo(context, Routes.marketplaceTab),
              ),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(Space.screen, 4, Space.screen, 8),
                  child: TextField(
                    style: AppText.bodyM,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: const InputDecoration(
                      hintText: 'Buscar conversación',
                      prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                    ),
                  ),
                ),
                if (items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(Space.xl),
                    child: Text('No hay conversaciones con “$_query”.', style: AppText.muted(AppText.bodyM), textAlign: TextAlign.center),
                  ),
                for (final c in items) ConversationTile(conversation: c, onTap: () => Navigator.pushNamed(context, Routes.chat)),
              ],
            ),
    );
  }
}
