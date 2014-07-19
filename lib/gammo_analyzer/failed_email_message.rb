class FailedEmailMessage < FailedMessage
  def_column_alias :subject,  :Subject
  def_column_alias :sender,   :SenderEmailAddress
  def_column_alias :receiver, :ReceiverEmailAddress

  def sent_at ; Time.at self.SentTime ; end

  def human_sender
    sender.gsub(/<.*>/, '')
  end

  def to_csv
    super.concat [ "#{human_sender} (#{sender})", receiver, sent_at, subject ]
  end

  def self.csv_header
    super.concat [ 'SENDER', 'SENDER FULL', 'RECEIVER', 'SENT AT', 'SUBJECT' ]
  end
end
