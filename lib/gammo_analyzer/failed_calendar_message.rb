class FailedCalendarMessage < Message
  def_column_alias :title,     :Title
  def_column_alias :organizer, :Organizer
  def_column_alias :attendees, :Attendees

  def start_at  ; Time.at self.StartTime ; end
  def end_at    ; Time.at self.EndTime   ; end
end
