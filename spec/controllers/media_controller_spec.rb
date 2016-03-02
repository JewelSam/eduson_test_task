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
end
