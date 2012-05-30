class PhotosController < ApplicationController

  before_filter :authenticate_user!, :except => [:list, :show, :find_by_identifier]

  def new
    @gallery  = Gallery.find_by_url_name(params[:gallery_id])
    @photo    = Photo.new()
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def find_by_identifier
    photo_identifier = params[:identifier][1..params[:identifier].length]

    begin
      @photo = Gallery.find_by_url_name(params[:gallery_id]).photos.where('identifier = ?', photo_identifier).first
    rescue
      @photo = Gallery.find_by_url_name(params[:gallery_id]).photos.first
    end

    respond_to do |format|
      format.js { render 'show' }
    end
  end

  def create
    @gallery  = Gallery.find_by_url_name(params[:gallery_id])
    @photo    = @gallery.photos.build(params[:photo].merge!(:user_id => current_user.id))
    @photo.save ? redirect_to(user_gallery_path(current_user, @gallery)) : redirect_to(action => :new)
  end

  def destroy
    @photo = Photo.find(params[:id])
    @gallery = @photo.gallery
    @photo.destroy
    redirect_to user_gallery_path(current_user, @gallery)
  end

end
