# TODO:
#
# 1/ Would be neat to make Sequel's class_table_inheritance call "forward", finding the special
#     subclass type; e.g. this should return FailedEmailMessage, FailedContactMessage, etc.
#     Message.where(Sequel.~(:ErrorCode => '')).first.class
#
# 2/ Errors:
#      a) codes should link to Google support.
#      b) not all "error codes" are 8-digit HEX, e.g., "GDSTATUS_BAD_REQUEST"
#
# 3/ Extract CSV to a presenter, define "printable columns" on the models, etc.

require "pry"

require 'optparse'

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

database = options.fetch :database
output_dir = options.fetch :output_dir, 'fixture/reports'

require "sqlite3"
require "sequel"
DB = Sequel.sqlite database

# Database must be ready before any of these classes can be loaded.
require_relative 'lib/gammo_analyzer/folder'
require_relative 'lib/gammo_analyzer/message'
require_relative 'lib/gammo_analyzer/failed_message'
require_relative 'lib/gammo_analyzer/failed_email_message'
require_relative 'lib/gammo_analyzer/failed_contact_message'
require_relative 'lib/gammo_analyzer/failed_calendar_message'
require_relative 'lib/gammo_analyzer/core/string'

# For reports.
require 'csv'

# klass and instances must respond to .to_csv.
def write_csv_report_for_klass klass
  report_file = File.join(@report_dir, "#{klass.name.underscore}.csv")
  CSV File.open(report_file, "w+") do |csv|
    csv << klass.to_csv
    klass.all do |m|
      csv << m.to_csv
    end
  end
end

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

@report_dir = File.join(output_dir, File.basename(database))
FileUtils.mkdir_p @report_dir unless File.directory? @report_dir

# Folder report: names, message counts, failed message counts.
write_csv_report_for_klass Folder

# Message type reports: folder, message-type specific details - subject, contact, attendees, etc.
failed_message_klasses = [ FailedEmailMessage, FailedContactMessage, FailedCalendarMessage ]
failed_message_klasses.each do | failed_message_klass |
  failed_message_klass.any? do
    write_csv_report_for_klass failed_message_klass
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
