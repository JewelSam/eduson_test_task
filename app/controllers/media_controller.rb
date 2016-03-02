class MediaController < ApplicationController
  def index
    @media = Medium.includes(:user).all
  end
end
