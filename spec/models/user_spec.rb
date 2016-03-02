require 'rails_helper'

RSpec.describe User, :type => :model do
  it 'has a valid user' do
    user = build(:user)
    expect(user).to be_valid
  end

  describe 'has many' do
    before do
      @user = create(:user)
      @medium = create(:medium, user: @user)
    end

    context 'media' do
      it { expect(@user.media).to include @medium }

      it 'that are destroyed when user is destroyed' do
        medium_id = @medium.id
        @user.destroy
        expect { Medium.find(medium_id) }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
