class ProductsController < ApplicationController

    PAGE_NAME = "Product" 

    def select2
      searchValue =  params["q"]
      type =  params["type"]

      getData = Product.select(
        "products.id",
        "products.sku as sku", 
        "products.name as text", 
        "products.stock as stock", 
        "products."+type+" as price", 
      )

      if (type == "price_purchase")
        getData = getData.where("stock <= ?", 0) 
      else
        getData = getData.where("stock > ?", 0) 
      end

      if searchValue && searchValue.length > 0
        getData = getData.where("products.name LIKE ? OR products.sku LIKE ?", "%#{searchValue}%", "%#{searchValue}%")
      end

      render :json => getData.order("name ASC").limit(10)
    end
  
    def datatable
    
      ## Action Buttons ( Addtional Buttons )
      actionButton = ''
      actionButton += '<a href="javascript:void(0);" data-route="'+product_path(:id => 0)+'" class="btn btn-sm btn-success btn-show"><i class="fa fa-search"></i></a>&nbsp;'
      actionButton += '<a href="javascript:void(0);" data-route="'+edit_product_path(:id => 0)+'" class="btn btn-sm btn-info btn-edit"><i class="fa fa-edit"></i></a>&nbsp;'
      actionButton += '<a href="javascript:void(0);" data-route="'+product_path(:id => 0)+'" class="btn btn-sm btn-danger btn-delete"><i class="fa fa-trash"></i></a>&nbsp;'
  
       ## Read value
       draw =  params["draw"]
       row =  params["start"]
       rowperpage = params["length"]
       columnIndex =  params["order"]["0"]["column"]
       columnName =   params["columns"][columnIndex]["name"]
       columnSortOrder = params["order"]["0"]["dir"]
       searchValue =  params["search"]["value"]
  
        ## Total number of records without filtering
        
        getData = Product.select(
          "products.id",
          "products.id as key_id", 
          "products.name as products_name", 
          "products.sku as products_sku", 
          "products.stock as products_stock", 
          "'"+actionButton+"' as action"
        )
  
        totalRecord = getData.count(:all)
  
        ## Total number of records with filtering  
        ## Search
        getFilter = getData
  
        if searchValue.length > 0
          getFilter = getFilter.where("products.name LIKE ? OR products.sku LIKE ?", "%#{searchValue}%", "%#{searchValue}%")
        end
  
  
        totalRecordFilter = getFilter.count(:all)
        getDataOrder =  getFilter.order(columnName+' '+columnSortOrder)
        aaData = getDataOrder.limit(rowperpage).offset(row)
  
      response = {
         :draw => draw,
         :iTotalRecords => totalRecord,
         :iTotalDisplayRecords => totalRecordFilter,
         :aaData => aaData,
         :searchValue => searchValue
      }
  
      render :json => response
    end
    
    def index
      @page_name = PAGE_NAME
    end
  
    def new
      @page_name = PAGE_NAME
      @product = Product.new
      @product.price_purchase = 0
      @product.price_sales = 0
      @product.price_profit = 0
      @product.stock = 0
      @product.date_expired = Time.now.strftime("%Y-%m-%d")
    end
  
    def create
      @product = Product.new(product_params)
      if @product.valid?

        if(params.has_key?(:category_ids))
          categories = Category.find(params[:category_ids])
          @product.categories = categories
        end

        uploaded_io = params[:file_image]
        if uploaded_io
          file_name = uploaded_io.original_filename
          file_ext = File.extname(file_name)
          file_image = SecureRandom.uuid()+""+file_ext
          File.open(Rails.root.join('public', 'uploads', file_image), 'wb') do |file|
            file.write(uploaded_io.read)
            @product.image = "uploads/"+ file_image
          end
        end
      

        @product.save
        flash[:success] = "Record created successfully"
        redirect_to product_path(@product)
      else
        @page_name = PAGE_NAME
        render :new
      end
  
    end
  
    def show
      @page_name = PAGE_NAME
      @product = Product.find(params[:id])
    end
  
    def edit
      @page_name = PAGE_NAME
      @product = Product.find(params[:id])
    end
  
    def update
      @product = Product.find(params[:id])
      @product.update(product_params)
      if @product.valid?

        @product.categories.clear 
        if(params.has_key?(:category_ids))
          categories = Category.find(params[:category_ids])
          @product.categories = categories
        end

        uploaded_io = params[:file_image]
        if uploaded_io

          if(@product.image)
            filename = Rails.root.join('public', @product.image)
            if(File.exist?(filename))
              File.delete(filename) 
            end        
          end
          
          file_name = uploaded_io.original_filename
          file_ext = File.extname(file_name)
          file_image = SecureRandom.uuid()+""+file_ext
          File.open(Rails.root.join('public', 'uploads', file_image), 'wb') do |file|
            file.write(uploaded_io.read)
            @product.image = "uploads/"+ file_image
          end
        end

        @product.update_attributes!(product_params)
        flash[:success] = "Record updated successfully"
        redirect_to product_path(@product)
      else
        @page_name = PAGE_NAME
        render :edit
      end
    end
  
    def destroy
      @product = Product.find(params[:id])

      if(@product.image)
        filename = Rails.root.join('public', @product.image)
        if(File.exist?(filename))
          File.delete(filename) 
        end        
      end

      @product.destroy
      is_ajax =  params["is_ajax"]
      if is_ajax == "y"
        render :json => @product
      else
        flash[:success] = "Record deleted successfully"
        redirect_to products_path
      end

    end
  
    private
      def product_params
        params.permit(:sku, :name, :brand_id, :type_id, :supplier_id, :categories, :price_purchase, :price_sales, :price_profit, :date_expired, :description, :notes, :stock)
      end
  
  end
  