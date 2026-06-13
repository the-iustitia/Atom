# Atom

A lightweight terminal text editor written in Ruby.

Atom is a Vim-inspired terminal editor built for learning, experimentation, and understanding how text editors work internally. It provides a minimal yet functional editing environment directly inside the terminal.

---

## Features

* Terminal-based interface
* Normal and Insert modes
* File opening and saving
* Cursor navigation
* Viewport scrolling
* Search functionality
* Undo support
* Copy and paste lines
* Line numbers
* Cross-platform support

---

## Key Bindings

### Navigation

| Key | Action            |
| --- | ----------------- |
| h   | Move cursor left  |
| j   | Move cursor down  |
| k   | Move cursor up    |
| l   | Move cursor right |

### Editing

| Key | Action              |
| --- | ------------------- |
| i   | Enter Insert Mode   |
| x   | Delete character    |
| dd  | Delete current line |
| yy  | Copy current line   |
| p   | Paste copied line   |

### Search

| Command | Action          |
| ------- | --------------- |
| /text   | Search for text |

### Undo

| Key      | Action           |
| -------- | ---------------- |
| Ctrl + U | Undo last action |

### File Operations

| Command | Action        |
| ------- | ------------- |
| :w      | Save file     |
| :q      | Quit editor   |
| :wq     | Save and quit |

---

## Requirements

* Ruby 3.0+
* ANSI-compatible terminal

### Supported Platforms

* Linux
* Windows (Windows Terminal recommended)
* macOS

---

## Installation

Clone the repository:

```bash
git clone https://github.com/your-username/atom.git
cd atom
```

Install dependencies (if any):

```bash
bundle install
```

---

## Usage

Open an existing file:

```bash
ruby atom.rb README.md
```

Create a new file:

```bash
ruby atom.rb notes.txt
```

---

## Project Structure

```text
atom/
│
├── atom.rb
├── README.md
├── LICENSE
│
├── core/
│   ├── editor.rb
│   ├── buffer.rb
│   ├── renderer.rb
│   ├── input.rb
│   └── commands.rb
│
└── docs/
```

---

## Roadmap

### v0.4

* Redo support
* Arrow keys
* Backspace improvements
* Better terminal rendering

### v0.5

* Syntax highlighting
* Multiple buffers
* Better search engine
* Configuration file support

### v1.0

* Plugin system
* Window splitting
* Themes
* Vim-style command extensions

---

## Philosophy

Atom aims to stay:

* Lightweight
* Fast
* Hackable
* Educational

The codebase is intentionally kept simple so developers can explore and understand how terminal editors work under the hood.

---

## License

MIT License

Feel free to use, modify, and distribute this project.
