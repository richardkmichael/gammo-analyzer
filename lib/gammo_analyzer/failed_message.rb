class FailedMessage < Message
  def_column_alias :error, :ErrorDesc

  def error_code    ; error.split(':').last    ; end
  def error_message ; error.split(',').first   ; end
  def failed_at     ; Time.at self.FailureTime ; end
end
