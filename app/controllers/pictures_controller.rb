class PicturesController < ApplicationController
  before_action :authenticate_user!

  def create
    picture = Picture.new image: params[:picture][:image], medium_id: params[:picture][:medium_id]
    authorize! :create, picture

    if picture.save
      redirect_to :back, notice: t(:success)
    else redirect_to :back, notice: picture.errors.full_messages.join(', ')
    end
  end

  def destroy
    picture = Picture.find(params[:id])
    authorize! :destroy, picture

    if picture.destroy
      redirect_to :back, notice: t(:success)
    else redirect_to :back, notice: picture.errors.full_messages.join(', ')
    end
  end
end
