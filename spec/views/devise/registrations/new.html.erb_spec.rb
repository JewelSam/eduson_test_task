require 'rails_helper'

describe 'devise/registrations/new.html.erb' do
  before do
    @email = Faker::Internet.email
    @password = Faker::Internet.password

    visit '/'
    click_on t(:sign_up)
  end

  it 'displays sign up form' do
    expect(page).to have_css('form#new_user')
  end

  context 'allows to sign up' do
    before do
      within('#new_user') do
        fill_in 'Email', with: @email
        fill_in 'Password', with: @password
        fill_in 'Password confirmation', with: @password
        click_on t(:sign_up)
      end
    end

    it 'creates new user' do
      user = User.find_by(email: @email)
      expect(user).not_to be_nil
    end

    it 'sign in after sign up' do
      expect(page).to have_content(t(:logout))
    end

    it 'can sign in after logout with this email and this password' do
      click_on t(:logout)
      click_on t(:login)
      within('#new_user') do
        fill_in 'Email', with: @email
        fill_in 'Password', with: @password
        click_on t(:login)
      end
      expect(page).to have_content(t(:logout))
    end
  end
end