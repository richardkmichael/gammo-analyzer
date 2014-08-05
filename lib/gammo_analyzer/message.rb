module GammoAnalyzer
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
      def_column_alias :error_code,       :ErrorCode        # This is also on FailedMessage, and with a description.
      def_column_alias :message_key,      :MessageKey       # HEX, but what is it?
      def_column_alias :migration_id,     :MigrationId
      def_column_alias :migration_status, :MigrationStatus

      def to_csv
        [ folder.name ]
      end

      def self.to_csv
        [ 'FOLDER NAME' ]
      end
  end
end
