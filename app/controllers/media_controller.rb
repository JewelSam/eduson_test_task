class MediaController < ApplicationController
  before_action :authenticate_user!, :except => :index

  def index
    @media = Medium.includes(:user).all
  end

  def user
    @media = current_user.media
  end

  def create
    medium = current_user.media.build name: params[:medium][:name]

    if medium.save
      redirect_to :back, notice: t(:success)
    else redirect_to :back, notice: medium.errors.full_messages.join(', ')
    end
  end

  def destroy
    medium = Medium.find(params[:id])
    authorize! :destroy, medium

    medium.destroy
    redirect_to :back, notice: t(:success)
  end
end
