class User < ApplicationRecord
  has_many :readings

  validates :name, :email, :phone, presence: true

  def todays_readings
    self.readings.where(date: Time.now.beginning_of_day)
  end

  def get_report inputs
    report_type = inputs[:report_type] || 'daily'
    date = inputs[:date] || Time.now.to_s
    date =  Time.parse(date).beginning_of_day
    if ['daily', 'monthly', 'from_date'].include?(report_type)
      readings = send("#{report_type}_report".to_sym, date)
      min = readings.minimum(:reading)
      max = readings.maximum(:reading)
      avg = readings.average(:reading).to_f
      return {min: min, max: max, avg: avg}
    else
      raise "Invalid input"
    end
  end

  def daily_report date
    self.readings.where(date: date.beginning_of_day)
  end

  def monthly_report date
    self.readings.where(
      'date >= :start_date and date <= :end_date',
      start_date: date.beginning_of_month,
      end_date: date.end_of_month.beginning_of_day
    )
  end

  def from_date_report date
    self.readings.where('date >= :start_date', start_date: date.beginning_of_month)
  end
end
