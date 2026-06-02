from fastapi import APIRouter
from pydantic import BaseModel

from db.mongodb import get_db
from db.mock_data import MOCK_MILESTONES

router = APIRouter()


class MilestoneUpdateRequest(BaseModel):
    student_id: int
    id_assessment: int
    milestone_id: str
    status: str


@router.get("/{id_assessment}/milestones")
async def get_milestones(id_assessment: int, student_id: int):
    """Return milestone list for an assessment. Empty list if none generated yet."""
    db = get_db()
    if db is not None:
        doc = await db.assignment_milestones.find_one(
            {"student_id": student_id, "id_assessment": id_assessment}
        )
        if doc:
            doc["_id"] = str(doc["_id"])
            return doc
        return {"id_assessment": id_assessment, "milestones": []}
    # Mock fallback
    for m in MOCK_MILESTONES:
        if m["id_assessment"] == id_assessment and m["student_id"] == student_id:
            return {k: v for k, v in m.items() if k != "_id"}
    return {"id_assessment": id_assessment, "milestones": []}


@router.post("/{id_assessment}/breakdown")
async def trigger_breakdown(id_assessment: int, student_id: int):
    """Trigger milestone generation. Returns existing milestones if already done."""
    db = get_db()
    # Return existing if already generated
    if db is not None:
        existing = await db.assignment_milestones.find_one(
            {"student_id": student_id, "id_assessment": id_assessment}
        )
        if existing:
            existing["_id"] = str(existing["_id"])
            return existing
    else:
        for m in MOCK_MILESTONES:
            if m["id_assessment"] == id_assessment and m["student_id"] == student_id:
                return {k: v for k, v in m.items() if k != "_id"}

    # Generate via agent
    from agent.assignment_breakdown import run_breakdown
    await run_breakdown(student_id, id_assessment)

    # Return newly created milestones
    if db is not None:
        doc = await db.assignment_milestones.find_one(
            {"student_id": student_id, "id_assessment": id_assessment}
        )
        if doc:
            doc["_id"] = str(doc["_id"])
            return doc
    return {"id_assessment": id_assessment, "milestones": [], "status": "processing"}


@router.patch("/milestone/status")
async def update_milestone_status(body: MilestoneUpdateRequest):
    """Update a single milestone status."""
    db = get_db()
    if db is None:
        return {"ok": True, "mock": True}
    await db.assignment_milestones.update_one(
        {
            "student_id": body.student_id,
            "id_assessment": body.id_assessment,
            "milestones.id": body.milestone_id,
        },
        {"$set": {"milestones.$.status": body.status}},
    )
    return {"ok": True}
