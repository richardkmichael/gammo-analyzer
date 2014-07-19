class FailedCalendarMessage < FailedMessage
  def_column_alias :title,     :Title
  def_column_alias :organizer, :Organizer
  def_column_alias :attendees, :Attendees

  def start_at  ; Time.at self.StartTime ; end
  def end_at    ; Time.at self.EndTime   ; end

  def to_csv
    super.concat [ title, organizer, attendees ]
  end

  def self.to_csv
    super.concat [ 'TITLE', 'ORGANIZER', 'ATTENDEES' ]
  end
end
