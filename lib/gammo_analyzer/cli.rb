# FIXME:
#
# 1/ CLI provide a configuration instance, not use a Configuration singleton.
#    def configuration ; ; end
#
# 2/ Suppress summary output
#
# 3/ Request/suppress pry

require "optparse"

require "gammo_analyzer/configuration"

module GammoAnalyzer
  class CLI

    attr_reader :configuration
    attr_reader :interactive

    def initialize
      options = parse_options_from_argv
      @interactive = options.delete :interactive
      @configuration = Configuration.new
    end

#   def offer_console
#     print "\nPress any key to start a Pry session in "
#     countdown = 3

#     until ( countdown == 0 ) || ( launch = start_now? ) do
#       count = "..#{countdown}"
#       countdown == 1 ? puts(count) : print(count)
#       sleep 1
#       countdown -= 1
#     end

#     console if launch
#   end

    def console
      require "pry"
      binding.pry
    end

    private

#   def start_now?
#     # Do not pollute readline's history.
#     system 'stty raw -echo'
#     begin
#       $stdin.read_nonblock 1
#     rescue Errno::EINTR, Errno::EAGAIN, EOFError
#       false
#     ensure
#       # Ensure the terminal is cooked when we exit.
#       system 'stty -raw echo'
#     end
#   end

    def parse_options_from_argv
      options = {}
      OptionParser.new do |opts|
        opts.on('-d SQLITEDB', '--database=SQLITEDB', String, 'Path to SQLITE database file. (Required.)') do |v|
          options.store :database, v
        end

        opts.on('-o DIRECTORY', '--output=DIRECTORY', String, 'Directory to write report files. (Default: Beside the DB file.') do |v|
          options.store :output_dir, v
        end

        opts.on('-f FORMAT', '--format=FORMAT', String, 'Format to write report files. (Default: CSV)') do |v|
          options.store :report_format, v
        end

        opts.on('-i', '--interactive', Boolean, 'Launch an interactive Pry console.') do |v|
          options.store :interactive, v
        end

        opts.on('-h', '--help', 'Show this message.') do
          $stderr.puts opts
          exit
        end

        begin
          ARGV << '-h' if ARGV.empty?
          opts.parse! ARGV
          raise OptionParser::MissingArgument, 'Database file required' unless options.fetch :database, nil
        rescue OptionParser::ParseError => e # OP::MissingArgument < OP::ParseError, so this catches both.
          $stderr.puts "#{e.message}\n\n#{opts}"
          exit(-1)
        end
      end

      options
    end

  end # class CLI
end # module GammoAnalyzer
