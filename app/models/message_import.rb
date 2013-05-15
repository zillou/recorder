class MessageImport
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file
  
  validates_presence_of :file

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported_messages.map(&:valid?).all?
      imported_messages.each(&:save!)
      true
    else
      imported_messages.each_with_index do |message, index|
        message.errors.full_messages.each do |error|
          errors.add :base, "Row #{index+2}: #{error}"
        end
      end
      false
    end
  end

  def imported_messages
    @imported_messages ||= load_imported_messages
  end

  def load_imported_messages
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      send_at = Time.zone.parse(row["Send at"])
      puts "imported message #{row["Content"]} - #{send_at}"
      message = Message.find_by_content_and_send_at(row["Content"], send_at) || Message.new
      message.content = row["Content"]
      message.send_at = send_at
      message
    end
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unkown file type: #{file.original_filename}"
    end
  end
end
