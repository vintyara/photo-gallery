module GalleriesHelper
  def link_to_gallery(gallery, img_size = :small)

    if gallery.photos.blank?
      img_box     = content_tag(:div, 'no-photo', :class => "gallery_thumb gallery_thumb_#{img_size.to_s}")
      label_box   = content_tag(:div, gallery.name, :class => "gallery_name gallery_name_#{img_size.to_s}")
    else
      img_box     = content_tag(:div, image_tag(gallery_random_photo(gallery).url(img_size)), :class => "gallery_thumb gallery_thumb_#{img_size.to_s}")
      label_box   = content_tag(:div, gallery.name, :class => "gallery_name gallery_name_#{img_size.to_s}")
    end

    gallery_box = content_tag(:div, img_box + label_box, :class => "gallery_preview gallery_preview_#{img_size.to_s}")

    link_to user_gallery_path(gallery.user, gallery) do
      gallery_box
    end
  end

  def gallery_random_photo(gallery)
    random_photo_id = gallery.photo_ids.sample #ruby 1.9, 'choice' for 1.8.7
    gallery.photos.where(:id => random_photo_id).first
  end

  def can_gallery_upload?
    return false if current_user.blank?
    return current_user.gallery_ids.include?(@gallery.id)
  end

  def gallery_path_ui
    return unless @gallery
    separator       = ' &raquo; '
    galleries_link  = link_to(t('.galleries'), root_path)
    gallery_name    = @gallery.name
    return [galleries_link, gallery_name].join(separator).html_safe
  end
end
