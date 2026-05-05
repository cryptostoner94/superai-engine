import os, subprocess, sys
from google import genai

k = os.environ.get('GOOGLE_API_KEY')
client = genai.Client(api_key=k)

def ask(p):
    # LINE 25 FIXED: Single line replacement to prevent SyntaxError
    r = client.models.generate_content(model='gemini-1.5-flash', contents=p).text
    return r.replace('```python','').replace('```bash','').replace('```','').strip()

def run_exec():
    # NO QUOTES REQUIRED: Joins all args into one intent
    intent = ' '.join(sys.argv[1:])
    if not intent: return
    
    cmd = ask(f"Convert to 1-line bash. ONLY code: {intent}")
    for i in range(4):
        print(f"run >> {cmd}")
        p = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        if p.returncode == 0:
            if p.stdout: print(p.stdout.strip())
            print("DONE")
            break
        else:
            cmd = ask(f"Fix this bash: {cmd}. Error: {p.stderr}")

if __name__ == "__main__":
    run_exec()
