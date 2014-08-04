module GammoAnalyzer
  class Configuration

    attr_reader :database
    attr_reader :output_dir
    attr_reader :report_format

    DEFAULT_REPORT_FORMAT = :csv

    def initialize configuration
      @database      = configuration.fetch :database
      @output_dir    = configuration.fetch :output_dir, File.dirname(@database)
      @report_format = configuration.fetch :report_format, DEFAULT_REPORT_FORMAT
    end

  end # class Configuration
end # modules GammoAnalyzer
