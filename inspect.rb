require "pry"

require "sqlite3"
require "sequel"
require 'csv'

# FIXME: Move this to an init file?
f = ARGV[0]
DB = Sequel.sqlite f

require_relative 'lib/gammo_analyzer/folder'
require_relative 'lib/gammo_analyzer/message'
require_relative 'lib/gammo_analyzer/failed_message'
require_relative 'lib/gammo_analyzer/failed_email_message'
require_relative 'lib/gammo_analyzer/failed_contact_message'
require_relative 'lib/gammo_analyzer/failed_calendar_message'

binding.pry
