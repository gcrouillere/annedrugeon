ActiveAdmin.register Collection, as: 'Collections' do
  permit_params :name, :description, :ceramique_id, photos: []
  actions  :index, :destroy, :update, :edit, :show, :new, :create
  menu priority: 4
  config.filters = false

  index do
    column :name
    column :description
    column "Produits" do |collection|
      collection.ceramiques.map {|ceramique| ceramique.name}.join(', ')
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row "Produits contenus dans la collection" do |collection|
        Ceramique.all.where(collection: collection).map {|ceramique| ceramique.name}.join(", ")
      end
      row :images do |collection|
        collection.photos.each do |photo|
          span img(src: "http://res.cloudinary.com/#{ENV['CLOUDINARY_NAME']}/image/upload/#{photo.path}")
        end
      end
    end
  end

  form do |f|
    f.inputs "" do
      f.input :name
      f.input :description
      f.input :photos, :as => :formtastic_attachinary, :hint => "Sélectionnez les photos de la collection. Maintenez Ctrl appuyé pour en sélectionner plusieurs."
      f.input :ceramiques, as: :check_boxes, :label => "Produits", :hint => "Sélectionnez les produits inclus dans la collection."
    end
    f.actions
  end

  controller do

    def create
      super do |format|
        if resource.valid?
          flash[:notice] = "Collection créée"
          ceramiques_collection_assignment
        end
        redirect_to admin_collections_path and return if resource.valid?
      end
    end

    def update
      super do |format|
        if resource.valid?
          flash[:notice] = "Collection mise à jour"
          ceramiques_collection_assignment
        end
        redirect_to admin_collections_path and return if resource.valid?
      end
    end

    def destroy
      super do |format|
        flash[:notice] = "Collection supprimée"
        redirect_to admin_collections_path and return if resource.valid?
      end
    end

    # Helper methods
    def ceramiques_collection_assignment
      params["action"] == "create" ? current_collection = Collection.last : current_collection = Collection.find(params[:id])
      ceramiques_ids_with_collection = params["collection"]["ceramique_ids"].select{|s| s != ""}.map {|s| s.to_i}
      ceramiques_ids_with_collection.each do |id|
        Ceramique.find(id).update(collection: current_collection)
      end
      ceramiques_ids_without_collection = Ceramique.all.map {|ceramique| ceramique.id} - ceramiques_ids_with_collection
      ceramiques_ids_without_collection.each do |id|
        if Ceramique.find(id).collection == current_collection
          Ceramique.find(id).update(collection_id: nil)
        end
      end
    end

  end

end
