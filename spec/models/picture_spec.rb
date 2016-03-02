require 'rails_helper'

RSpec.describe Picture, :type => :model do
  it 'has a valid picture' do
    picture = build(:picture)
    expect(picture).to be_valid
  end

  it 'is invalid without image' do
    picture = build(:picture, image: nil)
    expect(picture).to be_invalid
  end

  it 'is invalid with wrong-formatted image' do
    picture = build(:picture, image: File.open('spec/factories/files/doc.pdf'))
    expect(picture).to be_invalid
  end

  it 'is invalid with too big image' do
    picture = build(:picture, image: File.open('spec/factories/files/DSC_0007.JPG'))
    expect(picture).to be_invalid
  end

  it 'is invalid without medium' do
    picture = build(:picture, medium: nil)
    expect(picture).to be_invalid
  end

  it 'belongs to medium' do
    medium = create(:medium)
    picture = create(:picture, medium: medium)
    expect(medium.pictures).to include picture
  end
end
