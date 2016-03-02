require 'rails_helper'

RSpec.describe PicturesController, :type => :controller do
  describe 'POST create' do
    before do
      request.env['HTTP_REFERER'] = 'where_i_came_from'
      @medium = create(:medium)
      sign_in @medium.user
    end

    it 'is not available without signing in' do
      sign_out @medium.user
      post :create, picture: attributes_for(:picture).merge(medium_id: @medium.id)

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/users/sign_in')
    end

    it 'is not available if medium object is not user\'s' do
      another_user_medium = create(:medium)

      expect { post :create, picture: attributes_for(:picture).merge(medium_id: another_user_medium.id) }
          .to raise_error CanCan::AccessDenied
    end

    it 'creates link object if valid' do
      expect(@medium.pictures.count).to be 0

      image = Rack::Test::UploadedFile.new("spec/factories/files/cat.jpg", 'image/jpeg')
      post :create, picture: attributes_for(:picture, image: image).merge(medium_id: @medium.id)

      expect(@medium.pictures.count).to eq 1

      expect(Digest::MD5.hexdigest(File.read('public' + @medium.pictures.first.image.url(:original, timestamp: false))))
          .to eq(Digest::MD5.hexdigest(File.read('spec/factories/files/cat.jpg')))
    end

    it 'redirect to back' do
      post :create, picture: attributes_for(:picture).merge(medium_id: @medium.id)
      expect(response).to redirect_to('where_i_came_from')
    end

    it 'returns errors if invalid' do
      post :create, picture: attributes_for(:picture, image: nil).merge(medium_id: @medium.id)
      expect(response).to redirect_to('where_i_came_from')
      expect(flash[:notice]).to match /#{I18n.t('activerecord.attributes.picture.image')}/
    end
  end

  describe 'DELETE destroy' do
    before do
      request.env['HTTP_REFERER'] = 'where_i_came_from'
      @medium = create(:medium)
      @picture = create(:picture, medium: @medium)
      sign_in @medium.user
    end

    it 'is not available without signing in' do
      sign_out @medium.user
      delete :destroy, id: @picture.id

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/users/sign_in')
    end

    it 'is not available if picture object is not user\'s' do
      another_user_picture = create(:picture)
      expect { delete :destroy, id: another_user_picture.id }.to raise_error CanCan::AccessDenied
    end

    it 'destroy picture object' do
      expect(@medium.pictures.count).to be 1
      delete :destroy, id: @picture.id
      expect(@medium.pictures.first).to be_nil
    end

    it 'redirect to back' do
      delete :destroy, id: @picture.id
      expect(response).to redirect_to('where_i_came_from')
    end
  end
end
