# TODO:
#
# 0/ Extract CSV to a presenter, define "printable columns" on the models, etc.
#
# 1/ Would be neat to make Sequel's class_table_inheritance call "forward", finding the special
#     subclass type; e.g. this should return FailedEmailMessage, FailedContactMessage, etc.
#     Message.where(Sequel.~(:ErrorCode => '')).first.class
#
# 2/ Errors:
#      a) codes should link to Google support.
#      b) not all "error codes" are 8-digit HEX, e.g., "GDSTATUS_BAD_REQUEST"

require "pry"
require "sqlite3"
require "sequel"
require "csv"


# FIXME: How to fix the code dependencies/ordering so that the CLI require handles everything?
#        Database must be ready before any of the later classes can be loaded.
#        Really, we need a GammoAnalyzer::ReportBuilder, which inits the CLI, then the DB. THIS DOESN'T SOLVE ANYTHING :(
require_relative "lib/gammo_analyzer/report_builder"
@report_builder = GammoAnalyzer::ReportBuilder.new  # FIXME: Maybe we should pass in the configuration object?
require_relative "lib/gammo_analyzer/database"

require_relative "lib/gammo_analyzer/folder"
require_relative "lib/gammo_analyzer/message"
require_relative "lib/gammo_analyzer/failed_message"
require_relative "lib/gammo_analyzer/failed_email_message"
require_relative "lib/gammo_analyzer/failed_contact_message"
require_relative "lib/gammo_analyzer/failed_calendar_message"
require_relative "lib/gammo_analyzer/core/string"

# Messages with errors: either ErrorCode or ErrorDesc is not empty. # FIXME: Why not just "FailedMessage.count"?
messages_with_errors = Message.where(Sequel.~(:ErrorCode => ''))

# Folders with failed messages.
folders_with_failures = Folder.all.select { |f| f.failed_messages? }

# All encountered error codes. # FIXME: Do this with 'SELECT ... DISTINCT'.
error_codes = messages_with_errors.map(:ErrorCode).uniq

puts ""
puts "Error codes encountered: #{error_codes}"

if messages_with_errors.count != FailedMessage.count
  puts ""
  puts "WARNING: Message class errors not equal to FailedMessage class errors. Investigate."
  puts ""
end

# Total message counts.
puts "                 Total folders: #{Folder.count} (including #{folders_with_failures.count} with failures)"
puts "                Total messages: #{Message.count} (including #{messages_with_errors.count} with errors)"
puts "         Total failed messages: #{FailedMessage.count} (sum of all types below)"
puts "   Total failed email messages: #{FailedEmailMessage.count}"
puts " Total failed contact messages: #{FailedContactMessage.count}"
puts "Total failed calendar messages: #{FailedCalendarMessage.count}"

# Folder report: names, message counts, failed message counts.
@report_builder.write_csv_report_for_klass Folder

# Message type reports: folder, message-type specific details - subject, contact, attendees, etc.
failed_message_klasses = [ FailedEmailMessage, FailedContactMessage, FailedCalendarMessage ]
failed_message_klasses.each do | failed_message_klass |
  failed_message_klass.any? do
    @report_builder.write_csv_report_for_klass failed_message_klass
  end
end

def console?
  # Do not pollute readline's history.
  system 'stty raw -echo'
  begin
    STDIN.read_nonblock 1
  rescue Errno::EINTR, Errno::EAGAIN, EOFError
    false
  ensure
    # Ensure the terminal is cooked when we exit.
    system 'stty -raw echo'
  end
end

print 'Press any key to start a Pry session in '
countdown = 5
until ( countdown == 0 ) || ( start_console = console? ) do
  count = "..#{countdown}"
  countdown == 1 ? puts(count) : print(count)
  sleep 1
  countdown -= 1
end

binding.pry if start_console
