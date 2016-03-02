require 'rails_helper'

RSpec.describe Medium, :type => :model do
  it 'has a valid medium object' do
    medium = build(:medium)
    expect(medium).to be_valid
  end

  it 'is invalid without name' do
    medium = build(:medium, name: nil)
    expect(medium).to be_invalid
  end

  it 'is invalid without user' do
    medium = build(:medium, user: nil)
    expect(medium).to be_invalid
  end

  describe 'has many' do
    before do
      @medium = create(:medium)
      @link = create(:link, medium: @medium)
      @picture = create(:picture, medium: @medium)
    end

    context 'links' do
      it { expect(@medium.links).to include @link }

      it 'that are destroyed when medium is destroyed' do
        link_id = @link.id
        @medium.destroy
        expect { Link.find(link_id) }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'pictures' do
      it { expect(@medium.pictures).to include @picture }

      it 'that are destroyed when medium is destroyed' do
        picture_id = @picture.id
        @medium.destroy
        expect { Picture.find(picture_id) }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  it 'belongs to user' do
    user = create(:user)
    medium = create(:medium, user: user)
    expect(user.media).to include medium
  end
end
