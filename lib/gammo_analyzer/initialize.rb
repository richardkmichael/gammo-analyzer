# Setup that can only happen after we've received options from the user.

module GammoAnalyzer
  begin
    ::DB = Sequel.sqlite Configuration.database
  # rescue Sequel::DatabaseError => e
  rescue SQLite3::NotADatabaseException => e
    puts "FATAL: #{e.message}"
    exit
  end

  require "gammo_analyzer/folder"
  require "gammo_analyzer/message"
  require "gammo_analyzer/failed_message"
  require "gammo_analyzer/failed_email_message"
  require "gammo_analyzer/failed_contact_message"
  require "gammo_analyzer/failed_calendar_message"
  require "gammo_analyzer/core/string"

  FAILED_MESSAGE_KLASSES = [ FailedEmailMessage, FailedContactMessage, FailedCalendarMessage ]

  FileUtils.mkdir_p @report_dir unless File.directory? @report_dir
end
