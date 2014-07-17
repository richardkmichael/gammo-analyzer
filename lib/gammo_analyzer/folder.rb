class Folder < Sequel::Model
  one_to_many :messages, :key => :FolderId

  def_column_alias :id,   :FolderId
  def_column_alias :name, :FolderName
  def_column_alias :type, :FolderType
end
