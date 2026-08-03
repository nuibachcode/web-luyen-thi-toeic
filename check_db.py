import psycopg2

DB_URL = "postgresql://toeic_user:0FcKcaH548fGZFvD66F68KuGFdUyKCWg@dpg-d9ndhsdaeets73bn2jm0-a.oregon-postgres.render.com/toeic_db_qwyv?sslmode=require"

conn = psycopg2.connect(DB_URL)
cur = conn.cursor()
cur.execute("SELECT table_name FROM information_schema.tables WHERE table_schema='public' ORDER BY table_name")
rows = cur.fetchall()
print("Tables:", [r[0] for r in rows])
cur.close()
conn.close()
