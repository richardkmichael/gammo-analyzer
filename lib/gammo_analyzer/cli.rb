require 'optparse'

require_relative 'configuration'

module GammoAnalyzer
  class CLI

    attr_reader :database
    attr_reader :output_dir
    attr_reader :report_dir

    def initialize
      GammoAnalyzer::Configuration.configure parse_options_from_argv
      @database   = GammoAnalyzer::Configuration.database
      @output_dir = GammoAnalyzer::Configuration.output_dir
      @report_dir = GammoAnalyzer::Configuration.report_dir

      # FIXME: Should this go into the Configuration module?
      FileUtils.mkdir_p @report_dir unless File.directory? @report_dir
    end

    private

    def parse_options_from_argv
      options = {}
      OptionParser.new do |opts|
        opts.on('-d SQLITEDB', '--database=SQLITEDB', String, 'Path to SQLITE database file.') do |v|
          options.store :database, v
        end

        opts.on('-o DIRECTORY', '--output=DIRECTORY', String, 'Directory to write report CSV files.') do |v|
          options.store :output_dir, v
        end

        opts.on('-h', '--help', 'Show this message.') do
          puts opts
          exit
        end

        begin
          ARGV << '-h' if ARGV.empty?
          opts.parse!(ARGV)
        rescue OptionParser::ParseError => e
          STDERR.puts e.message, '\n', opts
          exit(-1)
        end
      end

      options
    end

  end # class CLI
end # module ReportBuilder
