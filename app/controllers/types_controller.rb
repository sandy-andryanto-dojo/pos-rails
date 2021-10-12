class TypesController < ApplicationController

    PAGE_NAME = "Type" 
  
    def datatable
    
      ## Action Buttons ( Addtional Buttons )
      actionButton = ''
      actionButton += '<a href="javascript:void(0);" data-route="'+type_path(:id => 0)+'" class="btn btn-sm btn-success btn-show"><i class="fa fa-search"></i></a>&nbsp;'
      actionButton += '<a href="javascript:void(0);" data-route="'+edit_type_path(:id => 0)+'" class="btn btn-sm btn-info btn-edit"><i class="fa fa-edit"></i></a>&nbsp;'
      actionButton += '<a href="javascript:void(0);" data-route="'+type_path(:id => 0)+'" class="btn btn-sm btn-danger btn-delete"><i class="fa fa-trash"></i></a>&nbsp;'
  
       ## Read value
       draw =  params["draw"]
       row =  params["start"]
       rowperpage = params["length"]
       columnIndex =  params["order"]["0"]["column"]
       columnName =   params["columns"][columnIndex]["name"]
       columnSortOrder = params["order"]["0"]["dir"]
       searchValue =  params["search"]["value"]
  
        ## Total number of records without filtering
        
        getData = Type.select(
          "types.id",
          "types.id as key_id", 
          "types.name as types_name", 
          "types.description as types_description", 
          "'"+actionButton+"' as action"
        )
  
        totalRecord = getData.count(:all)
  
        ## Total number of records with filtering  
        ## Search
        getFilter = getData
  
        if searchValue.length > 0
          getFilter = getFilter.where("types.name LIKE ? OR types.description LIKE ?", "%#{searchValue}%", "%#{searchValue}%")
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
      @type = Type.new
    end
  
    def create
      @type = Type.new(type_params)
  
      if @type.valid?
        @type.save
        flash[:success] = "Record created successfully"
        redirect_to type_path(@type)
      else
        @page_name = PAGE_NAME
        render :new
      end
  
    end
  
    def show
      @page_name = PAGE_NAME
      @type = Type.find(params[:id])
    end
  
    def edit
      @page_name = PAGE_NAME
      @type = Type.find(params[:id])
    end
  
    def update
      @type = Type.find(params[:id])
      @type.update(type_params)
      if @type.valid?
        @type.update_attributes!(type_params)
        flash[:success] = "Record updated successfully"
        redirect_to type_path(@type)
      else
        @page_name = PAGE_NAME
        render :edit
      end
    end
  
    def destroy
      @type = Type.find(params[:id])
      @type.destroy
      is_ajax =  params["is_ajax"]
      if is_ajax == "y"
        render :json => @type
      else
        flash[:success] = "Record deleted successfully"
        redirect_to types_path
      end
    end
  
    private
      def type_params
        params.permit(:name, :description)
      end
  
  end
  