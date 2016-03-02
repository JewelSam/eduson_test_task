require 'rails_helper'

RSpec.describe LinksController, :type => :controller do
  describe 'POST create' do
    before do
      request.env['HTTP_REFERER'] = 'where_i_came_from'
      @medium = create(:medium)
      sign_in @medium.user
    end

    it 'is not available without signing in' do
      sign_out @medium.user
      post :create, link: attributes_for(:link).merge(medium_id: @medium.id)

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/users/sign_in')
    end

    it 'is not available if medium object is not user\'s' do
      another_user_medium = create(:medium)
      expect { post :create, link: attributes_for(:link).merge(medium_id: another_user_medium.id) }
          .to raise_error CanCan::AccessDenied
    end

    it 'creates link object if valid' do
      expect(@medium.links.count).to be 0

      post :create, link: attributes_for(:link, url: 'example.com').merge(medium_id: @medium.id)

      expect(@medium.links.count).to be 1
      expect(@medium.links.first.url).to eq('example.com')
    end

    it 'redirect to back' do
      post :create, link: attributes_for(:link).merge(medium_id: @medium.id)
      expect(response).to redirect_to('where_i_came_from')
    end

    it 'returns errors if invalid' do
      post :create, link: attributes_for(:link, url: nil).merge(medium_id: @medium.id)
      expect(response).to redirect_to('where_i_came_from')
      expect(flash[:notice]).to match /#{I18n.t('activerecord.attributes.link.url')}/
    end
  end

  describe 'DELETE destroy' do
    before do
      request.env['HTTP_REFERER'] = 'where_i_came_from'
      @medium = create(:medium)
      @link = create(:link, medium: @medium)
      sign_in @medium.user
    end

    it 'is not available without signing in' do
      sign_out @medium.user
      delete :destroy, id: @link.id

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/users/sign_in')
    end

    it 'is not available if link object is not user\'s' do
      another_user_link = create(:link)
      expect { delete :destroy, id: another_user_link.id }.to raise_error CanCan::AccessDenied
    end

    it 'destroy link object' do
      expect(@medium.links.count).to be 1
      delete :destroy, id: @link.id
      expect(@medium.links.first).to be_nil
    end

    it 'redirect to back' do
      delete :destroy, id: @link.id
      expect(response).to redirect_to('where_i_came_from')
    end
  end
end
