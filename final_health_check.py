import requests

GW = "https://aerotoeic-api-gateway.onrender.com"

results = {
    "GET /api/exams (danh sach de thi)": requests.get(f"{GW}/api/exams", timeout=15),
    "GET /api/exams/toeic-test-01 (200 cau hoi)": requests.get(f"{GW}/api/exams/toeic-test-01", timeout=15),
    "GET /api/exams/toeic-test-05": requests.get(f"{GW}/api/exams/toeic-test-05", timeout=15),
    "GET /api/exams/toeic-test-10": requests.get(f"{GW}/api/exams/toeic-test-10", timeout=15),
    "GET /api/exams/toeic-test-11 (khong co data)": requests.get(f"{GW}/api/exams/toeic-test-11", timeout=15),
    "GET /health": requests.get(f"{GW}/health", timeout=10),
}

print("=== KIEM TRA TOAN BO API ===\n")
all_ok = True
for label, r in results.items():
    status = "OK" if r.ok else "FAIL"
    data = r.json()
    detail = ""
    if "exams" in data:
        detail = f"-> {len(data['exams'])} exams"
    elif "exam" in data and "questions" in data["exam"]:
        detail = f"-> {len(data['exam']['questions'])} questions"
    elif "error" in data:
        detail = f"-> ERROR: {data['error']}"
    elif "status" in data:
        detail = f"-> {data['status']}"
    
    icon = "V" if r.ok else "X"
    print(f"[{icon}] {r.status_code} {label} {detail}")
    if not r.ok and "khong co data" not in label:
        all_ok = False

print()
if all_ok:
    print("TAT CA API HOAT DONG CHINH XAC! Web co the dung binh thuong.")
else:
    print("CO MOT SO API CHUA HOAT DONG!")
