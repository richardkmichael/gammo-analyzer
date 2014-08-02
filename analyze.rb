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

require "sqlite3"
require "sequel"
require "csv"


require_relative "lib/gammo_analyzer/cli"
cli = GammoAnalyzer::CLI.new

require_relative "lib/gammo_analyzer/initialize.rb"
require_relative "lib/gammo_analyzer/report_builder"

# FIXME: Should pass config, not a cli instance.
# report_builder = GammoAnalyzer::ReportBuilder.new cli.configuration
report_builder = GammoAnalyzer::ReportBuilder.new cli

puts report_builder.summary

cli.offer_pry
