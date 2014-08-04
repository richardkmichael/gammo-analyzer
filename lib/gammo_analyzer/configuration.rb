module GammoAnalyzer
  class Configuration

    class << self
      attr_accessor :database
    end

    attr_reader :output_dir
    attr_reader :report_format

    DEFAULT_REPORT_FORMAT = :csv

    def initialize configuration
      self.class.database  = configuration.fetch :database
      @output_dir          = configuration.fetch :output_dir, File.dirname(self.class.database)
      @report_format       = configuration.fetch :report_format, DEFAULT_REPORT_FORMAT

      FileUtils.mkdir_p @output_dir unless File.directory? @output_dir

      # Now that we have the DB file, etc. kick-off the rest of the initialization.
      require "gammo_analyzer/initialize"
    end

  end # class Configuration
end # modules GammoAnalyzer
