import requests
import json
import os

def download_dautoeic_full_test():
    print("Đang kết nối vào hệ thống API của dautoeic.com (qua Supabase)...")
    
    url = 'https://qfhmnlvgweznzcsoijyr.supabase.co/rest/v1/mock_test_questions'
    
    # Ở đây chúng ta filter bằng `test_id` thay vì `id` của 1 câu đơn lẻ
    params = {
        'select': 'id,test_id,part,section,question_number,passage_id,audio_url,image_url,question_text,option_a,option_b,option_c,option_d,correct_answer,difficulty_level,order_index,prefer_ai_explanation,passage_text,dich_nghia,explanation_en,dich_nghia_dap_an,tu_vung,explanation_vi',
        'test_id': 'eq.ad780150-f675-42b9-8ced-246862b0d0a8'
    }
    
    # Token xác thực do bạn cung cấp (Bearer token)
    headers = {
        'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFmaG1ubHZnd2V6bnpjc29panlyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg4MDYyMzQsImV4cCI6MjA4NDM4MjIzNH0.mNJAoc-uJVilLr03PT3luXsekfwJ4sICOIsOIRQu-N0',
        'authorization': 'Bearer eyJhbGciOiJFUzI1NiIsImtpZCI6ImUwNTFjYmQ0LTMzOTgtNGQ0Yy05NDc0LTUzNjIwMTBmN2Q5YiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL3FmaG1ubHZnd2V6bnpjc29panlyLnN1cGFiYXNlLmNvL2F1dGgvdjEiLCJzdWIiOiIwMjNjOGE1ZC03YTI0LTQwMGItODQ2ZS03YzQ4ZjE1ZmNmNjQiLCJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNzg0NDc0ODQxLCJpYXQiOjE3ODQ0NzEyNDEsImVtYWlsIjoiYmFjaHN5bnVpQGdtYWlsLmNvbSIsInBob25lIjoiIiwiYXBwX21ldGFkYXRhIjp7InByb3ZpZGVyIjoiZ29vZ2xlIiwicHJvdmlkZXJzIjpbImdvb2dsZSJdfSwidXNlcl9tZXRhZGF0YSI6eyJhdmF0YXJfdXJsIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUNnOG9jSkVaQ2pZNVBMb1hPcFVLdXVFVFhDOEFFeW9nV3M2ODcyQm5zeVNOUFo3SkJpSkx3PXM5Ni1jIiwiZW1haWwiOiJiYWNoc3ludWlAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImZ1bGxfbmFtZSI6IkLhuqFjaCBT4bu5IE7DumkiLCJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJuYW1lIjoiQuG6oWNoIFPhu7kgTsO6aSIsInBob25lX3ZlcmlmaWVkIjpmYWxzZSwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FDZzhvY0pFWkNqWTVQTG9YT3BVS3V1RVRYQzhBRXlvZ1dzNjg3MkJuc3lTTlBaN0pCaUpMdz1zOTYtYyIsInByb3ZpZGVyX2lkIjoiMTA5NjYwMTMyMzM0MzY3NzYyNDM2Iiwic3ViIjoiMTA5NjYwMTMyMzM0MzY3NzYyNDM2In0sInJvbGUiOiJhdXRoZW50aWNhdGVkIiwiYWFsIjoiYWFsMSIsImFtciI6W3sibWV0aG9kIjoib2F1dGgiLCJ0aW1lc3RhbXAiOjE3ODE4NDQzMDR9XSwic2Vzc2lvbl9pZCI6ImFhZTU4ODZiLTMwZTAtNGQ1Yy1iNzA4LTU5YzRhYjJiZDVhNCIsImlzX2Fub255bW91cyI6ZmFsc2V9.jmbO-eenhwue6YASmZK9Pwo587meOQl7udfFPy44dDSqQjSrFftB5zSP8N_zWzWTqZEJQLdIG3QTx2YLsk8S_Q',
        'accept': 'application/json'
    }

    response = requests.get(url, params=params, headers=headers)
    
    if response.status_code == 200:
        data = response.json()
        output_file = 'dautoeic_real_test.json'
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            
        print(f"XUẤT SẮC! Đã lấy thành công {len(data)} câu hỏi của toàn bộ đề thi.")
        print(f"Dữ liệu được lưu tại: {os.path.abspath(output_file)}")
    else:
        print('Lỗi:', response.status_code, response.text)

if __name__ == "__main__":
    download_dautoeic_full_test()
