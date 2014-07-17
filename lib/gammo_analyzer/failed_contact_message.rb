class FailedContactMessage < Message
  def_column_alias :full_name,     :FullName
  def_column_alias :email_address, :EmailAddress
end
