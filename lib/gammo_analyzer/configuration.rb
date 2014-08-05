DB = Sequel.sqlite("/home/ubuntu/helen.qi@articleltd.com")
module GammoAnalyzer
  class Configuration

    DEFAULT_REPORT_FORMAT = :csv

    def initialize(database:,output_dir: 'output_dir',report_format: DEFAULT_REPORT_FORMAT)
      @database = database
      @output_dir = output_dir
      @report_format = report_format

      Kernel.const_set("DB", Sequel.sqlite(@database))

      puts "defining message"
      # require 'pry' ; binding.pry
      require "gammo_analyzer/folder"
      require "gammo_analyzer/message"
      require "gammo_analyzer/failed_message"
      require "gammo_analyzer/failed_email_message"
      require "gammo_analyzer/failed_contact_message"
      require "gammo_analyzer/failed_calendar_message"
    end

      #FileUtils.mkdir_p @output_dir unless File.directory? @output_dir

      #rescue SQLite3::NotADatabaseException => e
      #  puts "FATAL: #{e.message}"
      #  exit
      #end

      ##FAILED_MESSAGE_KLASSES = [ FailedEmailMessage, FailedContactMessage, FailedCalendarMessage ]

  end # class Configuration
end # module GammoAnalyzer
