class CategoriesController < ApplicationController

    PAGE_NAME = "Category" 
  
    def datatable
    
      ## Action Buttons ( Addtional Buttons )
      actionButton = ''
      actionButton += '<a href="javascript:void(0);" data-route="'+category_path(:id => 0)+'" class="btn btn-sm btn-success btn-show"><i class="fa fa-search"></i></a>&nbsp;'
      actionButton += '<a href="javascript:void(0);" data-route="'+edit_category_path(:id => 0)+'" class="btn btn-sm btn-info btn-edit"><i class="fa fa-edit"></i></a>&nbsp;'
      actionButton += '<a href="javascript:void(0);" data-route="'+category_path(:id => 0)+'" class="btn btn-sm btn-danger btn-delete"><i class="fa fa-trash"></i></a>&nbsp;'
  
       ## Read value
       draw =  params["draw"]
       row =  params["start"]
       rowperpage = params["length"]
       columnIndex =  params["order"]["0"]["column"]
       columnName =   params["columns"][columnIndex]["name"]
       columnSortOrder = params["order"]["0"]["dir"]
       searchValue =  params["search"]["value"]
  
        ## Total number of records without filtering
        
        getData = Category.select(
          "categories.id",
          "categories.id as key_id", 
          "categories.name as categories_name", 
          "categories.description as categories_description", 
          "'"+actionButton+"' as action"
        )
  
        totalRecord = getData.count(:all)
  
        ## Total number of records with filtering  
        ## Search
        getFilter = getData
  
        if searchValue.length > 0
          getFilter = getFilter.where("categories.name LIKE ? OR categories.description LIKE ?", "%#{searchValue}%", "%#{searchValue}%")
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
      @category = Category.new
    end
  
    def create
      @category = Category.new(category_params)
  
      if @category.valid?
        @category.save
        flash[:success] = "Record created successfully"
        redirect_to category_path(@category)
      else
        @page_name = PAGE_NAME
        render :new
      end
  
    end
  
    def show
      @page_name = PAGE_NAME
      @category = Category.find(params[:id])
    end
  
    def edit
      @page_name = PAGE_NAME
      @category = Category.find(params[:id])
    end
  
    def update
      @category = Category.find(params[:id])
      @category.update(category_params)
      if @category.valid?
        @category.update_attributes!(category_params)
        flash[:success] = "Record updated successfully"
        redirect_to category_path(@category)
      else
        @page_name = PAGE_NAME
        render :edit
      end
    end
  
    def destroy
      @category = Category.find(params[:id])
      @category.destroy
      is_ajax =  params["is_ajax"]
      if is_ajax == "y"
        render :json => @category
      else
        flash[:success] = "Record deleted successfully"
        redirect_to categories_path
      end
    end
  
    private
      def category_params
        params.permit(:name, :description)
      end
  
  end
  