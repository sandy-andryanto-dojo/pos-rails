class SuppliersController < ApplicationController

    PAGE_NAME = "Supplier" 
  
    def datatable
    
      ## Action Buttons ( Addtional Buttons )
      actionButton = ''
      actionButton += '<a href="javascript:void(0);" data-route="'+supplier_path(:id => 0)+'" class="btn btn-sm btn-success btn-show"><i class="fa fa-search"></i></a>&nbsp;'
      actionButton += '<a href="javascript:void(0);" data-route="'+edit_supplier_path(:id => 0)+'" class="btn btn-sm btn-info btn-edit"><i class="fa fa-edit"></i></a>&nbsp;'
      actionButton += '<a href="javascript:void(0);" data-route="'+supplier_path(:id => 0)+'" class="btn btn-sm btn-danger btn-delete"><i class="fa fa-trash"></i></a>&nbsp;'
  
       ## Read value
       draw =  params["draw"]
       row =  params["start"]
       rowperpage = params["length"]
       columnIndex =  params["order"]["0"]["column"]
       columnName =   params["columns"][columnIndex]["name"]
       columnSortOrder = params["order"]["0"]["dir"]
       searchValue =  params["search"]["value"]
  
        ## Total number of records without filtering
        
        getData = Supplier.select(
          "suppliers.id",
          "suppliers.id as key_id", 
          "suppliers.name as suppliers_name", 
          "suppliers.phone as suppliers_phone", 
          "suppliers.email as suppliers_email", 
          "suppliers.website as suppliers_website", 
          "'"+actionButton+"' as action"
        )
  
        totalRecord = getData.count(:all)
  
        ## Total number of records with filtering  
        ## Search
        getFilter = getData
  
        if searchValue.length > 0
          getFilter = getFilter.where("suppliers.name LIKE ? OR suppliers.phone LIKE ? OR suppliers.email LIKE ? OR suppliers.website LIKE ?", "%#{searchValue}%", "%#{searchValue}%", "%#{searchValue}%", "%#{searchValue}%")
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
      @supplier = Supplier.new
    end
  
    def create
      @supplier = Supplier.new(supplier_params)
  
      if @supplier.valid?
        @supplier.save
        flash[:success] = "Record created successfully"
        redirect_to supplier_path(@supplier)
      else
        @page_name = PAGE_NAME
        render :new
      end
  
    end
  
    def show
      @page_name = PAGE_NAME
      @supplier = Supplier.find(params[:id])
    end
  
    def edit
      @page_name = PAGE_NAME
      @supplier = Supplier.find(params[:id])
    end
  
    def update
      @supplier = Supplier.find(params[:id])
      @supplier.update(supplier_params)
      if @supplier.valid?
        @supplier.update_attributes!(supplier_params)
        flash[:success] = "Record updated successfully"
        redirect_to supplier_path(@supplier)
      else
        @page_name = PAGE_NAME
        render :edit
      end
    end
  
    def destroy
      @supplier = Supplier.find(params[:id])
      @supplier.destroy
      is_ajax =  params["is_ajax"]
      if is_ajax == "y"
        render :json => @supplier
      else
        flash[:success] = "Record deleted successfully"
        redirect_to suppliers_path
      end
    end
  
    private
      def supplier_params
        params.permit(:name, :phone, :email, :website, :address)
      end
  
  end
  