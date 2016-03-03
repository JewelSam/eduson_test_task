require 'rails_helper'

describe 'layouts/application.html.slim' do

  context 'if user is not signed in' do
    before do
      visit '/'
    end

    it 'displays link of main page' do
      expect(page).to have_link(nil, href: '/')
    end

    it 'displays link of login' do
      expect(page).to have_link(nil, href: '/users/sign_in')
    end

    it 'displays links of registration' do
      expect(page).to have_link(nil, href: '/users/sign_up')
    end

    it 'displays only three links' do
      expect(page).to have_selector('header a', count: 3)
    end
  end

  context 'if user is signed in' do
    before do
      user = create(:user)
      login_as(user, scope: :user)
      visit '/'
    end

    it 'displays link of main page' do
      expect(page).to have_link(nil, href: '/')
    end

    it 'displays link of logout' do
      expect(page).to have_link(nil, href: '/users/sign_out')
    end

    it 'displays links of media collections' do
      expect(page).to have_link(nil, href: '/media/user')
    end

    it 'displays only three links' do
      expect(page).to have_selector('header a', count: 3)
    end
  end

end