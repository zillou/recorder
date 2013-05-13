class Message < ActiveRecord::Base
  attr_accessible :content, :date, :time
  before_save :set_timestamps
  default_scope order('send_at DESC')

  attr_accessor :date, :time

  validates_presence_of :content

  def set_timestamps
    self.created_at = Time.zone.now
    self.send_at = Time.zone.parse(@date + ' ' + @time)
  end

  def date
    send_at.strftime('%Y-%m-%d') if send_at
  end

  def date=(date)
    @date = date
  end

  def time
    send_at.strftime('%H:%M:%S') if send_at
  end

  def time=(time)
    @time = time
  end
end
