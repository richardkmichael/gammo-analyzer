# FIXME:
#
# 0/ Extract CSV to a presenter, define "printable columns" on the models, etc.
#
# 1/ Errors:
#      a) codes should link to Google support.
#      b) not all "error codes" are 8-digit HEX, e.g., "GDSTATUS_BAD_REQUEST"

require "csv"

module GammoAnalyzer
  class ReportBuilder

    # FIXME: This should receive a configuration object, or use an object from a higher module?
    def initialize configuration
      @configuration = configuration
    end

    def report
      report = summary

      # The Folder report: names, message counts, failed message counts.
      report_file = write_report_for_klass Folder
      report << "Report written for Folder to #{report_file}"

      # The message type reports: which folder, message-type specific details - subject, contact, attendees, etc.
      FAILED_MESSAGE_KLASSES.each do | failed_message_klass |
        report << if failed_message_klass.any?
                    write_report_for_klass failed_message_klass
                  else
                    "\nNo failures for #{failed_message_klass}."
                  end
      end

      report
    end

    def summary
      # Messages with errors: either ErrorCode or ErrorDesc is not empty. # FIXME: Why not just "FailedMessage.count"?
      messages_with_errors = Message.where(Sequel.~(:ErrorCode => ''))

      # Folders with failed messages.
      folders_with_failures = Folder.all.select { |f| f.failed_messages? }

      # All encountered error codes. # FIXME: Do this with 'SELECT ... DISTINCT'.
      error_codes = messages_with_errors.map(:ErrorCode).uniq

      summary = "Error codes encountered: #{error_codes}"

      if messages_with_errors.count != FailedMessage.count
        summary << <<-MESSAGES
        WARNING: Message class errors not equal to FailedMessage class errors. Investigate.
        MESSAGES
      end

      # Total message counts.
      summary << <<-TOTAL_MESSAGES
                         Total folders: #{Folder.count} (including #{folders_with_failures.count} with failures)
                        Total messages: #{Message.count} (including #{messages_with_errors.count} with errors)
                 Total failed messages: #{FailedMessage.count} (sum of all types below)
           Total failed email messages: #{FailedEmailMessage.count}
         Total failed contact messages: #{FailedContactMessage.count}
        Total failed calendar messages: #{FailedCalendarMessage.count}
      TOTAL_MESSAGES
    end

    def write_report_for_klass klass
      case @configuration.report_format
      when :csv
        write_csv_report_for_klass klass
      else
        raise "Unhandled report format: #{@configuration.report_format}"
      end
    end

    private

    # klass and instances must respond to .to_csv.
    def write_csv_report_for_klass klass
      report = File.join(@configuration.output_dir, "#{klass.name.underscore}.csv")

      CSV File.open(report, "w+") do |csv|
        csv << klass.to_csv
        klass.all do |m|
          csv << m.to_csv
        end
      end
    end

  end # class ReportBuilder
end # module GammoAnalyzer
