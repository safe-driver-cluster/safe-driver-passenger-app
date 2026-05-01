# Reward Points System - Visual Guide

## 📊 Points Flow Diagram

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━════════════════════════════════┓
┃                        REWARD POINTS SYSTEM                              ║
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━════════════════════════════════┛

User Profile
    ↓
    ├─────────────────────────────┐
    │  REWARD POINTS WIDGET       │
    │  ┌─────────────────────┐    │
    │  │    45/100 Points    │    │  ← Shows current balance
    │  │    45% Progress     │    │  ← Visual progress circle
    │  └─────────────────────┘    │
    │                              │
    │  How to Earn:                │
    │  📝 Feedback: +1 pt         │
    │  ✓ Approved: +3 pts total   │
    │  ⚠️ Fake: -1 pt             │
    └─────────────────────────────┘

Submit Feedback
    ↓
    ↓─────────────────────────────────────┐
    │                                       │
    ├──→ Feedback Page                    │
    │     • Select Category (Driver/Bus)   │
    │     • Give Rating (1-5 stars)       │
    │     • Write Feedback (min 5 chars)  │
    │                                       │
    ├──→ Anti-Fraud Check               │
    │     ✓ Length check (min 5 chars)    │
    │     ✓ Not empty                     │
    │     ✓ Not just numbers              │
    │                                       │
    ├──→ Submit to Firestore             │
    │     • Save feedback data             │
    │     • Set status: "submitted"       │
    │                                       │
    └──→ Award Points                    │
          • Get user ID                    │
          • Add +1 point to account       │
          • Log transaction               │
          • Show success message         │
               ✅ Thank you! +1 Point!   │
    ↓
    Points Updated in Profile Widget
```

## 🎯 Points Earning Timeline

```
                     User Journey
                            
DAY 1: User submits first feedback
┌────────────┐
│ Initial +1 │
└────────────┘
  Total: 1 point

│
│ [Days 2-10: User submits 9 more feedbacks]
│
└→ DAY 11: 10 points earned
   ┌────────────┐
   │ Total: 10  │
   └────────────┘

│
│ [Admin reviews submissions]
│

DAY 15: Admin approves 5 feedbacks
┌────────────┐
│ +2 bonus   │  (for each)
│ per item   │
└────────────┘
  +10 bonus points
  │
  └→ Total: 20 points
     (10 initial + 10 bonus)

DAY 20: Admin rejects 2 as fake
┌────────────┐
│ -1 penalty │  (for each)
│ per item   │
└────────────┘
  -2 penalty
  │
  └→ Total: 18 points
     (was 20, -2 penalty)
```

## 🚀 Reward Levels / Goals

```
LEVEL 1: BEGINNER REVIEWER
Points: 0-25
┌──────────┐
│   25%    │ ████░░░░░░
└──────────┘
Unlocked by: Submitting 25 feedbacks

LEVEL 2: ACTIVE CONTRIBUTOR  
Points: 26-50
┌──────────┐
│   50%    │ ████████░░
└──────────┘
Unlocked by: 50 points earned

LEVEL 3: TRUSTED REVIEWER
Points: 51-75
┌──────────┐
│   75%    │ ██████████
└──────────┘
Unlocked by: 75 points earned

LEVEL 4: COMMUNITY CHAMPION
Points: 76-100
┌──────────┐
│  100%    │ ██████████
└──────────┘
Unlocked by: 100 points earned
Special: Eligible for rewards/discounts
```

## 🛡️ Anti-Fraud Detection Flowchart

```
Feedback Submitted
    ↓
    ├─→ Length Check
    │   "a b c" ✗ (too short)
    │   "This feedback is good" ✓
    │
    ├─→ Empty Check  
    │   "     " ✗ (empty)
    │   "good" ✓
    │
    ├─→ Number Check
    │   "1 2 3 4 5" ✗ (only numbers)
    │   "Item 5 stars good" ✓
    │
    └─→ Result
        ✓ Pass: Award +1 point
        ✗ Fail: Flag for review
             → Manual admin review
             → Potential -1 penalty
```

## 📱 UI Component Layout

```
USER PROFILE PAGE
┌─────────────────────────────────────────┐
│  👤 User Profile                        │
├─────────────────────────────────────────┤
│                                          │
│  [User Avatar & Info]                   │
│                                          │
│  ┌─ QUICK ACTIONS ──────────────────┐  │
│  │ [Edit Profile] [Trip History]    │  │
│  │ [Feedback] [Support]             │  │
│  └──────────────────────────────────┘  │
│                                          │
│  ┌─ 🎁 REWARD POINTS ────────────────┐  │
│  │                                    │  │
│  │         ◯  45                      │  │
│  │        Points                      │  │
│  │   Goal: 100 | 45%                │  │
│  │                                    │  │
│  │   📝 Submit Feedback    +1 point   │  │
│  │   ✓ Feedback Approved  +3 points   │  │
│  │   ⚠️  Fake Feedback    -1 point    │  │
│  │                                    │  │
│  └──────────────────────────────────┘  │
│                                          │
│  ┌─ SETTINGS ────────────────────────┐  │
│  │ [Notifications] [Privacy]         │  │
│  │ [About] [Sign Out]                │  │
│  └──────────────────────────────────┘  │
│                                          │
└─────────────────────────────────────────┘
```

## 💾 Firestore Data Structure

```
/passenger_details/{userId}
├── id: "user123"
├── firstName: "John"
├── email: "john@example.com"
├── stats: {
│   ├── totalTrips: 47
│   ├── todayTrips: 2
│   ├── carbonSaved: 125.5
│   ├── pointsEarned: 45  ← POINTS TRACKED HERE
│   └── safetyScore: 98.0
├── createdAt: 2025-01-15
└── updatedAt: 2026-03-15

/feedback/{feedbackId}
├── id: "feedback123"
├── userId: "user123"
├── category: "driver"
├── type: "positive"
├── rating: { overall: 5 }
├── description: "Great driver, very professional"
├── status: "submitted" → "resolved" → awards bonus
├── priority: "medium"
├── timestamp: 2026-03-15T10:30:00Z
└── metadata: {...}

/point_transactions/{transactionId}
├── userId: "user123"
├── delta: 1  (positive or negative)
├── newBalance: 45
├── reason: "Feedback submission - driver"
└── timestamp: 2026-03-15T10:30:00Z
```

## 🔄 Status Transition Impact

```
FEEDBACK STATUS JOURNEY & POINT IMPACT

SUBMITTED ─→ [+1 point awarded at submission]
    │
    ├─→ RECEIVED
    │      │
    │      └─→ IN_REVIEW
    │             │
    │             ├─→ RESOLVED ─→ [+2 bonus awarded]
    │             │               └─ Total: +3
    │             │
    │             ├─→ RESPONDED
    │             │     │
    │             │     └─→ CLOSED [+2 bonus awarded]
    │             │           └─ Total: +3
    │             │
    │             └─→ ESCALATED ─→ [-1 penalty deducted]
    │                              └─ Total: 0
    │
    └─→ REJECTED ─→ [-1 penalty deducted MANUALLY]
                     └─ Total: 0
```

## 📈 Example Point Progression

```
User: Sarah
Start Date: March 1, 2026

Week 1:
  ├─ Mar 2: Submit feedback (Bus) → +1 = 1 pt
  ├─ Mar 3: Submit feedback (Driver) → +1 = 2 pts
  ├─ Mar 5: Submit feedback (Route) → +1 = 3 pts
  └─ Status: 3 points

Week 2:
  ├─ Mar 9: Submit feedback (Bus) → +1 = 4 pts
  ├─ Mar 10: Admin approves Mar 2 → +2 = 6 pts
  ├─ Mar 11: Admin approves Mar 3 → +2 = 8 pts
  ├─ Mar 12: Submit feedback (Service) → +1 = 9 pts
  └─ Status: 9 points

Week 3:
  ├─ Mar 15: Submit feedback (Driver) → +1 = 10 pts
  ├─ Mar 16: Admin approves Mar 5 → +2 = 12 pts
  ├─ Mar 17: Admin approves Mar 9 → +2 = 14 pts
  ├─ Mar 18: Fake feedback detected → -1 = 13 pts
  └─ Status: 13 points (ready for rewards!)

Progress: 13/100 = 13% [████░░░░░░]
```

## 🎖️ Achievement Badges (Future)

```
🥉 Bronze Reviewer
   Unlock: 25 points
   
🥈 Silver Contributor
   Unlock: 50 points
   
🥇 Gold Champion
   Unlock: 100 points
   
⭐ Elite Member
   Unlock: 250 points (future)
   
🔥 Feedback Streak
   Unlock: 5 consecutive weeks of feedback
```

## 🚨 Error Handling Flow

```
Submit Feedback
    ↓
    ├─→ Validation Error
    │       └─→ Show error message
    │           "Feedback must be at least 5 characters"
    │           ✗ No points awarded
    │
    ├─→ Firestore Save Error
    │       └─→ Show retry option
    │           "Could not save feedback"
    │           ✗ No points awarded
    │
    ├─→ Points Award Error
    │       └─→ Show warning
    │           "Feedback saved! (Points may be delayed)"
    │           ✓ Feedback saved, points will sync
    │
    └─→ Success
            └─→ Show success + point award
                "✅ Thank you! +1 Reward Point"
                ✓ Both saved
```

---

**Visual Guide Created**: March 15, 2026
**For**: Safe Driver Passenger App - Reward Points System
