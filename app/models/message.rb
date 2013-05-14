class Message < ActiveRecord::Base
  attr_accessible :content, :date, :time
  before_save :set_timestamps
  default_scope order('send_at DESC')

  attr_accessor :date, :time

  composed_of :date,
    :class_name => 'Date',
    :mapping => %w(Date to_s),
    :constructor => Proc.new { |date| (date && date.to_date) || Date.today },
    :converter => Proc.new { |value| value.to_s.to_date }

  validates_presence_of :content

  def set_timestamps
    self.created_at = Time.zone.now
    self.send_at = Time.zone.parse(@date + ' ' + @time)
  end

  def date
    send_at.to_date if send_at
  end

  def date=(date)
    @date = date.strftime('%Y-%m-%d')
  end

  def time
    send_at.strftime('%H:%M:%S') if send_at
  end

  def time=(time)
    @time = time
  end
end
