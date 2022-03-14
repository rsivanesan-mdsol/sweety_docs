class Reading < ApplicationRecord
  belongs_to :user

  scope :todays_readings, -> { where(date: Time.now.beginning_of_day)}
 
  before_validation :validate_per_user_per_day_reading

  private
  def validate_per_user_per_day_reading
    self.date = Time.now.beginning_of_day
    readings = self.class.where(
      user_id: self.user_id,
      date: self.date
    ).count
    puts "readings #{readings}"
    if readings >= 4
      self.errors[:base] << "You are allowed to put more than 4 readings a day."
      return false
    end
  end
end
