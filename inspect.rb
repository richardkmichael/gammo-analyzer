require "pry"

require "sqlite3"
require "sequel"

f = ARGV[0]

DB = Sequel.sqlite f

class Folder < Sequel::Model
  one_to_many :messages, :key => :FolderId

  def_column_alias :id,   :FolderId
  def_column_alias :name, :FolderName
  def_column_alias :type, :FolderType
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

  def_column_alias :run_id,           :MessageRunId
  def_column_alias :folder_id,        :FolderId
  def_column_alias :error_code,       :ErrorCode
  def_column_alias :message_key,      :MessageKey       # FIXME: HEX, but what is it?
  def_column_alias :migration_id,     :MigrationId
  def_column_alias :migration_status, :MigrationStatus
end

class FailedMessage < Message
  def_column_alias :error, :ErrorDesc

  def error_code    ; error.split(':').last    ; end
  def error_message ; error.split(',').first   ; end
  def failed_at     ; Time.at self.FailureTime ; end
end

class FailedEmailMessage < Message
  def_column_alias :subject,  :Subject
  def_column_alias :sender,   :SenderEmailAddress
  def_column_alias :receiver, :ReceiverEmailAddress

  def sent_at ; Time.at self.SentTime ; end
end

class FailedCalendarMessage < Message
  def_column_alias :title,     :Title
  def_column_alias :organizer, :Organizer
  def_column_alias :attendees, :Attendees

  def start_at  ; Time.at self.StartTime ; end
  def end_at    ; Time.at self.EndTime   ; end
end

class FailedContactMessage < Message
  def_column_alias :full_name,     :FullName
  def_column_alias :email_address, :EmailAddress
end

binding.pry
