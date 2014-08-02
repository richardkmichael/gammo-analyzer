module GammoAnalyzer
  module Configuration

    DEFAULT_OPTIONS = { :output_dir    => "fixture/reports",
                        :report_format => :csv }

    def self.configure config
      # FIXME Don't use a hash; use ivars and set them from the hash, then use attr_reader instead of custom accessors.
      @config = DEFAULT_OPTIONS.merge config
      @config.store :report_dir, File.join(output_dir, File.basename(database))
    end

    # FIXME: Metaprogram these.
    def self.database
      @config.fetch :database, nil
    end

    def self.output_dir
      @config.fetch :output_dir, nil
    end

    def self.report_dir
      @config.fetch :report_dir, nil
    end

    def self.report_format
      @config.fetch :report_format, nil
    end

  end # module Configuration
end # modules GammoAnalyzer
