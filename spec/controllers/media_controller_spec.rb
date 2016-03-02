require 'rails_helper'

RSpec.describe MediaController, :type => :controller do
  describe 'GET index' do
    it 'assigns @media' do
      medium = create(:medium)
      get :index
      expect(assigns(:media)).to eq([medium])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET user' do
    before do
      @medium = create(:medium)
      another_user_medium = create(:medium)
      sign_in @medium.user
    end

    it 'assigns @media' do
      get :user
      expect(assigns(:media)).to eq([@medium])
    end

    it 'renders the user template' do
      get :user
      expect(response).to render_template('user')
    end

    it 'is not available without signing in' do
      sign_out @medium.user
      get :user
      expect(response).not_to render_template('user')
    end
  end

  describe 'POST create' do
    before do
      request.env['HTTP_REFERER'] = 'where_i_came_from'
      @user = create(:user)
      sign_in @user
    end

    it 'is not available without signing in' do
      sign_out @user
      post :create, medium: attributes_for(:medium)

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/users/sign_in')
    end

    it 'creates medium object if valid' do
      expect(@user.media.pluck(:name)).to eq([])
      post :create, medium: attributes_for(:medium, name: 'name')
      expect(@user.media.pluck(:name)).to eq(['name'])
    end

    it 'redirect to back' do
      post :create, medium: attributes_for(:medium)
      expect(response).to redirect_to('where_i_came_from')
    end

    it 'returns errors if invalid' do
      post :create, medium: attributes_for(:medium, name: nil)
      expect(response).to redirect_to('where_i_came_from')
      expect(flash[:notice]).to match /#{I18n.t('activerecord.attributes.medium.name')}/
    end
  end

  describe 'DELETE destroy' do
    before do
      request.env['HTTP_REFERER'] = 'where_i_came_from'
      @medium = create(:medium)
      sign_in @medium.user
    end

    it 'is not available without signing in' do
      sign_out @medium.user
      delete :destroy, id: @medium.id

      expect(response.status).to eq(302)
      expect(response).to redirect_to('/users/sign_in')
    end

    it 'is not available if medium object is not user\'s' do
      another_user_medium = create(:medium)
      expect { delete :destroy, id: another_user_medium.id }.to raise_error CanCan::AccessDenied
    end

    it 'destroy medium object' do
      user = @medium.user

      expect(user.media.count).to be 1
      delete :destroy, id: @medium.id
      expect(user.media.first).to be_nil
    end

    it 'redirect to back' do
      delete :destroy, id: @medium.id
      expect(response).to redirect_to('where_i_came_from')
    end
  end

  describe 'GET show' do
    before do
      @medium = create(:medium)
      get :show, id: @medium.id
    end

    it 'assigns @medium' do
      expect(assigns(:medium)).to eq(@medium)
    end

    it 'renders the show template' do
      expect(response).to render_template('show')
    end
  end
end
