import 'package:student_agent/models/assignment_milestone_model.dart';
import 'package:student_agent/models/student_model.dart';

class MockData {
  static final StudentModel student = StudentModel(
    id: 'mock_student_001',
    auth0Id: 'auth0|mock_student_001',
    studentId: 28400,
    fullName: 'Nguyễn Văn An',
    shortName: 'Văn An',
    demographics: const Demographics(
      gender: 'M',
      ageBand: '25-35',
      region: 'Hà Nội',
      highestEducation: 'HE Qualification',
      imdBand: '20-30%',
      disability: false,
      numPrevAttempts: 0,
      studiedCredits: 60,
    ),
    enrollments: [
      const Enrollment(
        codeModule: 'BBB',
        codePresentation: '2013J',
        moduleLength: 30,
        finalResult: null,
        assessments: [
          Assessment(
            idAssessment: 1752,
            type: 'TMA',
            dueDate: 19,
            weight: 10,
            score: 78,
            submittedDate: 18,
            isBanked: false,
          ),
          Assessment(
            idAssessment: 1753,
            type: 'TMA',
            dueDate: 47,
            weight: 25,
            score: null,
            submittedDate: null,
            isBanked: false,
          ),
          Assessment(
            idAssessment: 1754,
            type: 'CMA',
            dueDate: 68,
            weight: 15,
            score: null,
            submittedDate: null,
            isBanked: false,
          ),
          Assessment(
            idAssessment: 1755,
            type: 'Exam',
            dueDate: 261,
            weight: 50,
            score: null,
            submittedDate: null,
            isBanked: false,
          ),
        ],
        vleSummary: VleSummary(
          totalClicks: 3842,
          lastActiveDay: 46,
          byActivityType: {
            'resource': 1240,
            'forumng': 287,
            'oucontent': 1100,
            'quiz': 420,
            'url': 312,
            'homepage': 483,
          },
          weeklyClicks: [
            0, 142, 98, 210, 330, 287, 415,
            398, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0,
          ],
        ),
      ),
      Enrollment(
        codeModule: 'FFF',
        codePresentation: '2013J',
        moduleLength: 30,
        finalResult: 'Pass',
        assessments: [
          const Assessment(
            idAssessment: 2100,
            type: 'TMA',
            dueDate: 26,
            weight: 20,
            score: 82,
            submittedDate: 25,
            isBanked: false,
          ),
          const Assessment(
            idAssessment: 2101,
            type: 'Exam',
            dueDate: 261,
            weight: 80,
            score: 71,
            submittedDate: 261,
            isBanked: false,
          ),
        ],
        vleSummary: VleSummary(
          totalClicks: 5210,
          lastActiveDay: 261,
          byActivityType: {
            'resource': 2100,
            'quiz': 980,
            'forumng': 430,
            'oucontent': 1700,
          },
          weeklyClicks: List.generate(30, (i) => i < 10 ? 180 + i * 12 : 0),
        ),
      ),
    ],
    risk: RiskProfile(
      tier: 2,
      score: 0.62,
      flags: ['low_vle_engagement', 'assessment_due_soon'],
      computedAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    prerequisiteGaps: ['Thống kê cơ bản', 'Đại số tuyến tính'],
  );

  static final WeeklySchedule weeklySchedule = WeeklySchedule(
    currentWeek: 7,
    totalWeeks: 30,
    streakDays: 12,
    lectures: [
      WeekItem(
        title: 'Phân tích dữ liệu — BBB',
        subtitle: 'Thứ 2, 08:00',
        dateTime: DateTime.now().add(const Duration(days: 1)),
        isCompleted: false,
      ),
      WeekItem(
        title: 'Hồi quy tuyến tính — BBB',
        subtitle: 'Thứ 4, 10:00',
        dateTime: DateTime.now().add(const Duration(days: 3)),
        isCompleted: false,
      ),
      WeekItem(
        title: 'Kiểm định giả thuyết',
        subtitle: 'Thứ 6, 14:00',
        dateTime: DateTime.now().add(const Duration(days: 5)),
        isCompleted: false,
      ),
    ],
    classes: [
      WeekItem(
        title: 'Lab thực hành Python',
        subtitle: 'Thứ 3, 13:00 · Phòng B204',
        dateTime: DateTime.now().add(const Duration(days: 2)),
        isCompleted: false,
      ),
      WeekItem(
        title: 'Thảo luận nhóm — BBB',
        subtitle: 'Thứ 5, 09:00 · Online',
        dateTime: DateTime.now().add(const Duration(days: 4)),
        isCompleted: false,
      ),
    ],
    assignments: [
      WeekItem(
        title: 'TMA-02 — Phân tích hồi quy',
        subtitle: 'Nộp trước Thứ 6',
        dateTime: DateTime.now().add(const Duration(days: 5)),
        isCompleted: false,
        isUrgent: true,
      ),
      WeekItem(
        title: 'CMA-01 — Quiz chương 3',
        subtitle: 'Nộp trước Thứ 7',
        dateTime: DateTime.now().add(const Duration(days: 6)),
        isCompleted: false,
        isUrgent: false,
      ),
    ],
    exams: [],
  );

  static final List<NotificationModel> notifications = [
    NotificationModel(
      id: 'notif_001',
      studentId: 28400,
      type: 'deadline_warning',
      title: 'TMA-02 — BBB sắp đến hạn',
      body: 'Còn 3 ngày (đến ngày 47). Hãy bắt đầu sớm.',
      read: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      actionOptions: [
        const NotificationAction(
          label: 'Lên kế hoạch',
          action: 'open_chat',
          payload: {'message': 'Giúp tôi lên kế hoạch hoàn thành TMA-02 môn BBB'},
        ),
        const NotificationAction(
          label: 'Nhắc lại sau',
          action: 'snooze',
          payload: {},
        ),
      ],
    ),
    NotificationModel(
      id: 'notif_002',
      studentId: 28400,
      type: 'reminder',
      title: 'Ôn tập hôm nay',
      body: 'Bạn có 4 thẻ flashcard cần ôn tập theo lịch SM-2.',
      read: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      actionOptions: [
        const NotificationAction(
          label: 'Hỏi trợ lý',
          action: 'open_chat',
          payload: {'message': 'Hôm nay tôi nên ôn tập gì?'},
        ),
      ],
    ),
  ];

  static final List<Map<String, dynamic>> studyPlanSessions = [
    {
      'subject': 'Ôn tập Tuần 6 — BBB',
      'type': 'review',
      'duration': 45,
      'day': 'Thứ 2',
      'time': '19:00',
      'sm2_interval': 3,
    },
    {
      'subject': 'Đọc tài liệu Tuần 7',
      'type': 'new',
      'duration': 60,
      'day': 'Thứ 3',
      'time': '20:00',
      'sm2_interval': null,
    },
    {
      'subject': 'Luyện tập TMA-02',
      'type': 'practice',
      'duration': 90,
      'day': 'Thứ 4',
      'time': '19:30',
      'sm2_interval': null,
    },
    {
      'subject': 'Flashcard Tuần 5–6',
      'type': 'spaced_rep',
      'duration': 20,
      'day': 'Thứ 5',
      'time': '08:00',
      'sm2_interval': 7,
    },
    {
      'subject': 'Hoàn thiện TMA-02',
      'type': 'assignment',
      'duration': 120,
      'day': 'Thứ 6',
      'time': '14:00',
      'sm2_interval': null,
    },
  ];

  static final Map<String, dynamic> knowledgeState = {
    'Thống kê cơ bản': {
      'mastery': 0.35,
      'last_updated': '2025-01-10',
      'evidence_count': 2,
    },
    'Đại số tuyến tính': {
      'mastery': 0.28,
      'last_updated': '2025-01-12',
      'evidence_count': 1,
    },
    'Hồi quy tuyến tính': {
      'mastery': 0.55,
      'last_updated': '2025-01-18',
      'evidence_count': 3,
    },
    'Kiểm định giả thuyết': {
      'mastery': 0.42,
      'last_updated': '2025-01-20',
      'evidence_count': 2,
    },
  };

  static AssignmentMilestonesData milestonesFor(int idAssessment) {
    if (idAssessment == 1753) {
      return AssignmentMilestonesData(
        idAssessment: 1753,
        module: 'BBB',
        title: 'TMA-02 — Phân tích hồi quy',
        milestones: [
          const MilestoneModel(
            id: 'm1',
            title: 'Đọc đề bài & tài liệu tham khảo',
            status: MilestoneStatus.done,
            dueOffsetDays: -14,
          ),
          const MilestoneModel(
            id: 'm2',
            title: 'Phân tích dữ liệu ban đầu',
            status: MilestoneStatus.inProgress,
            dueOffsetDays: -7,
          ),
          const MilestoneModel(
            id: 'm3',
            title: 'Viết báo cáo nháp',
            status: MilestoneStatus.pending,
            dueOffsetDays: -3,
          ),
          const MilestoneModel(
            id: 'm4',
            title: 'Nộp bài chính thức',
            status: MilestoneStatus.pending,
            dueOffsetDays: 0,
          ),
        ],
      );
    }
    return const AssignmentMilestonesData(
      idAssessment: 0,
      module: '',
      title: '',
      milestones: [],
    );
  }

  static final List<Map<String, dynamic>> resources = [
    {
      'title': 'Slide Tuần 7 — Kiểm định giả thuyết',
      'module': 'BBB',
      'type': 'slide',
      'url': 'https://example.com/bbb-w7-slides.pdf',
      'bookmarked': true,
    },
    {
      'title': 'Tài liệu đọc thêm — Hồi quy tuyến tính',
      'module': 'BBB',
      'type': 'document',
      'url': 'https://example.com/linear-regression.pdf',
      'bookmarked': false,
    },
    {
      'title': 'Video hướng dẫn Python pandas',
      'module': 'BBB',
      'type': 'video',
      'url': 'https://example.com/pandas-tutorial',
      'bookmarked': true,
    },
    {
      'title': 'Quiz tự luyện chương 3',
      'module': 'BBB',
      'type': 'quiz',
      'url': 'https://example.com/quiz-ch3',
      'bookmarked': false,
    },
  ];
}
