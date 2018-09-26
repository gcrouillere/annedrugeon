ActiveAdmin.register Topcategory do
  permit_params :name
  config.filters = false
  actions  :index, :new, :create, :destroy, :update, :edit
  menu priority: 2, url: -> { admin_topcategories_path(locale: I18n.locale) }

  index do
    column :name
    actions
  end

  form do |f|
    f.inputs "" do
      f.input :name
    end
    f.actions
   end

  controller do

   def create
      super do |format|
        redirect_to admin_topcategories_path and return if resource.valid?
      end
    end

    def destroy
      topcategory = Topcategory.find(params[:id].to_i)
      categories = topcategory.categories.size
      if categories > 0
        flash[:alert] = "Cette catégorie est toujours utilisée dans des sous catégories. Impossible de la supprimer."
        redirect_to admin_topcategories_path and return
      end
      super do |format|
        redirect_to admin_topcategories_path and return if resource.valid?
      end
    end

    def update
      super do |format|
        redirect_to admin_topcategories_path and return if resource.valid?
      end
    end

  end

end
