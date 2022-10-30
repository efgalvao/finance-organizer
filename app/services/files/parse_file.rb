module Files
class ParseFile
  def initialize(file)
    @file = file
  end

  def self.call(file)
    new(file).call
  end

  def call
    parse_file
  end

  private

  attr_reader :file

  def parse_file
    if file.content_type == "application/json"
      Files::JsonParser.call(file)
    end
  end
end
end
