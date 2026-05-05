import os, subprocess, sys
from google import genai
from rich.console import Console

c = Console()
k = os.environ.get('GOOGLE_API_KEY')

if not k:
    c.print("[bold red]Error:[/bold red] GOOGLE_API_KEY not found.")
    sys.exit(1)

client = genai.Client(api_key=k, http_options={'api_version': 'v1'})

def ask(prompt):
    # Line 25 Fix: Combined into a single-line chain to prevent SyntaxErrors
    response = client.models.generate_content(model='gemini-1.5-flash', contents=prompt).text
    return response.replace('```python', '').replace('```bash', '').replace('```', '').strip()

def run_exec(intent):
    command = ask(f'Convert to 1-line bash: {intent}')
    for attempt in range(4):
        c.print(f'[bold blue]run >>[/bold blue] {command}')
        process = subprocess.run(command, shell=True, capture_output=True, text=True)
        if process.returncode == 0:
            c.print('[bold green]DONE[/bold green]')
            if process.stdout: print(process.stdout.strip())
            break
        else:
            c.print(f'[bold red]FAIL {attempt + 1}/4[/bold red]')
            command = ask(f"Fix this bash: {command}. Error: {process.stderr}")

if __name__ == '__main__':
    if len(sys.argv) > 1:
        run_exec(' '.join(sys.argv[1:]))
    else:
        while True:
            try:
                user_input = input('sai= ')
                if user_input.lower() in ['exit', 'quit']: break
                if user_input.strip(): run_exec(user_input)
            except KeyboardInterrupt: break
