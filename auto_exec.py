import os, subprocess, sys
from google import genai
from rich.console import Console

c = Console()
k = os.environ.get('GOOGLE_API_KEY')

if not k:
    c.print("[bold red]Error:[/bold red] GOOGLE_API_KEY not found in environment.")
    sys.exit(1)

client = genai.Client(api_key=k, http_options={'api_version': 'v1'})

def ask(prompt):
    response = client.models.generate_content(model='gemini-1.5-flash', contents=prompt).text
    return response.replace('```python', '').replace('
```bash', '').replace('```', '').strip()

def run_exec(intent):
    command = ask(f'Convert this intent to a 1-line bash command. ONLY output the command: {intent}')
    for attempt in range(4):
        c.print(f'[bold blue]run >>[/bold blue] {command}')
        process = subprocess.run(command, shell=True, capture_output=True, text=True)
        if process.returncode == 0:
            c.print('[bold green]DONE[/bold green]')
            if process.stdout: print(process.stdout.strip())
            break
        else:
            c.print(f'[bold red]FAIL {attempt + 1}/4[/bold red]')
            fix_prompt = f"Command '{command}' failed with error: {process.stderr}. Provide a 1-line bash fix. ONLY code."
            command = ask(fix_prompt)

if __name__ == '__main__':
    if len(sys.argv) > 1:
        run_exec(' '.join(sys.argv[1:]))
    else:
        c.print("[bold cyan]SuperAI Space Active[/bold cyan] (Type 'exit' to quit)")
        while True:
            try:
                user_input = input('sai= ')
                if user_input.lower() in ['exit', 'quit']: break
                if user_input.strip(): run_exec(user_input)
            except KeyboardInterrupt: break
