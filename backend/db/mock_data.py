from datetime import datetime, timedelta

MOCK_STUDENT = {
    "_id": "mock_student_001",
    "auth0_id": "auth0|mock_student_001",
    "student_id": 28400,
    "full_name": "Nguyễn Văn An",
    "short_name": "Văn An",
    "demographics": {
        "gender": "M",
        "age_band": "25-35",
        "region": "Hà Nội",
        "highest_education": "HE Qualification",
        "imd_band": "20-30%",
        "disability": False,
        "num_prev_attempts": 0,
        "studied_credits": 60,
    },
    "enrollments": [
        {
            "code_module": "BBB",
            "code_presentation": "2013J",
            "module_length": 30,
            "registration_date": -15,
            "unregistration_date": None,
            "final_result": None,
            "assessments": [
                {"id_assessment": 1752, "type": "TMA", "due_date": 19,
                 "weight": 10, "score": 78, "submitted_date": 18, "is_banked": False},
                {"id_assessment": 1753, "type": "TMA", "due_date": 47,
                 "weight": 25, "score": None, "submitted_date": None, "is_banked": False},
                {"id_assessment": 1754, "type": "CMA", "due_date": 68,
                 "weight": 15, "score": None, "submitted_date": None, "is_banked": False},
                {"id_assessment": 1755, "type": "Exam", "due_date": 261,
                 "weight": 50, "score": None, "submitted_date": None, "is_banked": False},
            ],
            "vle_summary": {
                "total_clicks": 3842,
                "last_active_day": 46,
                "by_activity_type": {
                    "resource": 1240, "forumng": 287,
                    "oucontent": 1100, "quiz": 420,
                    "url": 312, "homepage": 483,
                },
                "weekly_clicks": [
                    0, 142, 98, 210, 330, 287, 415, 398,
                    *([0] * 22)
                ],
            },
        },
    ],
    "risk": {
        "tier": 2,
        "score": 0.62,
        "flags": ["low_vle_engagement", "assessment_due_soon"],
        "computed_at": datetime.utcnow().isoformat(),
    },
    "prerequisite_gaps": ["Thống kê cơ bản", "Đại số tuyến tính"],
    "updated_at": datetime.utcnow().isoformat(),
}

MOCK_SCHEDULE = {
    "current_week": 7,
    "total_weeks": 30,
    "streak_days": 12,
    "lectures": [
        {"title": "Phân tích dữ liệu — BBB", "subtitle": "Thứ 2, 08:00",
         "is_completed": False, "is_urgent": False},
        {"title": "Hồi quy tuyến tính — BBB", "subtitle": "Thứ 4, 10:00",
         "is_completed": False, "is_urgent": False},
        {"title": "Kiểm định giả thuyết", "subtitle": "Thứ 6, 14:00",
         "is_completed": False, "is_urgent": False},
    ],
    "classes": [
        {"title": "Lab thực hành Python", "subtitle": "Thứ 3, 13:00 · Phòng B204",
         "is_completed": False, "is_urgent": False},
        {"title": "Thảo luận nhóm — BBB", "subtitle": "Thứ 5, 09:00 · Online",
         "is_completed": False, "is_urgent": False},
    ],
    "assignments": [
        {"title": "TMA-02 — Phân tích hồi quy", "subtitle": "Nộp trước Thứ 6",
         "is_completed": False, "is_urgent": True},
        {"title": "CMA-01 — Quiz chương 3", "subtitle": "Nộp trước Thứ 7",
         "is_completed": False, "is_urgent": False},
    ],
    "exams": [],
}

MOCK_NEXT_COURSES = [
    {
        "code": "BBB-ADV",
        "title": "Chuyên sâu BBB — Bài tập thực hành",
        "prerequisites": [],
        "description": "Luyện tập chuyên sâu với bộ dữ liệu thực cho môn BBB đang học",
    },
    {
        "code": "CCC",
        "title": "Thống kê ứng dụng nâng cao",
        "prerequisites": ["Thống kê cơ bản", "Đại số tuyến tính"],
        "description": "Phân tích dữ liệu nâng cao với R và Python",
    },
    {
        "code": "DDD",
        "title": "Học máy cơ bản",
        "prerequisites": ["Hồi quy tuyến tính", "Đại số tuyến tính"],
        "description": "Giới thiệu machine learning với scikit-learn",
    },
    {
        "code": "EEE",
        "title": "Phân tích dữ liệu thực hành",
        "prerequisites": ["Thống kê cơ bản"],
        "description": "Dự án thực tế với pandas, matplotlib, seaborn",
    },
]

MOCK_MILESTONES = [
    {
        "_id": "ms_001",
        "student_id": 28400,
        "id_assessment": 1753,
        "module": "BBB",
        "title": "TMA-02 — Phân tích hồi quy",
        "milestones": [
            {"id": "m1", "title": "Đọc đề bài & tài liệu tham khảo", "status": "done", "due_offset_days": -14},
            {"id": "m2", "title": "Phân tích dữ liệu ban đầu", "status": "in_progress", "due_offset_days": -7},
            {"id": "m3", "title": "Viết báo cáo nháp", "status": "pending", "due_offset_days": -3},
            {"id": "m4", "title": "Nộp bài chính thức", "status": "pending", "due_offset_days": 0},
        ],
        "created_at": "2025-01-15T08:00:00",
    }
]

MOCK_KNOWLEDGE_STATES = {
    "student_id": 28400,
    "states": {
        "Thống kê cơ bản": {
            "mastery": 0.35, "last_updated": "2025-01-10", "evidence_count": 2
        },
        "Đại số tuyến tính": {
            "mastery": 0.28, "last_updated": "2025-01-12", "evidence_count": 1
        },
        "Hồi quy tuyến tính": {
            "mastery": 0.55, "last_updated": "2025-01-18", "evidence_count": 3
        },
        "Kiểm định giả thuyết": {
            "mastery": 0.42, "last_updated": "2025-01-20", "evidence_count": 2
        },
    },
}

MOCK_NOTIFICATIONS = [
    {
        "_id": "notif_001",
        "student_id": 28400,
        "type": "deadline_warning",
        "payload": {
            "title": "TMA-02 — BBB sắp đến hạn",
            "body": "Còn 3 ngày (đến ngày 47). Hãy bắt đầu sớm.",
        },
        "action_options": [
            {
                "label": "Lên kế hoạch",
                "action": "open_chat",
                "payload": {"message": "Giúp tôi lên kế hoạch hoàn thành TMA-02 môn BBB"},
            },
            {"label": "Nhắc lại sau", "action": "snooze", "payload": {}},
        ],
        "read": False,
        "created_at": (datetime.utcnow() - timedelta(hours=2)).isoformat(),
    },
    {
        "_id": "notif_002",
        "student_id": 28400,
        "type": "reminder",
        "payload": {
            "title": "Ôn tập hôm nay",
            "body": "Bạn có 4 thẻ flashcard cần ôn tập theo lịch SM-2.",
        },
        "action_options": [
            {
                "label": "Hỏi trợ lý",
                "action": "open_chat",
                "payload": {"message": "Hôm nay tôi nên ôn tập gì?"},
            },
        ],
        "read": False,
        "created_at": (datetime.utcnow() - timedelta(hours=5)).isoformat(),
    },
]

MOCK_STUDY_PLAN = [
    {"subject": "Ôn tập Tuần 6 — BBB", "type": "review",
     "duration": 45, "day": "Thứ 2", "time": "19:00", "sm2_interval": 3},
    {"subject": "Đọc tài liệu Tuần 7", "type": "new",
     "duration": 60, "day": "Thứ 3", "time": "20:00", "sm2_interval": None},
    {"subject": "Luyện tập TMA-02", "type": "practice",
     "duration": 90, "day": "Thứ 4", "time": "19:30", "sm2_interval": None},
    {"subject": "Flashcard Tuần 5–6", "type": "spaced_rep",
     "duration": 20, "day": "Thứ 5", "time": "08:00", "sm2_interval": 7},
    {"subject": "Hoàn thiện TMA-02", "type": "assignment",
     "duration": 120, "day": "Thứ 6", "time": "14:00", "sm2_interval": None},
]

MOCK_RESOURCES = [
    {"title": "Slide Tuần 7 — Kiểm định giả thuyết", "module": "BBB",
     "type": "slide", "url": "#", "bookmarked": True},
    {"title": "Tài liệu đọc thêm — Hồi quy tuyến tính", "module": "BBB",
     "type": "document", "url": "#", "bookmarked": False},
    {"title": "Video hướng dẫn Python pandas", "module": "BBB",
     "type": "video", "url": "#", "bookmarked": True},
    {"title": "Quiz tự luyện chương 3", "module": "BBB",
     "type": "quiz", "url": "#", "bookmarked": False},
]
