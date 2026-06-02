import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_agent/core/theme/app_theme.dart';
import 'package:student_agent/data/mock/mock_data.dart';

class TimetableScreen extends ConsumerWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedule = MockData.weeklySchedule;
    final days = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: Text('Tuần ${schedule.currentWeek} / ${schedule.totalWeeks}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 20),
            onPressed: () {},
            tooltip: 'Tạo lại lịch',
          ),
        ],
      ),
      body: Column(
        children: [
          // Day header row
          Container(
            color: AppTheme.surfaceDark,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: days
                  .map((d) => Expanded(
                        child: Center(
                          child: Text(d,
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textSecondary)),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const Divider(height: 0),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildTimeSlot('08:00', schedule.lectures
                    .where((l) => l.subtitle.contains('08:'))
                    .toList()),
                _buildTimeSlot('09:00', schedule.classes
                    .where((c) => c.subtitle.contains('09:'))
                    .toList()),
                _buildTimeSlot('10:00', schedule.lectures
                    .where((l) => l.subtitle.contains('10:'))
                    .toList()),
                _buildTimeSlot('13:00', schedule.classes
                    .where((c) => c.subtitle.contains('13:'))
                    .toList()),
                _buildTimeSlot('14:00',
                    schedule.assignments.where((a) => false).toList()),
                _buildTimeSlot('19:00', []),
                _buildTimeSlot('20:00', []),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(String time, List items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 44,
            child: Text(time,
                style: const TextStyle(
                    fontSize: 11, color: AppTheme.textMuted)),
          ),
          Expanded(
            child: items.isEmpty
                ? Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  )
                : Column(
                    children: items
                        .map((item) => Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryBlueGlow,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: AppTheme.primaryBlue
                                        .withValues(alpha: 0.3),
                                    width: 1),
                              ),
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.primaryBlue,
                                    fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
