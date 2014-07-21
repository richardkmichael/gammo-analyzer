require_relative "cli"

module GammoAnalyzer
  class ReportBuilder

    def initialize
      @cli = GammoAnalyzer::CLI.new
    end

    # FIXME: Feels wrong.. but at least use a delegator if we're doing this.
    def report_dir
      @cli.report_dir
    end

    # klass and instances must respond to .to_csv.
    def write_csv_report_for_klass klass
      report_file = File.join(report_dir, "#{klass.name.underscore}.csv")

      CSV File.open(report_file, "w+") do |csv|
        csv << klass.to_csv
        klass.all do |m|
          csv << m.to_csv
        end
      end
    end

    # FIXME: This can't be here until the database loading problem has been solved.
    def summary
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
    end
  end # class ReportBuilder
end # module GammoAnalyzer
