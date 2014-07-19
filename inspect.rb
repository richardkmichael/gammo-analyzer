# TODO:
#
# 1/ Would be neat to make Sequel's class_table_inheritance call "forward", finding the special
#     subclass type; e.g. this should return FailedEmailMessage, FailedContactMessage, etc.
#     Message.where(Sequel.~(:ErrorCode => '')).first.class
#
# 2/ The class hierarchy should be FailedEmailMessage < FailedMessage < Message.
#

require "pry"

require "sqlite3"
require "sequel"
require 'csv'

# FIXME: Move this to an init file?
begin
  puts 'Provide a database file.'
  exit
end unless ARGV[0]

f = ARGV[0]
DB = Sequel.sqlite f

require_relative 'lib/gammo_analyzer/folder'
require_relative 'lib/gammo_analyzer/message'
require_relative 'lib/gammo_analyzer/failed_message'
require_relative 'lib/gammo_analyzer/failed_email_message'
require_relative 'lib/gammo_analyzer/failed_contact_message'
require_relative 'lib/gammo_analyzer/failed_calendar_message'

# Loop through all failure types, printing a list.

binding.pry

# Messages with errors.
messages_with_errors = Message.where(Sequel.~(:ErrorCode => ''))

# All encountered error codes.
error_codes = messages_with_errors.map(:ErrorCode).uniq

# Total message counts.
puts "                Total messages: #{Message.count} (including #{messages_with_errors.count} with errors)"
puts "         Total failed messages: #{FailedMessage.count} (sum of all types)"
puts "   Total failed email messages: #{FailedEmailMessage.count}"
puts " Total failed contact messages: #{FailedContactMessage.count}"
puts "Total failed calendar messages: #{FailedCalendarMessage.count}"

if messages_with_errors.count != FailedMessage.count
  puts "WARNING: Message class errors not equal to FailedMessage class errors. Investigate."
end

puts ""
puts "Error codes encountered: #{error_codes}"
report = File.open(File.join("fixtures", File.basename(f)) << "-report.csv", 'w+')

failed_message_klasses = [ FailedEmailMessage, FailedContactMessage, FailedCalendarMessage ]

CSV report do |csv|
  failed_message_klasses.each do | failed_message_klass |
    csv << failed_message_klass.csv_header

    failed_message_klass.all do |m|
      csv << m.to_csv
    end

    csv << []
  end
end
