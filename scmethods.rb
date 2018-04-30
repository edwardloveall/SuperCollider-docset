require "uri"

class SCMethods
  DOC_PATH = "supercollider.docset/Contents/Resources/Documents"
  attr_reader :db, :entry

  def initialize(db:, entry:)
    @db = db
    @entry = entry
  end

  def parse!
    return if entry["methods"].empty?

    entry["methods"].each do |name|
      insert_method(name)
      insert_anchor(name)
    end

    File.write("#{DOC_PATH}/#{entry["path"]}.html", @doc.to_html)
  end

  def insert_method(name)
    method_name = strip_name_symbols(name)
    anchor = anchor_from_name(name)
    file_path = "#{entry["path"]}.html##{anchor}"
    statement = db.prepare <<-SQL
      INSERT OR IGNORE INTO
        searchIndex(name, type, path)
        VALUES (?, ?, ?);
    SQL
    statement.execute(name, "Method", file_path)
  end

  def strip_name_symbols(name)
    name.sub(/\A[\?\_][\*\-]/, "")
  end

  def anchor_from_name(name)
    name.sub(/\A[\?\_]/, "")
  end

  def insert_anchor(name)
    @html ||= File.read("#{DOC_PATH}/#{entry["path"]}.html")
    @doc ||= Nokogiri::HTML(@html)
    name_attr = anchor_from_name(name)
    escaped_name = URI.escape(strip_name_symbols(name))
    current_anchor = @doc.at(".method-name[name='#{name_attr}']")
    return if current_anchor.nil?
    dash_anchor = Nokogiri::XML::Node.new "a", @doc
    dash_anchor.set_attribute("name", "//apple_ref/cpp/Method/#{escaped_name}")
    dash_anchor.set_attribute("class", "dashAnchor")

    current_anchor.before(dash_anchor)
  end
end
