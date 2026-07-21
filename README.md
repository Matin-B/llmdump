# LLMDump 🧠

`llmdump` is a simple bash script that crawls your project directory, grabs all the important text/code files (ignoring the garbage like `.git`, `node_modules`, and `__pycache__`), and dumps them into two beautifully formatted files simultaneously:

1. **`codebase_dump.md`**: A Markdown version heavily optimized for **ChatGPT** and **Gemini**.
2. **`codebase_dump.xml`**: An XML version using `<document>` and `CDATA` tags, strictly optimized for **Claude 3**'s attention mechanism.

Feed the output file to your favorite LLM and let it understand your entire project architecture in one go.

## Installation

`llmdump` is a zero-dependency, plug-and-play tool. Choose your operating system below to install or run the script in a single command.

### 🐧 Linux & 🍎 macOS (One-Line Install)

Just run this command in your terminal. It downloads the script, places it securely in `~/.local/bin`, automatically detects whether you are running `bash` or `zsh`, and configures the `llmdump` alias for you.

```bash
curl -sSL https://raw.githubusercontent.com/Matin-B/llmdump/main/install.sh | bash

```

*(Note: Don't forget to run `source ~/.bashrc` or `source ~/.zshrc` after installing, or simply restart your terminal session so the alias takes effect).*

### 🪟 Windows (One-Line Run)

Windows users don't need to manually download or configure paths. Just open **PowerShell** and paste this one-liner to fetch and execute it directly in memory:

```powershell
iex (irm "https://raw.githubusercontent.com/Matin-B/llmdump/main/llmdump.ps1")

```

## 🪄 The Recommended AI Prompt

Once you have your `codebase_dump.md` or `codebase_dump.xml` file, **upload it** to ChatGPT, Claude, or Gemini.

To prevent the AI from hallucinating or generating unsolicited code, use this battle-tested prompt alongside your file upload. It forces the LLM to index your project and wait for your commands:

```text
Act as an Expert Software Architect and Senior Developer. I have attached the complete codebase of my project as a single dump file (structured with Markdown headings or XML tags).

### INSTRUCTIONS FOR INGESTION:
1. READ AND INDEX: Carefully analyze the entire attached codebase. Build an internal mental map of all files, directories, classes, functions, and their interdependencies (e.g., how core modules communicate, overall data flow, and any external integrations).
2. STRICT PASSIVITY: Do NOT rewrite, refactor, critique, or generate any new code in your initial response. Your only task right now is to load the context into your memory.
3. PREPARE FOR DEEP ANALYSIS: In our subsequent conversation, I will ask highly technical, line-by-line questions, request the extraction of specific logic to build independent modules, or ask for refactoring. You must strictly base your answers on the provided codebase.
4. NO HALLUCINATION: If I ask about a module, library, or variable not present in this text dump, you must explicitly state that it is missing from the provided context rather than inventing an answer.

### YOUR RESPONSE FORMAT:
To confirm you have successfully ingested and understood the project, reply ONLY with:
1. A brief, high-level directory/file tree structure based on what you see in the dump.
2. A technical 2-3 sentence summary of the project's primary architecture and data flow.
3. The exact phrase: "Codebase fully ingested and indexed. I am ready for line-by-line analysis, logic extraction, or deep-dive technical questions. What file, module, or specific logic should we investigate first?"

```


## What it ignores by default

You don't want to feed compiled binaries or massive cache folders to an LLM. By default, `llmdump` skips:

* Hidden folders (like `.git`, `.idea`)
* `__pycache__`
* `node_modules`
* `venv` / `env`

It only grabs readable files like `.py`, `.json`, `.md`, `.txt`, `.sh`, `.js`, `.html`, etc. You can easily tweak the source code if you want to add more extensions.