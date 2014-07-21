module GammoAnalyzer
  module Configuration

    DEFAULT_OPTIONS = { :output_dir => "fixture/reports" }

    def self.configure config
      @config = DEFAULT_OPTIONS.merge config
      @config.store :report_dir, File.join(output_dir, File.basename(database))
    end

    def self.database
      @config.fetch :database, nil
    end

    def self.output_dir
      @config.fetch :output_dir, nil
    end

    def self.report_dir
      @config.fetch :report_dir, nil
    end

  end # module Configuration
end # modules GammoAnalyzer
