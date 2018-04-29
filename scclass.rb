class SCClass
  attr_reader :db, :entry

  def initialize(db:, entry:)
    @db = db
    @entry = entry
  end

  def parse!
    name = entry["title"]
    file_path = "#{entry["path"]}.html"

    statement = db.prepare <<-SQL
      INSERT OR IGNORE INTO
        searchIndex(name, type, path)
        VALUES (?, ?, ?);
    SQL
    statement.execute(name, "Class", file_path)
  end
end
