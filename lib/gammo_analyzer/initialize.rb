module GammoAnalyzer
  begin
    ::DB = Sequel.sqlite Configuration.database
  # rescue Sequel::DatabaseError => e
  rescue SQLite3::NotADatabaseException => e
    puts "FATAL: #{e.message}"
    exit
  end

  require_relative "folder"
  require_relative "message"
  require_relative "failed_message"
  require_relative "failed_email_message"
  require_relative "failed_contact_message"
  require_relative "failed_calendar_message"
  require_relative "core/string"

  FAILED_MESSAGE_KLASSES = [ FailedEmailMessage, FailedContactMessage, FailedCalendarMessage ]
end
