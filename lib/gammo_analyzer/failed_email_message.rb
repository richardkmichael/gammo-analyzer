class FailedEmailMessage < FailedMessage
  def_column_alias :subject,  :Subject
  def_column_alias :sender,   :SenderEmailAddress
  def_column_alias :receiver, :ReceiverEmailAddress

  def sent_at ; Time.at self.SentTime ; end

  def human_sender
    sender.gsub(/<.*>/, '')
  end

  def to_csv
    super.concat [ sent_at, "#{human_sender} (#{sender})", receiver, subject ]
  end

  def self.to_csv
    super.concat [ 'SENT AT', 'SENDER', 'SENDER FULL', 'RECEIVER', 'SUBJECT' ]
  end
end
