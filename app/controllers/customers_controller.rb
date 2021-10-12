class CustomersController < ApplicationController

    PAGE_NAME = "Customer" 
  
    def datatable
    
      ## Action Buttons ( Addtional Buttons )
      actionButton = ''
      actionButton += '<a href="javascript:void(0);" data-route="'+customer_path(:id => 0)+'" class="btn btn-sm btn-success btn-show"><i class="fa fa-search"></i></a>&nbsp;'
      actionButton += '<a href="javascript:void(0);" data-route="'+edit_customer_path(:id => 0)+'" class="btn btn-sm btn-info btn-edit"><i class="fa fa-edit"></i></a>&nbsp;'
      actionButton += '<a href="javascript:void(0);" data-route="'+customer_path(:id => 0)+'" class="btn btn-sm btn-danger btn-delete"><i class="fa fa-trash"></i></a>&nbsp;'
  
       ## Read value
       draw =  params["draw"]
       row =  params["start"]
       rowperpage = params["length"]
       columnIndex =  params["order"]["0"]["column"]
       columnName =   params["columns"][columnIndex]["name"]
       columnSortOrder = params["order"]["0"]["dir"]
       searchValue =  params["search"]["value"]
  
        ## Total number of records without filtering
        
        getData = Customer.select(
          "customers.id",
          "customers.id as key_id", 
          "customers.name as customers_name", 
          "customers.phone as customers_phone", 
          "customers.email as customers_email", 
          "customers.website as customers_website", 
          "'"+actionButton+"' as action"
        )
  
        totalRecord = getData.count(:all)
  
        ## Total number of records with filtering  
        ## Search
        getFilter = getData
  
        if searchValue.length > 0
          getFilter = getFilter.where("customers.name LIKE ? OR customers.phone LIKE ? OR customers.email LIKE ? OR customers.website LIKE ?", "%#{searchValue}%", "%#{searchValue}%", "%#{searchValue}%", "%#{searchValue}%")
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
      @customer = Customer.new
    end
  
    def create
      @customer = Customer.new(customer_params)
  
      if @customer.valid?
        @customer.save
        flash[:success] = "Record created successfully"
        redirect_to customer_path(@customer)
      else
        @page_name = PAGE_NAME
        render :new
      end
  
    end
  
    def show
      @page_name = PAGE_NAME
      @customer = Customer.find(params[:id])
    end
  
    def edit
      @page_name = PAGE_NAME
      @customer = Customer.find(params[:id])
    end
  
    def update
      @customer = Customer.find(params[:id])
      @customer.update(customer_params)
      if @customer.valid?
        @customer.update_attributes!(customer_params)
        flash[:success] = "Record updated successfully"
        redirect_to customer_path(@customer)
      else
        @page_name = PAGE_NAME
        render :edit
      end
    end
  
    def destroy
      @customer = Customer.find(params[:id])
      @customer.destroy
      is_ajax =  params["is_ajax"]
      if is_ajax == "y"
        render :json => @customer
      else
        flash[:success] = "Record deleted successfully"
        redirect_to customers_path
      end
    end
  
    private
      def customer_params
        params.permit(:name, :phone, :email, :website, :address)
      end
  
  end
  