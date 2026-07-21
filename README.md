# LLMDump 🧠

`llmdump` is a dead-simple bash script that crawls your project directory, grabs all the important text/code files (ignoring the garbage like `.git`, `node_modules`, and `__pycache__`), and dumps them into two beautifully formatted files simultaneously:

1. **`codebase_dump.md`**: A Markdown version heavily optimized for **ChatGPT** and **Gemini**.
2. **`codebase_dump.xml`**: An XML version using `<document>` and `CDATA` tags, strictly optimized for **Claude 3**'s attention mechanism.

Feed the output file to your favorite LLM and let it understand your entire project architecture in one go.

## One-Line Installation

Just run this in your terminal. It downloads the script, puts it in `~/.local/bin`, detects if you're running `bash` or `zsh`, and adds the alias for you.

```bash
curl -sSL https://raw.githubusercontent.com/Matin-B/llmdump/main/install.sh | bash

```

*(Don't forget to run `source ~/.bashrc` or `source ~/.zshrc` after installing, or just restart your terminal).*

## How to Use

Run the command and provide your project's absolute path:
```bash
llmdump
```

## What it ignores by default

You don't want to feed compiled binaries or massive cache folders to an LLM. By default, `llmdump` skips:

* Hidden folders (like `.git`, `.idea`)
* `__pycache__`
* `node_modules`
* `venv` / `env`

It only grabs readable files like `.py`, `.json`, `.md`, `.txt`, `.sh`, `.js`, `.html`, etc. You can easily tweak the source code if you want to add more extensions.