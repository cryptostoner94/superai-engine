import os, subprocess, sys
from google import genai
from rich.console import Console

c = Console()
k = os.environ.get('GOOGLE_API_KEY')
if not k:
    sys.exit("Error: GOOGLE_API_KEY not found.")

client = genai.Client(api_key=k, http_options={'api_version': 'v1'})

def ask(p):
    r = client.models.generate_content(model='gemini-1.5-flash', contents=p).text
    for s in ['```python', '
```bash', '```']: r = r.replace(s, '')
    return r.strip()

def run_exec(intent):
    cmd = ask(f'Convert to 1-line bash command: {intent}')
    for _ in range(4):
        c.print(f'[bold blue]run >>[/bold blue] {cmd}')
        p = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        if p.returncode == 0:
            c.print('[bold green]DONE[/bold green]')
            print(p.stdout)
            break
        c.print(f'[bold red]FAILED:[/bold red] {p.stderr}')
        cmd = ask(f'Fix bash command: {cmd}\nError: {p.stderr}\nONLY code.')

if __name__ == '__main__':
    if len(sys.argv) > 1:
        run_exec(' '.join(sys.argv[1:]))
    else:
        while True:
            try:
                i = input('SuperAI= ')
                if i.lower() in ['exit', 'quit']: break
                run_exec(i)
            except KeyboardInterrupt: break
