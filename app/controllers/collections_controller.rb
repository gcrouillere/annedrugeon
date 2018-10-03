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
    @photos_by_3 = @collection.photos.in_groups_of(3).map {|array| array.reject {|item| item == nil}}
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

end
