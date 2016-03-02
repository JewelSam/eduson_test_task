require 'rails_helper'

RSpec.describe Link, :type => :model do
  it 'has a valid link' do
    link = build(:link)
    expect(link).to be_valid
  end

  it 'is invalid without url' do
    link = build(:link, url: nil)
    expect(link).to be_invalid
  end

  it 'is invalid without medium' do
    link = build(:link, medium: nil)
    expect(link).to be_invalid
  end

  it 'belongs to medium' do
    medium = create(:medium)
    link = create(:link, medium: medium)
    expect(medium.links).to include (link)
  end
end
