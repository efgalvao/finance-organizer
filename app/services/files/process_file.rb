module Files
  class ProcessFile
    def initialize(file, user_id)
      @file = file
      @user_id = user_id
    end

    def self.call(file, user_id)
      new(file, user_id).call
    end

    def call
      content = parse_file
      process_file(content)
    end

    private

    attr_reader :file, :user_id

    def parse_file
      Files::JsonParser.call(file) if file.content_type == 'application/json'
    end

    def process_file(content)
      Files::ProcessContent.call(content, user_id)
    end
  end
end
