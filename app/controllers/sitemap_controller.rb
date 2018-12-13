class SitemapController < ApplicationController
  layout nil
  skip_before_action :authenticate_user!, only: [:sitemap]

  def sitemap
    @ceramiques = Ceramique.where(active: true)
    @collections = Collection.all
    @sellpoint = Article.where("name LIKE ? OR name LIKE ?", "sellpoint", "ephemeral").order(updated_at: :desc).first
    @info_article = Article.where("name LIKE ?", "%info%").order(updated_at: :desc).first
  end
end
