# TODO:
#
# 1/ Would be neat to make Sequel's class_table_inheritance call "forward", finding the special
#     subclass type; e.g. this should return FailedEmailMessage, FailedContactMessage, etc.
#     Message.where(Sequel.~(:ErrorCode => '')).first.class
#
# 2/ Error codes should link to Google support.
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

# Messages with errors.
messages_with_errors = Message.where(Sequel.~(:ErrorCode => ''))

# All encountered error codes.
error_codes = messages_with_errors.map(:ErrorCode).uniq

# Total message counts.
puts "                Total messages: #{Message.count} (including #{messages_with_errors.count} with errors)"
puts "         Total failed messages: #{FailedMessage.count} (sum of all types below)"
puts "   Total failed email messages: #{FailedEmailMessage.count}"
puts " Total failed contact messages: #{FailedContactMessage.count}"
puts "Total failed calendar messages: #{FailedCalendarMessage.count}"

if messages_with_errors.count != FailedMessage.count
  puts ""
  puts "WARNING: Message class errors not equal to FailedMessage class errors. Investigate."
  puts ""
end

puts ""
puts "Error codes encountered: #{error_codes}"

FileUtils.mkdir_p output_dir unless File.directory? output_dir

failed_message_klasses = [ FailedEmailMessage, FailedContactMessage, FailedCalendarMessage ]

failed_message_klasses.each do | failed_message_klass |
  failed_message_klass.any? do

    report_file = File.join(output_dir, "#{failed_message_klass.name.underscore}.csv")

    CSV File.open(report_file, "w+") do |csv|
      csv << failed_message_klass.to_csv
      failed_message_klass.all do |m|
        csv << m.to_csv
      end
    end

  end
end
