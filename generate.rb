require "bundler"
Bundler.require

require_relative "./scclass"
require_relative "./scmethods"
require_relative "./sctutorial"

class Generator
  DOCSET_PATH = "supercollider.docset"
  BASE_PATH = "#{DOCSET_PATH}/Contents/Resources"
  DOCS_PATH = "#{BASE_PATH}/Documents"

  attr_reader :src_path, :db

  def initialize(src_path)
    @src_path = src_path
  end

  def generate!
    prepare_files!
    prepare_db!
    generate_meta!
    generate_docs!
  end

  def prepare_files!
    FileUtils.mkdir_p(DOCS_PATH)
    FileUtils.rm_rf(Dir.glob("#{DOCS_PATH}/*"))
    src_files = Dir.glob("#{src_path}/*")
    FileUtils.cp_r(src_files, DOCS_PATH)
  end

  def prepare_db!
    db_path = "#{BASE_PATH}/docSet.dsidx"
    FileUtils.rm(db_path) if File.exists?(db_path)
    @db = SQLite3::Database.new(db_path)

    db.execute <<-SQL
      CREATE TABLE searchIndex(
        id INTEGER PRIMARY KEY,
        name TEXT,
        type TEXT,
        path TEXT
      );
      CREATE UNIQUE INDEX anchor
        ON searchIndex (name, type, path);
    SQL
  end

  def generate_meta!
    FileUtils.cp("support/Info.plist", "#{DOCSET_PATH}/Contents/Info.plist")
    FileUtils.cp("support/icon.png", "#{DOCSET_PATH}/icon.png")
  end

  def generate_docs!
    js = File.read("#{DOCS_PATH}/docmap.js")
    entry_map = ExecJS.eval(js)
    entry_map.each_pair do |_, entry|
      path = entry["path"]
      next if !File.exists?("#{DOCS_PATH}/#{path}.html")
      if path.start_with?("Classes")
        generate_class_and_methods!(entry)
      elsif path.start_with?("Guides") ||
        path.start_with?("Overviews") ||
        path.start_with?("Reference") ||
        path.start_with?("Tutorials")
        generate_tutorial!(entry)
      end
    end
  end

  def generate_class_and_methods!(entry)
    SCClass.new(db: db, entry: entry).parse!
    SCMethods.new(db: db, entry: entry).parse!
  end

  def generate_tutorial!(entry)
    SCTutorial.new(db: db, entry: entry).parse!
  end
end

src_path = "#{Dir.home}/Library/Application Support/SuperCollider/Help"
Generator.new(src_path).generate!
