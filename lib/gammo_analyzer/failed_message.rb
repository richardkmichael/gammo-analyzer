class FailedMessage < Message
  def_column_alias :error, :ErrorDesc
  def_column_alias :request, :Request
  def_column_alias :response, :Response

  def error_code    ; "0x#{error.split(':').last}" ; end
  def error_message ; error.split(',').first       ; end
  def failed_at     ; Time.at self.FailureTime     ; end

  def to_csv
    super.concat [ failed_at, error_code, error_message ]
  end

  def self.to_csv
    super.concat [ 'FAILED AT', 'ERROR CODE', 'ERROR_MESSAGE' ]
  end
end
