import requests
import json
import os
import time

API_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFmaG1ubHZnd2V6bnpjc29panlyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg4MDYyMzQsImV4cCI6MjA4NDM4MjIzNH0.mNJAoc-uJVilLr03PT3luXsekfwJ4sICOIsOIRQu-N0"
AUTH_TOKEN = "Bearer eyJhbGciOiJFUzI1NiIsImtpZCI6ImUwNTFjYmQ0LTMzOTgtNGQ0Yy05NDc0LTUzNjIwMTBmN2Q5YiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL3FmaG1ubHZnd2V6bnpjc29panlyLnN1cGFiYXNlLmNvL2F1dGgvdjEiLCJzdWIiOiIwMjNjOGE1ZC03YTI0LTQwMGItODQ2ZS03YzQ4ZjE1ZmNmNjQiLCJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNzg1MTM0MDY1LCJpYXQiOjE3ODUxMzA0NjUsImVtYWlsIjoiYmFjaHN5bnVpQGdtYWlsLmNvbSIsInBob25lIjoiIiwiYXBwX21ldGFkYXRhIjp7InByb3ZpZGVyIjoiZ29vZ2xlIiwicHJvdmlkZXJzIjpbImdvb2dsZSJdfSwidXNlcl9tZXRhZGF0YSI6eyJhdmF0YXJfdXJsIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUNnOG9jSkVaQ2pZNVBMb1hPcFVLdXVFVFhDOEFFeW9nV3M2ODcyQm5zeVNOUFo3SkJpSkx3PXM5Ni1jIiwiZW1haWwiOiJiYWNoc3ludWlAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImZ1bGxfbmFtZSI6IkLhuqFjaCBT4bu5IE7DumkiLCJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJuYW1lIjoiQuG6oWNoIFPhu7kgTsO6aSIsInBob25lX3ZlcmlmaWVkIjpmYWxzZSwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FDZzhvY0pFWkNqWTVQTG9YT3BVS3V1RVRYQzhBRXlvZ1dzNjg3MkJuc3lTTlBaN0pCaUpMdz1zOTYtYyIsInByb3ZpZGVyX2lkIjoiMTA5NjYwMTMyMzM0MzY3NzYyNDM2Iiwic3ViIjoiMTA5NjYwMTMyMzM0MzY3NzYyNDM2In0sInJvbGUiOiJhdXRoZW50aWNhdGVkIiwiYWFsIjoiYWFsMSIsImFtciI6W3sibWV0aG9kIjoib2F1dGgiLCJ0aW1lc3RhbXAiOjE3ODE4NDQzMDR9XSwic2Vzc2lvbl9pZCI6ImFhZTU4ODZiLTMwZTAtNGQ1Yy1iNzA4LTU5YzRhYjJiZDVhNCIsImlzX2Fub255bW91cyI6ZmFsc2V9.02MEgsfZ1rmlsMKCM0_iyiy_Nqr3ZM4jDL0vE1ZSjzN2KqbD499Hmh7jFaoCQgiDWQOvQq4fJDz1foPRzdY-Mw"

HEADERS = {
    "accept": "*/*",
    "accept-language": "vi,en-US;q=0.9,en;q=0.8",
    "apikey": API_KEY,
    "authorization": AUTH_TOKEN,
    "content-type": "application/json",
    "origin": "https://dautoeic.com",
    "referer": "https://dautoeic.com/",
    "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36",
    "x-client-info": "supabase-js-web/2.90.1"
}

def get_test_sets():
    url = "https://qfhmnlvgweznzcsoijyr.supabase.co/rest/v1/mock_test_sets?select=*&is_hidden=eq.false&order=order_index.asc"
    res = requests.get(url, headers=HEADERS)
    if res.status_code == 200:
        return res.json()
    return []

def get_mock_tests():
    url = "https://qfhmnlvgweznzcsoijyr.supabase.co/rest/v1/mock_tests?select=*&is_hidden=eq.false&order=order_index.asc"
    res = requests.get(url, headers=HEADERS)
    if res.status_code == 200:
        return res.json()
    return []

def get_passages_for_test(test_id):
    # Try REST first for full passage contents
    url = "https://qfhmnlvgweznzcsoijyr.supabase.co/rest/v1/mock_test_passages"
    params = {"select": "*", "test_id": f"eq.{test_id}"}
    res = requests.get(url, headers=HEADERS, params=params)
    if res.status_code == 200:
        return res.json()
    # Fallback to RPC
    rpc_url = "https://qfhmnlvgweznzcsoijyr.supabase.co/rest/v1/rpc/get_mock_passages_by_test_parts"
    res_rpc = requests.post(rpc_url, headers=HEADERS, json={"p_test_id": test_id, "p_parts": None})
    if res_rpc.status_code == 200:
        return res_rpc.json()
    return []

def get_questions_for_test(test_id):
    url = "https://qfhmnlvgweznzcsoijyr.supabase.co/rest/v1/mock_test_questions"
    params = {"select": "*", "test_id": f"eq.{test_id}", "order": "question_number.asc"}
    res = requests.get(url, headers=HEADERS, params=params)
    if res.status_code == 200 and len(res.json()) > 0:
        return res.json()
    
    rpc_url = "https://qfhmnlvgweznzcsoijyr.supabase.co/rest/v1/rpc/get_mock_questions_by_test_parts"
    res_rpc = requests.post(rpc_url, headers=HEADERS, json={"p_test_id": test_id, "p_parts": None})
    if res_rpc.status_code == 200:
        return res_rpc.json()
    return []

def main():
    print("🚀 BẮT ĐẦU KÉO 10 ĐỀ THI KÈM TRỌN BỘ ĐOẠN VĂN (PASSAGES) & AUDIO HỘI THOẠI...")
    print("-" * 60)
    
    test_sets = get_test_sets()
    all_tests = get_mock_tests()
    
    if not all_tests:
        print("❌ Không lấy được danh sách đề thi. Token có thể bị lỗi.")
        return
        
    selected_tests = all_tests[:10]
    if test_sets:
        first_set_id = test_sets[0].get('id')
        tests_in_first_set = [t for t in all_tests if t.get('test_set_id') == first_set_id or t.get('set_id') == first_set_id]
        if len(tests_in_first_set) >= 1:
            selected_tests = tests_in_first_set[:10]
            
    output_dir = os.path.join(os.path.dirname(__file__), "downloaded_exams")
    os.makedirs(output_dir, exist_ok=True)
    
    sql_statements = []
    sql_statements.append("-- Script import 10 đề thi chuẩn TOEIC kèm đầy đủ Passage và Audio chung\n")
    sql_statements.append("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";\n")
    
    success_count = 0
    for idx, t in enumerate(selected_tests, 1):
        test_id = t.get('id')
        title = t.get('title', f"TOEIC Practice Test {idx}")
        code = f"toeic-test-{idx:02d}"
        description = f"Bộ đề thi TOEIC thực tế - {title} - Trọn gói Audio hội thoại Part 3-4 và Bài đọc Part 6-7 chuẩn ETS"
        
        print(f"⌛ [{idx}/10] Đang bóc tách đề: {title}...")
        passages = get_passages_for_test(test_id)
        questions = get_questions_for_test(test_id)
        
        if not questions:
            print(f"   ⚠️ Đề {title} trống hoặc khóa, bỏ qua...")
            continue
            
        # Gắn passage vào question
        passages_by_id = {p['id']: p for p in passages if 'id' in p}
        for q in questions:
            p_id = q.get('passage_id')
            if p_id and p_id in passages_by_id:
                p = passages_by_id[p_id]
                q['passage'] = p
                # Bổ sung audio_url/image_url/passage_text cho tiện truy xuất
                if not q.get('audio_url') and p.get('audio_url'):
                    q['audio_url'] = p['audio_url']
                if not q.get('image_url') and p.get('image_url'):
                    q['image_url'] = p['image_url']
                if not q.get('passage_text') and p.get('passage_text'):
                    q['passage_text'] = p['passage_text']
                    
        print(f"   ✅ Hoàn thành: {len(questions)} câu hỏi + {len(passages)} đoạn văn/audio chung!")
        
        json_filename = os.path.join(output_dir, f"{code}.json")
        with open(json_filename, 'w', encoding='utf-8') as f:
            json.dump(questions, f, ensure_ascii=False, indent=2)
            
        questions_json = json.dumps(questions, ensure_ascii=False)
        
        sql = f"""
INSERT INTO exams (code, title, description, duration_minutes, status, questions, created_at, updated_at)
VALUES (
    '{code}',
    '{title}',
    '{description}',
    120,
    'PUBLISHED',
    $JSON${questions_json}$JSON$::jsonb,
    NOW(),
    NOW()
)
ON CONFLICT (code) DO UPDATE SET 
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    questions = EXCLUDED.questions,
    updated_at = NOW();
"""
        sql_statements.append(sql)
        success_count += 1
        time.sleep(0.3)
        
    if success_count > 0:
        sql_file_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), "import_10_tests.sql")
        with open(sql_file_path, 'w', encoding='utf-8') as f:
            f.write("\n".join(sql_statements))
            
        print("-" * 60)
        print(f"🏆 THÀNH CÔNG RỰC RỠ! Đã chuẩn hóa {success_count} đề thi cùng toàn bộ Passage.")
        print(f"📂 File SQL được cập nhật tại: {sql_file_path}")
        
if __name__ == "__main__":
    main()
