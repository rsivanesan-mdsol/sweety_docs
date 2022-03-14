require 'rails_helper'

RSpec.describe User, type: :model do

  let!(:user) { create(:user) }
  context "valid Factory" do
    it "has a valid factory" do
      expect(FactoryBot.build(:user)).to be_valid
    end
  end

  context "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :phone }

    it "is valid with valid attributes" do
      puts user.name
      expect(user).to be_valid
    end

    it "is not valid without a name" do
      user.name = nil
      expect(user).to_not be_valid
    end

    it "is not valid without an email" do
      user.email = nil
      expect(user).to_not be_valid
    end
  end

  context 'relationships' do
    it { should have_many(:readings) }
  end

  def common_report(dates, report_type, time)
    dates.each_with_index do |t, i|
      create(:reading, reading: i, date: t, user_id: user.id)
    end
    user.get_report({report_type: report_type, date: time.to_s})
  end

  context 'method invoke' do
    it "return associated readings at only today when invoked todays_readings method" do
      create_list(:reading, 3, user_id: user.id)
      readings = user.todays_readings
      expect(readings.present?).to eq(true)
    end

    it "return only daily report when invoked get_report" do
      time = Time.now
      dates = [time.beginning_of_day, time.middle_of_day,  time.end_of_day]
      daily_report = common_report(dates,'daily', time)
      expect(daily_report.is_a?(Hash)).to be_truthy
      expect(daily_report).to eq({:min=>0, :max=>2, :avg=>1.0})
    end

    it "return monthly report when invoked get_report" do
      time = Time.now
      dates = [time.beginning_of_month, time.end_of_month.beginning_of_day]
      daily_report = common_report(dates,'monthly', time)
      expect(daily_report.is_a?(Hash)).to be_truthy
      expect(daily_report).to eq({:min=>0, :max=>1, :avg=>0.5})
    end

    it "return beginning of month report when invoked get_report" do
      time = Time.now
      dates = [time.beginning_of_month, time.months_since(-1).beginning_of_month, time.end_of_day]
      daily_report = common_report(dates,'from_date', time)
      expect(daily_report.is_a?(Hash)).to be_truthy
      expect(daily_report).to eq({:min=>0, :max=>2, :avg=>1.0})
    end

    it "raises the invalid imput message" do
      expect { user.get_report({report_type: 'month', date: Time.now.to_s}) }.to raise_error('Invalid input')
    end
  end
end
