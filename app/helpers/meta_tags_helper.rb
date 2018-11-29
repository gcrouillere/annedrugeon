module MetaTagsHelper
  def meta_title
    content_for?(:title_tag) ? content_for(:title_tag) : "Les bijoux et objets en céramique d'Anne Drugeon"
  end

  def meta_product_name
    content_for?(:meta_product_name) ? content_for(:meta_product_name) : "Les bijoux et objets en céramique d'Anne Drugeon"
  end

  def meta_description
    description = "Toutes les créations sont uniques, découvrez les dans la boutique."
    content_for?(:description) ? content_for(:description) : description
  end

  def meta_image
    meta_image = (content_for?(:meta_image) ? content_for(:meta_image).strip : image_path(ENV['HOMEPIC1']))
    # little twist to make it work equally with an asset or a url
    meta_image.starts_with?("http") ? meta_image : image_url(meta_image)
  end
end

