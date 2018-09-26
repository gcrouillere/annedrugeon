class CeramiquesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @dev_redirection = "https://www.creermonecommerce.fr/product_claim_details"
    @ceramiques = Ceramique.all
    Offer.where(showcased: true).first ? (Offer.where(showcased: true).first.ceramiques.present? ? @front_offer = Offer.all.where(showcased: true).first : nil) : nil
    @front_offer ? @ceramiques_to_display_in_offer = Ceramique.all.where(offer: @front_offer) : nil
    clean_orders
    if params[:all].present?
      @ceramiques
    else
      filter_by_category if params[:categories].present?
      filter_by_collection if params[:collections].present?
      filter_by_offer if params[:offer].present?
      filter_globally if params[:search].present?
      filter_by_price if params[:prix_max].present?
    end
    @ceramiques = Ceramique.where(id: @ceramiques.map(&:id)).order(position: :asc).order(updated_at: :desc)
    h1_content
    @twitter_url = request.original_url.to_query('url')
    @facebookid = ""
    render "index_#{@active_theme.name}"
  end

  def show
    session[:zoom_message] ? session[:zoom_message] += 1 : session[:zoom_message] = 0
    @dev_redirection = "https://www.creermonecommerce.fr/produits"
    clean_orders
    @ceramique = Ceramique.find(params[:id])
    @same_category_products = @ceramique.category.ceramiques - [@ceramique]
    @twitter_url = request.original_url.to_query('url')
    render "show_#{@active_theme.name}"
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

  def filter_by_collection
    collections = params[:collections].map {|collection| "%#{collection}%" }
    @ceramiques = @ceramiques.joins(:collection).merge(Collection.i18n {name.matches_any(collections)})
  end

  def filter_by_price
    @ceramiques = @ceramiques.joins(:offer).where("price_cents * (1 - discount) <= ? AND price_cents * (1 - discount) >= ? ", params[:prix_max].to_i * 100, params[:prix_min].to_i * 100) +
                  @ceramiques.where('offer_id IS NULL').where("price_cents <= ? AND price_cents >= ?", params[:prix_max].to_i * 100, params[:prix_min].to_i * 100)
  end

  def filter_by_offer
    @ceramiques = @ceramiques.where(offer: @front_offer)
  end

  def filter_globally
    raw_json = Ceramique.raw_search(params[:search])
    ceramiques_ids = raw_json["hits"].map {|hit| hit["objectID"].to_i}
    @ceramiques = @ceramiques.where(id: ceramiques_ids)
  end

  def h1_content
    @h1_content = ""
    if params[:topcategory].present?
      if params[:categories].present?
       @h1_content << "#{params[:topcategory].upcase} / #{params[:categories].map(&:capitalize).join(' - ')}"
      else
        @h1_content << "#{params[:topcategory].upcase}"
      end
    elsif params[:categories].present?
      @h1_content << "#{params[:categories].map {|cat| Category.i18n.where(name: cat).first.topcategory.name.capitalize}.uniq.join(' - ')} / #{params[:categories].map(&:capitalize).join(' - ')}"
    else
      @h1_content << t(:main_index_h1)
    end
  end
end

