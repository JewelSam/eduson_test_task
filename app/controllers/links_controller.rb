class LinksController < ApplicationController
  before_action :authenticate_user!

  def create
    link = Link.new url: params[:link][:url], medium_id: params[:link][:medium_id]
    authorize! :create, link

    if link.save
      redirect_to :back, notice: t(:success)
    else redirect_to :back, notice: link.errors.full_messages.join(', ')
    end
  end

  def destroy
    link = Link.find(params[:id])
    authorize! :destroy, link

    if link.destroy
      redirect_to :back, notice: t(:success)
    else redirect_to :back, notice: link.errors.full_messages.join(', ')
    end
  end
end
