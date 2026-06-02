import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_agent/core/theme/app_theme.dart';
import 'package:student_agent/providers/providers.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(title: const Text('Analytics & Insights')),
      body: studentAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryBlue)),
        error: (e, _) =>
            Center(child: Text('Lỗi: $e', style: const TextStyle(color: AppTheme.danger))),
        data: (student) {
          final enrollment = student.enrollments.isNotEmpty
              ? student.enrollments.first
              : null;
          final vle = enrollment?.vleSummary;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  _MetricCard(
                    label: 'Tổng lượt xem',
                    value: '${vle?.totalClicks ?? 0}',
                    icon: Icons.mouse_outlined,
                    color: AppTheme.primaryBlue,
                  ),
                  const SizedBox(width: 8),
                  _MetricCard(
                    label: 'Ngày học gần nhất',
                    value: 'N${vle?.lastActiveDay ?? 0}',
                    icon: Icons.calendar_today_outlined,
                    color: AppTheme.accentGreen,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _MetricCard(
                    label: 'Tỉ lệ nộp bài',
                    value: enrollment != null
                        ? '${((enrollment.assessments.where((a) => a.isSubmitted).length / enrollment.assessments.length) * 100).round()}%'
                        : '—',
                    icon: Icons.assignment_turned_in_outlined,
                    color: AppTheme.warning,
                  ),
                  const SizedBox(width: 8),
                  const _MetricCard(
                    label: 'Streak',
                    value: '12 ngày',
                    icon: Icons.local_fire_department_outlined,
                    color: AppTheme.danger,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // VLE activity by type
              if (vle != null && vle.byActivityType.isNotEmpty) ...[
                const Text('Hoạt động theo loại',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.cardBorder, width: 1),
                  ),
                  child: Column(
                    children: vle.byActivityType.entries.map((entry) {
                      final maxVal = vle.byActivityType.values
                          .reduce((a, b) => a > b ? a : b);
                      final fraction = entry.value / maxVal;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 70,
                              child: Text(entry.key,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary)),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: fraction,
                                  minHeight: 8,
                                  backgroundColor: AppTheme.surfaceDark,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          AppTheme.primaryBlue),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('${entry.value}',
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textSecondary)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: color)),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}
