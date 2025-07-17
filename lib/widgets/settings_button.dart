import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/router.dart';
import 'package:recipe_app/services/supabase_authentication.dart';
class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});
  void _openDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) =>
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _DrawerItem(
                  icon: Icons.person,
                  label: 'Account',
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed(Screen.account_info.name);
                  },
                ),
                _DrawerItem(
                  icon: Icons.favorite,
                  label: 'Favourites',
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed(Screen.favourite.name);
                  },
                ),
                _DrawerItem(
                  icon: Icons.bar_chart,
                  label: 'Survey',
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed(Screen.survey_data.name);
                  },
                ),
                _DrawerItem(
                  icon: Icons.logout,
                  label: 'Sign Out',
                  onTap: () async {
                    Navigator.pop(context);
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Confirm Sign Out',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Are you sure you want to sign out?',
                              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
                            ),
                            const SizedBox(height: 22),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF475D),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    elevation: 4,
                                  ),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    'Sign Out',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey[600],
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    textStyle: const TextStyle(fontSize: 16),
                                  ),
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                    if (confirmed == true) {
                      final user = SupabaseAuthService.currentUser;
                      if (user != null) {
                        await SupabaseAuthService.signOut();
                      }
                      if (context.mounted) {
                        context.go('/main_auth');
                      }
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _openDrawer(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.settings, color: Colors.black),
      ),
    );
  }
}
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: Colors.black),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}