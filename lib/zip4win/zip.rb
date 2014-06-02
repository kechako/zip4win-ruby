require 'zip4win/version'
require 'optparse'
require 'pathname'
require 'unf'
require 'zip'

module Zip4win
  class Zip
    def initialize
      @options = {}

      init_zip
    end

    def run
      exit_code = 0
      if parse_params
        exit_code = 2 unless create_zip
      else
         exit_code = 1
      end

      exit_code
    end

    def names_stdin?
      @options[:names_stdin]
    end

    attr_reader :zipfile, :files

    private

    def parse_params
      result = true
      args = []
      OptionParser.new "Usage: #{File.basename($0)} [options] zipfile [file [...]]" do |parser|
        parser.version = VERSION

        parser.on('-@', '--names-stdin', 'Take the list of input files from standard input. Only one filename per line.') {|v| @options[:names_stdin] = v}

        args = parser.parse(ARGV)
        result = parse_args(args)
        unless result
          print_help parser
        end
      end

      result
    end

    def parse_args(args)
      return false if args.size < 1
      @zipfile = args.shift

      unless names_stdin?
        return false if args.size < 2
        @files = args
      end

      true
    end

    def print_help(parser)
      puts parser
    end

    def init_zip
      ::Zip.setup do |c|
        c.default_compression = Zlib::BEST_COMPRESSION
      end
    end

    def create_zip
      ::Zip::File.open(@zipfile, ::Zip::File::CREATE) do |zipfile|
        if names_stdin?
          $stdin.each do |line|
            add_zip(zipfile, Pathname.new(line.chomp))
          end
        else
          @files.each do |filename|
            add_zip(zipfile, Pathname.new(filename))
          end
        end
      end

      true
    end

    def add_zip(zipfile, path, base_directory = nil)
      entry = if base_directory.nil? then path.basename else path.relative_path_from(base_directory) end
      puts "#{path}"
      zipfile.add(conv_filename(entry.to_s), path.to_s)

      if path.directory?
        base_directory ||= path.parent
        path.each_child do |child|
          add_zip(zipfile, child, base_directory)
        end
      end
    end

    def conv_filename(filename)
      filename.to_nfc.encode('SJIS', invalid: :replace, undef: :replace)
    end
  end
end
