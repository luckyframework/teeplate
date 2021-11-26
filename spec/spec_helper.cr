require "spec"
require "./support/**"
require "../src/teeplate"

module Teeplate::SpecHelper
  def list_file(s, color, colorize)
    s.colorize.fore(color).toggle(colorize)
  end

  def list_new(color = true)
    list_file "new       ", :green, color
  end

  def list_ide(color = true)
    list_file "identical ", :dark_gray, color
  end

  def list_mod(color = true)
    list_file "modified  ", :magenta, color
  end

  def list_ski(color = true)
    list_file "skipped   ", :yellow, color
  end

  def interact(io, answers, prompt = "", buffer = nil)
    spawn do
      loop do
        if ch = io.out!.read_char
          if buf = buffer
            buf << ch
          end
          prompt += ch
          if prompt.ends_with?(" ? ")
            io.in.puts answers.shift
            unless answers.empty?
              interact io, answers, buffer: buffer
            end
            break
          end
        else
          spawn do
            interact io, answers, prompt, buffer: buffer
            nil
          end
        end
      end
      nil
    end
  end
end
