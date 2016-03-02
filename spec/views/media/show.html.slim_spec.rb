require 'rails_helper'

RSpec.describe 'media/show.html.slim', :type => :view do
  before do
    user = create(:user)

    medium_1 = create(:medium, name: 'name_1', user: user)
    medium_2 = create(:medium, user: user)

    create(:picture, medium: medium_1, image: File.open('spec/factories/files/cat.jpg'))
    create(:picture, medium: medium_1, image: File.open('spec/factories/files/photo.jpg'))

    create(:link, medium: medium_1, url: 'url_1')
    create(:link, medium: medium_1, url: 'url_2')

    login_as(user, scope: :user)
    visit '/'
    click_on t(:my_collections)
    click_on 'name_1'
  end

  describe 'in pictures area' do
    it 'displays all pictures' do
      expect(page).to have_css('.picture img[src*="cat.jpg"]')
      expect(page).to have_css('.picture img[src*="photo.jpg"]')
      expect(page).to have_selector('.picture img', count: 2)
    end

    context 'if user is signed in' do
      it 'has form of create picture' do
        page.attach_file('picture_image', 'spec/factories/files/photo2.jpg')
        click_on t('helpers.submit.create', model: t('activerecord.models.picture.one'))

        expect(page).to have_css('.picture img[src*="photo2.jpg"]')
        expect(page).to have_selector('.picture img', count: 3)
      end

      it 'has destroy link' do
        picture = Picture.where('image_file_name LIKE ?', '%cat.jpg%').first

        find(".picture .actions a[href*='/#{picture.id}']").click
        expect(page).not_to have_css('.picture img[src*="cat.jpg"]')
        expect(page).to have_selector('.picture img', count: 1)
      end
    end

    context 'if user is not signed in' do
      before do
        click_on t(:logout)
        click_on 'name_1'
      end

      it 'has not form' do
        expect(page).not_to have_css('form#new_picture')
      end

      it 'has not destroy link' do
        expect(page).not_to have_css('.picture .actions a')
      end
    end

    context 'if user is signed in but is not owner' do
      before do
        click_on t(:logout)
        user = create(:user)
        login_as(user, scope: :user)
        visit '/'
        click_on 'name_1'
      end

      it 'has not form' do
        expect(page).not_to have_css('form#new_picture')
      end

      it 'has not destroy link' do
        expect(page).not_to have_css('.picture .actions a')
      end
    end

  end

  describe 'in links area' do
    it 'displays all links' do
      expect(page).to have_css('.link a[href*="url_1"]')
      expect(page).to have_css('.link a[href*="url_2"]')
      expect(page).to have_selector('.link > a', count: 2)
    end

    context 'if user is signed in' do
      it 'has form of create link' do
        within '#new_link' do
          fill_in 'link_url', with: 'new_url'
        end
        click_on t('helpers.submit.create', model: t('activerecord.models.link.one'))

        expect(page).to have_css('.link a[href*="new_url"]')
        expect(page).to have_selector('.link > a', count: 3)
      end

      it 'has destroy link' do
        link = Link.find_by(url: 'url_1')

        find(".link .actions a[href*='/#{link.id}']").click
        expect(page).not_to have_css('.link a[href*="url_1"]')
        expect(page).to have_selector('.link > a', count: 1)
      end
    end

    context 'if user is not signed in' do
      before do
        click_on t(:logout)
        click_on 'name_1'
      end

      it 'has not form' do
        expect(page).not_to have_css('form#new_link')
      end

      it 'has not destroy link' do
        expect(page).not_to have_css('.link .actions a')
      end
    end

    context 'if user is signed in but is not owner' do
      before do
        click_on t(:logout)
        user = create(:user)
        login_as(user, scope: :user)
        visit '/'
        click_on 'name_1'
      end

      it 'has not form' do
        expect(page).not_to have_css('form#new_picture')
      end

      it 'has not destroy link' do
        expect(page).not_to have_css('.picture .actions a')
      end
    end

  end

end