module HaveFiles
  VERSION = "0.3.4"

  module C
    lib Lib
      fun mkdtemp(template : LibC::Char*) : LibC::Char*
    end
  end

  def self.tmpdir(base : String = "/tmp", cleanup : Bool = true, &block)
    ptmpdir = "#{base}/XXXXXX".bytes + [0_u8]
    raise "mkdtemp() error." if C::Lib.mkdtemp(ptmpdir) == 0
    tmpdir = String.new(ptmpdir.to_unsafe)
    begin
      yield tmpdir
    ensure
      rm_r tmpdir if cleanup
    end
  end

  def self.rm_r(path)
    if Dir.exists?(path) && !File.symlink?(path)
      Dir.open(path) do |dir|
        dir.each do |entry|
          if entry != "." && entry != ".."
            src = File.join(path, entry)
            rm_r(src)
          end
        end
      end
      FileUtils.rmdir(path)
    else
      File.delete(path) if File.exists?(path)
    end
  end
end
