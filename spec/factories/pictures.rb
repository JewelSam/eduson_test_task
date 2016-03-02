include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :picture do
    medium
    image { fixture_file_upload(Rails.root.join('spec', 'factories', 'files', 'cat.jpg'), 'image/jpeg') }
  end
end
