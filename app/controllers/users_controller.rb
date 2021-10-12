class UsersController < ApplicationController
 
  PAGE_NAME = "User" 

  def profile
    @page_name = "User Profile"
    @user = current_user()
  end

  def update_profile
    @user = current_user()
    @user.update(user_params)
    if @user.valid?
      @user.update_attributes!(user_params)
      flash[:success] = "Profile updated successfully"
      redirect_to profile_path
    else
      @page_name = "User Profile"
      render :profile
    end
  end

  def datatable
    
    ## Action Buttons ( Addtional Buttons )
    actionButton = ''
    actionButton += '<a href="javascript:void(0);" data-route="'+user_path(:id => 0)+'" class="btn btn-sm btn-success btn-show"><i class="fa fa-search"></i></a>&nbsp;'
    actionButton += '<a href="javascript:void(0);" data-route="'+edit_user_path(:id => 0)+'" class="btn btn-sm btn-info btn-edit"><i class="fa fa-edit"></i></a>&nbsp;'
    actionButton += '<a href="javascript:void(0);" data-route="'+user_path(:id => 0)+'" class="btn btn-sm btn-danger btn-delete"><i class="fa fa-trash"></i></a>&nbsp;'

     ## Read value
     draw =  params["draw"]
     row =  params["start"]
     rowperpage = params["length"]
     columnIndex =  params["order"]["0"]["column"]
     columnName =   params["columns"][columnIndex]["name"]
     columnSortOrder = params["order"]["0"]["dir"]
     searchValue =  params["search"]["value"]

      ## Total number of records without filtering
      
      getData = User.select(
        "users.id",
        "users.id as key_id", 
        "users.username as users_username", 
        "users.email as users_email", 
        "users.groups as users_groups", 
        "'"+actionButton+"' as action"
      )
      getData = getData.where.not(id: session[:user_id])

      totalRecord = getData.count(:all)

      ## Total number of records with filtering  
      ## Search
      getFilter = getData

      if searchValue.length > 0
        getFilter = getFilter.where("users.username LIKE ? OR users.email LIKE ?  OR users.groups LIKE ?", "%#{searchValue}%", "%#{searchValue}%",  "%#{searchValue}%")
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
    @user = User.new
  end

  def create
    @user = User.new(user_manage_params)
    if @user.valid?

      if(params.has_key?(:role_ids))
        roles = Role.find(params[:role_ids])
        @user.groups = roles.pluck(:name).join(",")
        @user.roles = roles
      end

      @user.email_confirm = 0
      @user.phone_confirm = 0
      @user.is_active = params.has_key?(:is_active) ? 1 : 0
      @user.save
      flash[:success] = "Record created successfully"
      redirect_to user_path(@user)
    else
      @page_name = PAGE_NAME
      render :new
    end

  end

  def show
    @page_name = PAGE_NAME
    @user = User.find(params[:id])
  end

  def edit
    @page_name = PAGE_NAME
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_manage_params)
    if @user.valid?

      @user.roles.clear 
      if(params.has_key?(:role_ids))
        roles = Role.find(params[:role_ids])
        @user.roles = roles
      end
      @user.is_active = params.has_key?(:is_active) ? 1 : 0
      @user.update_attributes!(user_manage_params)
      flash[:success] = "Record updated successfully"
      redirect_to user_path(@user)
    else
      @page_name = PAGE_NAME
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    is_ajax =  params["is_ajax"]
    if is_ajax == "y"
      render :json => @user
    else
      flash[:success] = "Record deleted successfully"
      redirect_to users_path
    end

  end



  private

    def user_params
      params.permit(:username, :email, :phone, :password, :password_confirmation)
    end

    def user_manage_params
      params.permit(:username, :email, :phone, :roles, :is_active, :password, :password_confirmation)
    end
  

end
