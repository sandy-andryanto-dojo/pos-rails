class RolesController < ApplicationController

    PAGE_NAME = "Role" 
  
    def datatable
    
      ## Action Buttons ( Addtional Buttons )
      actionButton = ''
      actionButton += '<a href="javascript:void(0);" data-route="'+role_path(:id => 0)+'" class="btn btn-sm btn-success btn-show"><i class="fa fa-search"></i></a>&nbsp;'
      actionButton += '<a href="javascript:void(0);" data-route="'+edit_role_path(:id => 0)+'" class="btn btn-sm btn-info btn-edit"><i class="fa fa-edit"></i></a>&nbsp;'
      actionButton += '<a href="javascript:void(0);" data-route="'+role_path(:id => 0)+'" class="btn btn-sm btn-danger btn-delete"><i class="fa fa-trash"></i></a>&nbsp;'
  
       ## Read value
       draw =  params["draw"]
       row =  params["start"]
       rowperpage = params["length"]
       columnIndex =  params["order"]["0"]["column"]
       columnName =   params["columns"][columnIndex]["name"]
       columnSortOrder = params["order"]["0"]["dir"]
       searchValue =  params["search"]["value"]
  
        ## Total number of records without filtering
        
        getData = Role.select(
          "roles.id",
          "roles.id as key_id", 
          "roles.name as roles_name", 
          "roles.description as roles_description", 
          "'"+actionButton+"' as action"
        )
  
        totalRecord = getData.count(:all)
  
        ## Total number of records with filtering  
        ## Search
        getFilter = getData
  
        if searchValue.length > 0
          getFilter = getFilter.where("roles.name LIKE ? OR roles.description LIKE ?", "%#{searchValue}%", "%#{searchValue}%")
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
      @role = Role.new
    end
  
    def create
      @role = Role.new(role_params)
  
      if @role.valid?
        @role.save
        flash[:success] = "Record created successfully"
        redirect_to role_path(@role)
      else
        @page_name = PAGE_NAME
        render :new
      end
  
    end
  
    def show
      @page_name = PAGE_NAME
      @role = Role.find(params[:id])
    end
  
    def edit
      @page_name = PAGE_NAME
      @role = Role.find(params[:id])
    end
  
    def update
      @role = Role.find(params[:id])
      @role.update(role_params)
      if @role.valid?
        @role.update_attributes!(role_params)
        flash[:success] = "Record updated successfully"
        redirect_to role_path(@role)
      else
        @page_name = PAGE_NAME
        render :edit
      end
    end
  
    def destroy
      @role = Role.find(params[:id])
      @role.destroy
      is_ajax =  params["is_ajax"]
      if is_ajax == "y"
        render :json => @role
      else
        flash[:success] = "Record deleted successfully"
        redirect_to roles_path
      end
    end
  
    private
      def role_params
        params.permit(:name, :description)
      end
  
  end
  