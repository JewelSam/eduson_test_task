require 'rails_helper'

describe 'devise/sessions/new.html.erb' do
  before do
    @email = Faker::Internet.email
    @password = Faker::Internet.password
    create(:user, email: @email, password: @password)

    visit '/'
    click_on t(:login)
  end

  it 'displays sign in form' do
    expect(page).to have_css('form#new_user')
  end

  it 'allows to sign in' do
    within('#new_user') do
      fill_in 'Email', with: @email
      fill_in 'Password', with: @password
      click_on 'Log in'
    end

    expect(page).to have_content(t(:logout))
  end
end