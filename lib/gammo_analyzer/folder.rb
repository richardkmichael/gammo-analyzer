module GammoAnalyzer
class Folder < Sequel::Model
  one_to_many :messages, :key => :FolderId

  def_column_alias :id,   :FolderId
  def_column_alias :name, :FolderName
  def_column_alias :type, :FolderType

  # FIXME: This is obviously bad; a few attempts below to do this as an association.
  def failed_messages
    DB[:Folders].join(:Messages, :FolderId => :FolderId)
                       .join(:FailedMessages, :MessageRunId => :MessageRunId)
                       .where(:Folders__FolderId => id)
  end

  def failed_messages?
    failed_messages.count > 0
  end

  def to_csv
    [ name, self.messages.count, failed_messages.count ]
  end

  def self.to_csv
    [ 'NAME', 'MESSAGES', "FAILED MESSAGES" ]
  end

# [2] pry(main)> Folder.dataset
# => #<Sequel::SQLite::Dataset: "SELECT * FROM `folders`">

# Sequel::DatabaseError: SQLite3::SQLException: ambiguous column name: main.Messages.MessageRunId
# one_to_many :failed_messages do |dataset|
#   dataset.join(:Messages, :FolderId => :FolderId)
#          .join(:FailedMessages, :MessageRunId => :MessageRunId)
#          .where(:FolderId => id)
# end

# Sequel::DatabaseError: SQLite3::SQLException: no such table: failed_messages
# one_to_many :failed_messages do |dataset|
#   dataset.join(:messages, :FolderId => :FolderId)
#          .join(:failed_messages, :MessageRunId => :MessageRunId)
#          .where(:FolderId => id)
# end

# FIXME: An example of the SQL which retreives the desired data.
# SELECT *
# FROM Folders
#   JOIN Messages
#     ON Messages.FolderId = Folders.FolderId
#   JOIN FailedMessages
#     ON FailedMessages.MessageRunId = Messages.MessageRunId
# WHERE Folders.FolderId = 217;
end
end
