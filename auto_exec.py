import os, subprocess, sys
from google import genai

k = os.environ.get('GOOGLE_API_KEY')
# CRITICAL: Force api_version='v1' to resolve the 404 Not Found error
client = genai.Client(api_key=k, http_options={'api_version': 'v1'})

def ask(p):
    try:
        res = client.models.generate_content(model='gemini-1.5-flash', contents=p)
        return res.text.replace('```python','').replace('```bash','').replace('```','').strip()
    except Exception as e:
        return f"echo 'API Error: {str(e)}'"

def run():
    # JOIN ALL ARGS: Allows 'sai do the thing' without quotes
    intent = ' '.join(sys.argv[1:])
    if not intent: return

    prompt = f"Convert to 1-line bash. Verbatim filenames only. ONLY code: {intent}"
    cmd = ask(prompt)
    
    for i in range(4):
        print(f"run >> {cmd}")
        p = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        if p.returncode == 0:
            if p.stdout: print(p.stdout.strip())
            print("DONE")
            break
        else:
            print(f"FAIL {i+1}/4")
            cmd = ask(f"Fix this bash: {cmd}. Error: {p.stderr}")

if __name__ == "__main__":
    run()
