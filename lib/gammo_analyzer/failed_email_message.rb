class FailedEmailMessage < Message
  def_column_alias :subject,  :Subject
  def_column_alias :sender,   :SenderEmailAddress
  def_column_alias :receiver, :ReceiverEmailAddress

  def sent_at ; Time.at self.SentTime ; end

  def human_sender
    self.sender.gsub(/<.*>/, '')
  end
end
