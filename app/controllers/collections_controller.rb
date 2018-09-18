class CollectionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @dev_redirection = "https://www.creermonecommerce.fr/product_claim_details"
    @collections = Collection.all
    @ceramiques = Ceramique.where("collection_id IS NOT NULL")
    clean_orders
  end

  def show
    @dev_redirection = "https://www.creermonecommerce.fr/realisations"
    @collection = Collection.find(params[:id])
    @photos_by_3 = @collection.photos.in_groups_of(3)
    @ceramiques = @collection.ceramiques
    clean_orders
  end

  private

  def clean_orders
    Order.all.each do |order|
      if ((Time.now - order.created_at)/60/60 > ENV['BASKETDURATION'].to_f && order.state == "pending" && order.lesson.blank?) || ((Time.now - order.created_at)/60/60 > 24 && order.state == "payment page" && order.lesson.blank?)
        order.basketlines.each do |basketline|
          ceramique = basketline.ceramique
          ceramique.update(stock: ceramique.stock + basketline.quantity)
        end
        if session[:order]
          wip_local_order = Order.find(session[:order])
          session[:order] = nil if order == wip_local_order
        end
        order.update(state: "lost")
      end
    end
  end

  def filter_by_category
    categories = params[:categories].map {|category| "%#{category}%" }
    @ceramiques = @ceramiques.joins(:category).merge(Category.i18n {name.matches_any(categories)})
  end

  def filter_by_price
    @ceramiques = @ceramiques.joins(:offer).where("price_cents * (1 - discount) <= ?", params[:prix_max].to_i * 100) +
                  @ceramiques.where('offer_id IS NULL').where("price_cents <= ?", params[:prix_max].to_i * 100)
  end

  def filter_by_offer
    @ceramiques = @ceramiques.where(offer: @front_offer)
  end

  def filter_globally
    raw_json = Ceramique.raw_search(params[:search])
    ceramiques_ids = raw_json["hits"].map {|hit| hit["objectID"].to_i}
    @ceramiques = @ceramiques.where(id: ceramiques_ids)
  end

end
