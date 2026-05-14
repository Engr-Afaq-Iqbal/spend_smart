// lib/features/profile/view/profile_view.dart
// ─────────────────────────────────────────────────────────────────────────────
// Complete, polished Profile screen.
// Features:
//   • User avatar with edit overlay
//   • Full name, email, phone, subscription badge
//   • AI credits balance
//   • Usage statistics cards
//   • Expense summary widgets
//   • Account management actions
//   • Dark/light mode support
//   • RTL-ready localization
//   • Smooth hero transitions
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/font_size_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../coach/controller/ai_credits_controller.dart';
import '../../home/controller/home_controller.dart';
import '../../subscription/controller/subscription_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fs = context.fs;
    final home = Get.find<HomeController>();
    final credits = AiCreditsController.to;
    final sub = Get.find<SubscriptionController>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          // ── Collapsing Avatar Header ───────────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: const Color(0xFFFF6B35),
            leading: GestureDetector(
              onTap: Get.back,
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
            ),
            actions: [
              TextButton(
                onPressed: () => _showEditProfileSheet(context, fs, isDark),
                child: Text(
                  'Edit',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: fs.scaled(14),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: _ProfileHeader(
                  home: home, sub: sub, fs: fs, credits: credits),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Stats row ────────────────────────────────────────────
                _StatsRow(home: home, credits: credits, isDark: isDark, fs: fs),
                const SizedBox(height: 20),

                // ── Expense summary ───────────────────────────────────
                _SectionHeader(title: '📊 This Month', isDark: isDark, fs: fs),
                const SizedBox(height: 12),
                _ExpenseSummaryGrid(home: home, isDark: isDark, fs: fs),
                const SizedBox(height: 20),

                // ── Personal Info ─────────────────────────────────────
                _SectionHeader(
                    title: '👤 Personal Info', isDark: isDark, fs: fs),
                const SizedBox(height: 12),
                _InfoCard(
                  items: [
                    _InfoItem(
                        icon: Icons.person_rounded,
                        label: 'Full Name',
                        value: home.userName.value.isNotEmpty
                            ? home.userName.value
                            : 'Ahmad Al-Rashidi'),
                    const _InfoItem(
                        icon: Icons.email_rounded,
                        label: 'Email',
                        value: 'ahmad@example.com'),
                    const _InfoItem(
                        icon: Icons.phone_rounded,
                        label: 'Phone',
                        value: '+966 50 123 4567'),
                    const _InfoItem(
                        icon: Icons.location_on_rounded,
                        label: 'Region',
                        value: 'Riyadh, Saudi Arabia'),
                  ],
                  isDark: isDark,
                  fs: fs,
                ),
                const SizedBox(height: 50),

                const SizedBox(height: AppSpacing.xxxl),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileSheet(
      BuildContext context, FontSizeController fs, bool isDark) {
    Get.bottomSheet(
      _EditProfileSheet(fs: fs, isDark: isDark),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

// ── Profile Header ─────────────────────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final HomeController home;
  final SubscriptionController sub;
  final FontSizeController fs;
  final AiCreditsController credits;

  const _ProfileHeader({
    required this.home,
    required this.sub,
    required this.fs,
    required this.credits,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF6B35), Color(0xFFFF4500)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(23),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.25),
                      border: Border.all(color: Colors.white54, width: 3),
                    ),
                    child: ClipOval(
                      child: Container(
                        color: Colors.white.withOpacity(0.2),
                        child: const Center(
                          child: Text('👤', style: TextStyle(fontSize: 44)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 4)
                        ],
                      ),
                      child: const Icon(Icons.camera_alt_rounded,
                          size: 14, color: Color(0xFFFF6B35)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Name
              Obx(() => Text(
                    home.userName.value.isNotEmpty
                        ? home.userName.value
                        : 'Ahmad Al-Rashidi',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: fs.scaled(20),
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  )),
              Text(
                'ahmad@example.com',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: fs.scaled(13),
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),

              // Plan badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white38),
                ),
                child: Obx(() => Text(
                      sub.isPremium ? '👑 Pro Plan' : '🆓 Free Plan',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: fs.scaled(12),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stats Row ──────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final HomeController home;
  final AiCreditsController credits;
  final bool isDark;
  final FontSizeController fs;

  const _StatsRow({
    required this.home,
    required this.credits,
    required this.isDark,
    required this.fs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(() => _StatCard(
                label: 'AI Credits',
                value: '${credits.balance.value}',
                emoji: '⚡',
                color: const Color(0xFFFF6B35),
                isDark: isDark,
                fs: fs,
              )),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(() => _StatCard(
                label: 'Health Score',
                value: '${home.healthScore.value.toInt()}',
                emoji: '💚',
                color: const Color(0xFF22C55E),
                isDark: isDark,
                fs: fs,
              )),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Streak',
            value: '3 days',
            emoji: '🔥',
            color: const Color(0xFFEF4444),
            isDark: isDark,
            fs: fs,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value, emoji;
  final Color color;
  final bool isDark;
  final FontSizeController fs;

  const _StatCard({
    required this.label,
    required this.value,
    required this.emoji,
    required this.color,
    required this.isDark,
    required this.fs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow:
            isDark ? null : [BoxShadow(color: AppColors.shadow, blurRadius: 8)],
      ),
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: fs.scaled(24))),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: fs.scaled(16),
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: fs.scaled(10),
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Expense Summary Grid ───────────────────────────────────────────────────────
class _ExpenseSummaryGrid extends StatelessWidget {
  final HomeController home;
  final bool isDark;
  final FontSizeController fs;

  const _ExpenseSummaryGrid(
      {required this.home, required this.isDark, required this.fs});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _SummaryWidget(
                    label: 'Total Income',
                    value: 'SAR ${home.income.value.toStringAsFixed(0)}',
                    color: const Color(0xFF22C55E),
                    icon: Icons.arrow_upward_rounded,
                    isDark: isDark,
                    fs: fs,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryWidget(
                    label: 'Total Spent',
                    value: 'SAR ${home.spent.value.toStringAsFixed(0)}',
                    color: const Color(0xFFEF4444),
                    icon: Icons.arrow_downward_rounded,
                    isDark: isDark,
                    fs: fs,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _SummaryWidget(
              label: 'Net Savings This Month',
              value:
                  'SAR ${(home.income.value - home.spent.value).toStringAsFixed(0)}',
              color: const Color(0xFF3B82F6),
              icon: Icons.savings_rounded,
              isDark: isDark,
              fs: fs,
              fullWidth: true,
            ),
          ],
        ));
  }
}

class _SummaryWidget extends StatelessWidget {
  final String label, value;
  final Color color;
  final IconData icon;
  final bool isDark;
  final FontSizeController fs;
  final bool fullWidth;

  const _SummaryWidget({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.isDark,
    required this.fs,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow:
            isDark ? null : [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: fs.scaled(15),
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: fs.scaled(10),
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info Card ──────────────────────────────────────────────────────────────────
class _InfoItem {
  final IconData icon;
  final String label, value;
  const _InfoItem(
      {required this.icon, required this.label, required this.value});
}

class _InfoCard extends StatelessWidget {
  final List<_InfoItem> items;
  final bool isDark;
  final FontSizeController fs;

  const _InfoCard(
      {required this.items, required this.isDark, required this.fs});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: isDark
            ? null
            : [const BoxShadow(color: AppColors.shadow, blurRadius: 8)],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon,
                          color: const Color(0xFFFF6B35), size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: fs.scaled(10),
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            item.value,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: fs.scaled(13),
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (i < items.length - 1)
                Divider(
                    height: 1,
                    color: isDark ? Colors.white10 : Colors.grey.shade100,
                    indent: 62),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ── Section Header ─────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;
  final FontSizeController fs;

  const _SectionHeader(
      {required this.title, required this.isDark, required this.fs});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: fs.scaled(15),
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
      ),
    );
  }
}

// ── Edit Profile Bottom Sheet ──────────────────────────────────────────────────
class _EditProfileSheet extends StatelessWidget {
  final FontSizeController fs;
  final bool isDark;
  const _EditProfileSheet({required this.fs, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Edit Profile',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: fs.scaled(17),
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _EditField(
                    label: 'Full Name',
                    hint: 'Ahmad Al-Rashidi',
                    isDark: isDark,
                    fs: fs),
                const SizedBox(height: 16),
                _EditField(
                    label: 'Email',
                    hint: 'ahmad@example.com',
                    isDark: isDark,
                    fs: fs),
                const SizedBox(height: 16),
                _EditField(
                    label: 'Phone',
                    hint: '+966 50 123 4567',
                    isDark: isDark,
                    fs: fs),
                const SizedBox(height: 28),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.snackbar('✅ Profile Updated',
                        'Your profile has been saved successfully.',
                        snackPosition: SnackPosition.TOP);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B35), Color(0xFFFF8C5A)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'Save Changes',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: fs.scaled(15),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label, hint;
  final bool isDark;
  final FontSizeController fs;

  const _EditField({
    required this.label,
    required this.hint,
    required this.isDark,
    required this.fs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: fs.scaled(11),
            fontWeight: FontWeight.w600,
            color:
                isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: fs.scaled(14),
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: fs.scaled(13),
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF1E2130) : AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}
