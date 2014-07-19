class FailedContactMessage < FailedMessage
  def_column_alias :full_name,     :FullName
  def_column_alias :email_address, :EmailAddress

  def to_csv
    super.concat [ full_name, email_address ]
  end

  def self.to_csv
    super.concat [ 'FULL NAME', 'EMAIL ADDRESS' ]
  end
end
