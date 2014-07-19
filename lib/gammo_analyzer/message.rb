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

  def to_csv
    [ error_code, folder.name ]
  end

  def self.csv_header
    [ 'ERROR CODE', 'FOLDER NAME' ]
  end
end
