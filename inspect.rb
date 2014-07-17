require "pry"

require "sqlite3"
require "sequel"

f = ARGV[0]

DB = Sequel.sqlite f

class Folder < Sequel::Model
  one_to_many :messages, :key => :FolderId

  def id   ; self.FolderId   ; end # Primary key
  def name ; self.FolderName ; end
  def type ; self.FolderType ; end
end

class Message < Sequel::Model
  plugin :class_table_inheritance,
         :table_map => {
           :FailedMessage         => :FailedMessages,
           :FailedEmailMessage    => :FailedEmailMessages,
           :FailedContactMessage  => :FailedContactMessages,
           :FailedCalendarMessage => :FailedCalendarMessages
         }

  many_to_one :folder, :key => :FolderId

  def folder_id        ; self.FolderId        ; end
  def run_id           ; self.MessageRunId    ; end # Primary key
  def migration_id     ; self.MigrationId     ; end
  def message_key      ; self.MessageKey      ; end # FIXME: HEX, but what is it?
  def migration_status ; self.MigrationStatus ; end
  def error_code       ; self.ErrorCode       ; end
end

class FailedMessage < Message
  def error         ; self.ErrorDesc           ; end
  def error_code    ; error.split(':').last    ; end
  def error_message ; error.split(',').first   ; end
  def failed_at     ; Time.at self.FailureTime ; end
end

class FailedEmailMessage < Message
  def_column_alias :sender,   :SenderEmailAddress
  def_column_alias :receiver, :ReceiverEmailAddress
  def_column_alias :subject,  :Subject

  def sent_at ; Time.at self.SentTime ; end
end

class FailedCalendarMessage < Message
  def_column_alias :organizer, :Organizer
  def_column_alias :attendees, :Attendees
  def_column_alias :title,     :Title

  def start_at  ; Time.at self.StartTime ; end
  def end_at    ; Time.at self.EndTime   ; end
end

class FailedContactMessage < Message
  def_column_alias :full_name,     :FullName
  def_column_alias :email_address, :EmailAddress
end

# Simpler than AS::Inflector (no-acronyms), but still enough.
# class String
#   def underscore
#     word = self.dup
#     word.gsub!(/::/, '/')
#     word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
#     word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
#     word.tr!("-", "_")
#     word.downcase!
#     word
#   end
# end

# def underscore(camel_cased_word)
#   word = camel_cased_word.to_s.gsub('::', '/')
#   word.gsub!(/(?:([A-Za-z\d])|^)(#{inflections.acronym_regex})(?=\b|[^a-z])/) { "#{$1}#{$1 && '_'}#{$2.downcase}" }
#   word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
#   word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
#   word.tr!("-", "_")
#   word.downcase!
#   word
# end

binding.pry
