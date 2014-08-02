# FIXME: CLI provide a configuration instance, not use a Configuration singleton.
#        def configuration ; ; end

require "pry"
require 'optparse'

require_relative 'configuration'

module GammoAnalyzer
  class CLI

    attr_reader :database
    attr_reader :output_dir
    attr_reader :report_dir
    attr_reader :report_format

    def initialize
      Configuration.configure parse_options_from_argv
      @database      = Configuration.database
      @output_dir    = Configuration.output_dir
      @report_dir    = Configuration.report_dir
      @report_format = Configuration.report_format

      # FIXME: Should this go into the Configuration module?
      FileUtils.mkdir_p @report_dir unless File.directory? @report_dir
    end

    def offer_pry
      print 'Press any key to start a Pry session in '
      countdown = 3
      until ( countdown == 0 ) || ( start_console = console? ) do
        count = "..#{countdown}"
        countdown == 1 ? puts(count) : print(count)
        sleep 1
        countdown -= 1
      end

      binding.pry if start_console
    end

    private

    def console?
      # Do not pollute readline's history.
      system 'stty raw -echo'
      begin
        $stdin.read_nonblock 1
      rescue Errno::EINTR, Errno::EAGAIN, EOFError
        false
      ensure
        # Ensure the terminal is cooked when we exit.
        system 'stty -raw echo'
      end
    end

    def parse_options_from_argv
      options = {}
      OptionParser.new do |opts|
        opts.on('-d SQLITEDB', '--database=SQLITEDB', String, 'Path to SQLITE database file.') do |v|
          options.store :database, v
        end

        opts.on('-o DIRECTORY', '--output=DIRECTORY', String, 'Directory to write report CSV files.') do |v|
          options.store :output_dir, v
        end

        opts.on('-f FORMAT', '--format=FORMAT', String, 'Format to write report files. (Default: CSV)') do |v|
          options.store :report_format, v
        end

        opts.on('-h', '--help', 'Show this message.') do
          puts opts
          exit
        end

        begin
          ARGV << '-h' if ARGV.empty?
          opts.parse!(ARGV)
        rescue OptionParser::ParseError => e
          $stderr.puts e.message, '\n', opts
          exit(-1)
        end
      end

      options
    end

  end # class CLI
end # module GammoAnalyzer
