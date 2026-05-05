import os
import subprocess
import sys
from google import genai
from rich.console import Console

c = Console()
# Retrieve the secret synced by install.sh
k = os.environ.get('GOOGLE_API_KEY')

if not k:
    c.print("[bold red]Error:[/bold red] GOOGLE_API_KEY not found in environment.")
    sys.exit(1)

# Initialize Gemini Client using v1 API for maximum compatibility
client = genai.Client(api_key=k, http_options={'api_version': 'v1'})

def ask(prompt):
    """Sends prompt to Gemini and cleans code block markers."""
    response = client.models.generate_content(
        model='gemini-1.5-flash', 
        contents=prompt
    ).text
    # Clean output so only the raw command remains
    for marker in ['```python', '
```bash', '```']:
        response = response.replace(marker, '')
    return response.strip()

def run_exec(intent):
    """The Autonomous Loop: Translate -> Execute -> Capture Error -> Fix."""
    command = ask(f'Convert the following intent to a 1-line bash command: {intent}')
    
    # Allow up to 4 self-correction attempts
    for attempt in range(4):
        c.print(f'[bold blue]run >>[/bold blue] {command}')
        process = subprocess.run(command, shell=True, capture_output=True, text=True)
        
        if process.returncode == 0:
            c.print('[bold green]DONE[/bold green]')
            if process.stdout:
                print(process.stdout.strip())
            break
        else:
            c.print(f'[bold red]FAILED (Attempt {attempt + 1}/4):[/bold red]')
            c.print(f'[dim]{process.stderr.strip()}[/dim]')
            
            # Send the error back to Gemini for a fix
            fix_prompt = (
                f"The bash command '{command}' failed with error: {process.stderr}\n"
                f"Provide a corrected 1-line bash command. ONLY output the code."
            )
            command = ask(fix_prompt)

if __name__ == '__main__':
    # Mode A: One-off command (e.g., go "create a file")
    if len(sys.argv) > 1:
        run_exec(' '.join(sys.argv[1:]))
    # Mode B: Interactive Space (e.g., typing 'go' enters SuperAI= loop)
    else:
        c.print("[bold cyan]SuperAI Autonomous Space Active[/bold cyan] (Type 'exit' to quit)")
        while True:
            try:
                user_input = input('SuperAI= ')
                if user_input.lower() in ['exit', 'quit', 'q']:
                    break
                if user_input.strip():
                    run_exec(user_input)
            except KeyboardInterrupt:
                break
