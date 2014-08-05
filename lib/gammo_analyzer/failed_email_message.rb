module GammoAnalyzer
class FailedEmailMessage < FailedMessage
  def_column_alias :subject,  :Subject
  def_column_alias :receiver, :ReceiverEmailAddress

  def sender
    # FIXME: Hack: snip long ActiveDirectory addresses if internal.
    if self.SenderEmailAddress =~ /<\/O=.*\/OU=/
      self.SenderEmailAddress.gsub(/<.*>/, '')
    else
      self.SenderEmailAddress
    end
  end

  def sent_at ; Time.at self.SentTime ; end

  def to_csv
    super.concat [ sent_at, subject, sender, receiver ]
  end

  def self.to_csv
    super.concat [ 'SENT AT', 'SUBJECT', 'SENDER', 'RECEIVER' ]
  end
end
end
