require 'rails_helper'

RSpec.describe 'media/index.html.slim', :type => :view do
  before do
    user_1 = create(:user, email: 'email_1@example.com')
    user_2 = create(:user, email: 'email_2@example.com')

    assign(:media, [
                     create(:medium, user: user_1, name: 'name_1'),
                     create(:medium, user: user_2, name: 'name_2')
                 ])
  end

  it 'displays all media' do
    render

    expect(rendered).to match /name_1/
    expect(rendered).to match /name_2/
  end

  it 'displays media owner email' do
    render

    expect(rendered).to have_selector('.medium:eq(1)', text: /name_1/)
    expect(rendered).to have_selector('.medium:eq(1)', text: /email_1@example.com/)
  end
end