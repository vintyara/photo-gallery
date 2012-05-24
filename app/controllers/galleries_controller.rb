class GalleriesController < ApplicationController

  before_filter :authenticate_user!, :except => [:show]

  def show
    @gallery  = Gallery.find(params[:id])
    @photos   = @gallery.photos
  end

  def new

  end

  def create
    @gallery = current_user.galleries.build(params[:gallery])
    if @gallery.save
      redirect_to user_gallery_path(current_user, @gallery)
    end
  end
end