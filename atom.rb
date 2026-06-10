#!/usr/bin/env ruby
require "io/console"

class MiniVim
  SCREEN_HEIGHT = 20

  def initialize(file)
    @file = file
    @lines = File.exist?(file) ? File.readlines(file, chomp: true) : [""]
    @cx = 0
    @cy = 0
    @row_offset = 0

    @mode = :normal
    @running = true

    @clipboard = ""
    @undo_stack = []
  end

  # ================= MAIN LOOP =================
  def run
    system("clear")
    hide_cursor

    while @running
      render
      input
    end
  ensure
    show_cursor
    system("clear")
  end

  # ================= RENDER =================
  def render
    system("clear")

    visible_lines.each_with_index do |line, i|
      real_i = i + @row_offset
      num = (real_i + 1).to_s.rjust(3)
      cursor = (real_i == @cy) ? ">" : " "
      puts "#{num} #{cursor} #{line}"
    end

    draw_status
    move_cursor_screen
  end

  def visible_lines
    @lines[@row_offset, SCREEN_HEIGHT] || []
  end

  def draw_status
    print "\e[#{SCREEN_HEIGHT + 2};1H"
    print "\e[7m"
    print "MODE: #{@mode} | FILE: #{@file} | row:#{@cy} col:#{@cx} | dd/yy/p /search :w :q"
    print "\e[0m"
  end

  # ================= INPUT =================
  def input
    ch = STDIN.getch

    if @mode == :normal
      handle_normal(ch)
    else
      handle_insert(ch)
    end
  end

  # ================= NORMAL MODE =================
  def handle_normal(ch)
    case ch
    when "h" then @cx = [@cx - 1, 0].max
    when "l" then @cx += 1
    when "k" then move_up
    when "j" then move_down

    when "i"
      save_undo
      @mode = :insert

    when "x"
      delete_char

    when "d"
      if STDIN.getch == "d"
        delete_line
      end

    when "y"
      if STDIN.getch == "y"
        yank_line
      end

    when "p"
      paste

    when "/"
      search(STDIN.gets.chomp)

    when ":"
      cmd = STDIN.gets.chomp
      execute(cmd)

    when "\u0015" # Ctrl+U undo
      undo
    end

    clamp
    adjust_viewport
  end

  # ================= INSERT MODE =================
  def handle_insert(ch)
    if ch == "\e"
      @mode = :normal
      return
    end

    save_undo if @mode != :insert_saved

    if ch == "\r"
      split_line
      return
    end

    line = @lines[@cy]
    line.insert(@cx, ch)
    @lines[@cy] = line
    @cx += 1
  end

  # ================= EDIT OPERATIONS =================
  def delete_char
    line = @lines[@cy]
    line[@cx] = "" if @cx < line.size
    @lines[@cy] = line
  end

  def delete_line
    save_undo
    @clipboard = @lines.delete_at(@cy) || ""
    @cy = [@cy, @lines.size - 1].min
  end

  def yank_line
    @clipboard = @lines[@cy]
  end

  def paste
    save_undo
    @lines.insert(@cy + 1, @clipboard)
  end

  def split_line
    save_undo
    line = @lines[@cy]
    left = line[0...@cx]
    right = line[@cx..] || ""

    @lines[@cy] = left
    @lines.insert(@cy + 1, right)

    @cy += 1
    @cx = 0
  end

  # ================= SEARCH =================
  def search(query)
    idx = @lines.index { |l| l.include?(query) }
    return unless idx

    @cy = idx
    @cx = @lines[@cy].index(query) || 0
    adjust_viewport
  end

  # ================= UNDO =================
  def save_undo
    @undo_stack << Marshal.dump([@lines, @cx, @cy])
    @undo_stack.shift if @undo_stack.size > 50
  end

  def undo
    return if @undo_stack.empty?

    @lines, @cx, @cy = Marshal.load(@undo_stack.pop)
  end

  # ================= MOVEMENT =================
  def move_up
    @cy -= 1
  end

  def move_down
    @cy += 1
  end

  def clamp
    @cy = [[@cy, 0].max, @lines.size - 1].min
    @cx = [[@cx, 0].max, @lines[@cy].size].min
  end

  # ================= VIEWPORT =================
  def adjust_viewport
    if @cy < @row_offset
      @row_offset = @cy
    elsif @cy >= @row_offset + SCREEN_HEIGHT
      @row_offset = @cy - SCREEN_HEIGHT + 1
    end
  end

  # ================= COMMANDS =================
  def execute(cmd)
    case cmd
    when "q"
      @running = false
    when "w"
      File.write(@file, @lines.join("\n"))
    when "wq"
      File.write(@file, @lines.join("\n"))
      @running = false
    end
  end

  # ================= CURSOR =================
  def move_cursor_screen
    screen_y = @cy - @row_offset + 1
    print "\e[#{screen_y};#{@cx + 5}H"
  end

  def hide_cursor = print("\e[?25l")
  def show_cursor = print("\e[?25h")
end

file = ARGV[0] || "test.txt"
MiniVim.new(file).run
