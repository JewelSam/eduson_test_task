require 'rails_helper'

describe 'media/user.html.slim' do
  before do
    user = create(:user)

    create(:medium, name: 'name_1', user: user)
    create(:medium, name: 'name_2', user: user)

    login_as(user, scope: :user)
    visit '/'
    click_on t(:my_collections)
  end

  it 'displays all media' do
    expect(page).to have_content('name_1')
    expect(page).to have_content('name_2')
    expect(page).to have_selector('.medium > a', count: 2)
  end

  it 'has form of create medium' do
    within('#new_medium') do
      fill_in 'medium_name', with: 'new_name'
    end
    click_on t('helpers.submit.create', model: t('activerecord.models.medium'))

    expect(page).to have_content('new_name')
    expect(page).to have_selector('.medium > a', count: 3)
  end

  it 'has destroy link' do
    medium = Medium.find_by(name: 'name_1')

    find(".medium .actions a[href*='/#{medium.id}']").click
    expect(page).not_to have_content('name_1')
    expect(page).to have_selector('.medium > a', count: 1)
  end
end