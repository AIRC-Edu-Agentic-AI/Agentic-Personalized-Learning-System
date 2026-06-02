import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_agent/core/theme/app_theme.dart';
import 'package:student_agent/models/student_model.dart';
import 'package:student_agent/providers/providers.dart';
import 'package:student_agent/screens/landing/widgets/academic_progress_card.dart';
import 'package:student_agent/screens/landing/widgets/this_week_section.dart';
import 'package:student_agent/widgets/glass_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentProvider);
    final scheduleAsync = ref.watch(weeklyScheduleProvider);
    final notifAsync = ref.watch(notificationProvider);
    final unreadCount = ref.watch(unreadCountProvider);
    final isMock = ref.watch(isMockModeProvider);

    ref.listen<AsyncValue<Map<String, dynamic>?>>(healthProvider, (_, next) {
      next.whenData((health) {
        if (health == null) return;
        final db = health['db'] as String? ?? 'unknown';
        final isConnected = db == 'connected';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  isConnected
                      ? Icons.check_circle_outline
                      : Icons.cloud_off_outlined,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(isConnected
                    ? 'Database connected successfully'
                    : 'Running in offline / mock mode'),
              ],
            ),
            backgroundColor:
                isConnected ? AppTheme.accentGreen : AppTheme.textSecondary,
          ),
        );
      });
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: ShaderMask(
          shaderCallback: (b) => AppTheme.blueGreenGradient.createShader(b),
          child: const Text(
            'Student Agent',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        actions: [
          // Notification bell
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: AppTheme.textSecondary),
                onPressed: () {},
                padding: EdgeInsets.zero,
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: AppTheme.danger,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Avatar
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                gradient: AppTheme.blueGreenGradient,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'VA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: studentAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryBlue)),
        error: (e, _) => Center(
          child: Text('Lỗi tải dữ liệu: $e',
              style: const TextStyle(color: AppTheme.danger)),
        ),
        data: (student) => CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Mock indicator ─────────────────────────────────
                  if (isMock)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.warningGlow,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppTheme.warning.withValues(alpha: 0.3),
                            width: 1),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.data_usage_rounded,
                              size: 14, color: AppTheme.warning),
                          SizedBox(width: 6),
                          Text(
                            'Demo — dữ liệu mẫu',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.warning,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),

                  // ── 1. Welcome ──────────────────────────────────────
                  _WelcomeSection(student: student),
                  const SizedBox(height: 16),

                  // ── 2. Risk + Academic progress ─────────────────────
                  _RiskCard(student: student),
                  const SizedBox(height: 10),
                  scheduleAsync.when(
                    loading: () => const AcademicProgressCard.loading(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (schedule) =>
                        AcademicProgressCard(schedule: schedule),
                  ),
                  const SizedBox(height: 16),

                  // ── 3. Notifications ────────────────────────────────
                  notifAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (notifs) {
                      final unread = notifs.where((n) => !n.read).toList();
                      if (unread.isEmpty) return const SizedBox.shrink();
                      return _NotificationsSection(notifications: unread);
                    },
                  ),

                  // ── 4. Flags ────────────────────────────────────────
                  if (student.risk.flags.isNotEmpty) ...[
                    _FlagsSection(flags: student.risk.flags),
                    const SizedBox(height: 16),
                  ],

                  // ── 5. Prerequisite gaps ────────────────────────────
                  if (student.prerequisiteGaps.isNotEmpty) ...[
                    _GapsSection(gaps: student.prerequisiteGaps),
                    const SizedBox(height: 16),
                  ],

                  // ── 6. This week ────────────────────────────────────
                  scheduleAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (schedule) => ThisWeekSection(schedule: schedule),
                  ),
                  const SizedBox(height: 16),

                  // ── 7. Enrollments ──────────────────────────────────
                  _EnrollmentsSection(enrollments: student.enrollments),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Welcome ───────────────────────────────────────────────────────────────────
class _WelcomeSection extends StatelessWidget {
  final StudentModel student;
  const _WelcomeSection({required this.student});

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Chào buổi sáng';
    if (h < 18) return 'Chào buổi chiều';
    return 'Chào buổi tối';
  }

  @override
  Widget build(BuildContext context) {
    final enrollment =
        student.enrollments.isNotEmpty ? student.enrollments.first : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary),
            children: [
              TextSpan(text: '$_greeting, '),
              WidgetSpan(
                child: ShaderMask(
                  shaderCallback: (b) =>
                      AppTheme.blueGreenGradient.createShader(b),
                  child: Text(
                    student.shortName,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
              const TextSpan(text: '!'),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            _RiskBadge(tier: student.risk.tier),
            if (enrollment != null) ...[
              const SizedBox(width: 8),
              Text(
                'Module ${enrollment.codeModule}',
                style: const TextStyle(
                    fontSize: 13, color: AppTheme.textSecondary),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _RiskBadge extends StatelessWidget {
  final int tier;
  const _RiskBadge({required this.tier});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (tier) {
      1 => (AppTheme.successGlow, AppTheme.success, 'Đúng tiến độ'),
      2 => (AppTheme.warningGlow, AppTheme.warning, 'Cần hỗ trợ'),
      3 => (AppTheme.dangerGlow, AppTheme.danger, 'Cần can thiệp'),
      _ => (AppTheme.surfaceCard, AppTheme.textSecondary, 'Không rõ'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 6, color: fg),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: fg, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ── Risk card (glassmorphism) ─────────────────────────────────────────────────
class _RiskCard extends StatelessWidget {
  final StudentModel student;
  const _RiskCard({required this.student});

  @override
  Widget build(BuildContext context) {
    final tier = student.risk.tier;
    final (glowColor, fg, icon) = switch (tier) {
      1 => (AppTheme.accentGreen, AppTheme.accentGreen, Icons.check_circle_outline),
      2 => (AppTheme.warning, AppTheme.warning, Icons.warning_amber_outlined),
      _ => (AppTheme.danger, AppTheme.danger, Icons.error_outline),
    };

    return GlassCard(
      glowColor: glowColor.withValues(alpha: 0.35),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: fg.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: fg, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.risk.tierLabel,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary)),
                const SizedBox(height: 2),
                Text(
                  'Điểm rủi ro: ${(student.risk.score * 100).round()}%',
                  style: const TextStyle(
                      fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Notifications ─────────────────────────────────────────────────────────────
class _NotificationsSection extends ConsumerWidget {
  final List<NotificationModel> notifications;
  const _NotificationsSection({required this.notifications});

  Color _dotColor(String type) => switch (type) {
        'deadline_critical' => AppTheme.danger,
        'deadline_warning' => AppTheme.warning,
        'risk_intervention' => AppTheme.danger,
        _ => AppTheme.primaryBlue,
      };

  void _handleAction(
    BuildContext context,
    WidgetRef ref,
    NotificationModel notif,
    NotificationAction action,
  ) {
    ref.read(notificationProvider.notifier).markRead(notif.id);
    switch (action.action) {
      case 'open_chat':
        context.push('/chat');
      case 'update_milestone':
        final p = action.payload;
        final idAssessment = p['id_assessment'] as int?;
        final milestoneId = p['milestone_id'] as String? ?? '';
        final status = p['status'] as String? ?? 'done';
        if (idAssessment != null) {
          final api = ref.read(apiServiceProvider);
          final studentId = ref.read(activeStudentIdProvider);
          api.updateMilestoneStatus(
            studentId: studentId,
            idAssessment: idAssessment,
            milestoneId: milestoneId,
            status: status,
          );
          ref.invalidate(assignmentMilestonesProvider(idAssessment));
        }
      case 'snooze':
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Thông báo (${notifications.length})',
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.cardBorder, width: 1),
              ),
              child: Column(
                children: notifications
                    .asMap()
                    .entries
                    .map((e) => Column(
                          children: [
                            if (e.key > 0)
                              const Divider(
                                  height: 0, indent: 14, endIndent: 14),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        margin:
                                            const EdgeInsets.only(top: 4),
                                        decoration: BoxDecoration(
                                          color: _dotColor(e.value.type),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(e.value.title,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500,
                                                    color:
                                                        AppTheme.textPrimary)),
                                            const SizedBox(height: 2),
                                            Text(e.value.body,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: AppTheme
                                                        .textSecondary)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (e.value.actionOptions.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      children: e.value.actionOptions
                                          .map((action) => _ActionChip(
                                                action: action,
                                                onTap: () => _handleAction(
                                                    context,
                                                    ref,
                                                    e.value,
                                                    action),
                                              ))
                                          .toList(),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  final NotificationAction action;
  final VoidCallback onTap;
  const _ActionChip({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isChat = action.action == 'open_chat';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isChat
              ? AppTheme.primaryBlue.withValues(alpha: 0.15)
              : AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isChat
                ? AppTheme.primaryBlue.withValues(alpha: 0.4)
                : AppTheme.cardBorder,
            width: 1,
          ),
        ),
        child: Text(
          action.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isChat ? AppTheme.primaryBlue : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ── Risk flags ────────────────────────────────────────────────────────────────
class _FlagsSection extends StatelessWidget {
  final List<String> flags;
  const _FlagsSection({required this.flags});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      glowColor: AppTheme.warning.withValues(alpha: 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cảnh báo',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          ...flags.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 6, color: AppTheme.warning),
                    const SizedBox(width: 8),
                    Text(f.replaceAll('_', ' '),
                        style: const TextStyle(
                            fontSize: 13, color: AppTheme.textSecondary)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ── Prerequisite gaps ─────────────────────────────────────────────────────────
class _GapsSection extends StatelessWidget {
  final List<String> gaps;
  const _GapsSection({required this.gaps});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      glowColor: AppTheme.danger.withValues(alpha: 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Kiến thức cần củng cố',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: gaps
                .map((g) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.dangerGlow,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppTheme.danger.withValues(alpha: 0.3),
                            width: 1),
                      ),
                      child: Text(g,
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.danger)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ── Enrollments ───────────────────────────────────────────────────────────────
class _EnrollmentsSection extends StatelessWidget {
  final List<Enrollment> enrollments;
  const _EnrollmentsSection({required this.enrollments});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Môn học đang học',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.cardBorder, width: 1),
          ),
          child: Column(
            children: enrollments
                .asMap()
                .entries
                .map((entry) => Column(
                      children: [
                        if (entry.key > 0)
                          const Divider(height: 0, indent: 14, endIndent: 14),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlueGlow,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: AppTheme.primaryBlue
                                          .withValues(alpha: 0.3),
                                      width: 1),
                                ),
                                child: Center(
                                  child: Text(entry.value.codeModule,
                                      style: const TextStyle(
                                          color: AppTheme.primaryBlue,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(entry.value.displayName,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: AppTheme.textPrimary)),
                                    Text(
                                      '${entry.value.assessments.where((a) => a.isSubmitted).length}/${entry.value.assessments.length} bài đã nộp',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              if (entry.value.finalResult != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accentGreenGlow,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: AppTheme.accentGreen
                                            .withValues(alpha: 0.3),
                                        width: 1),
                                  ),
                                  child: Text(entry.value.finalResult!,
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.accentGreen)),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
