require 'rails_helper'

RSpec.describe Reading, type: :model do
  let!(:user) { create(:user) }
  let!(:reading) { create(:reading, user_id: user.id) }
  context "valid Factory" do
    it "has a valid factory" do
      expect(reading).to be_valid
    end
  end

  context 'relationships' do
    it { should belong_to(:user) }
  end

  context 'validation' do
    it "raise an exception when more than 4 readings a day" do
      expect { create_list(:reading, 4, user_id: user.id, date: nil) }.to \
        raise_error("Validation failed: You are allowed to put more than 4 readings a day.")
    end
  end
end
