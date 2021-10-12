class BrandsController < ApplicationController

  PAGE_NAME = "Brand" 

  def datatable
  
    ## Action Buttons ( Addtional Buttons )
    actionButton = ''
    actionButton += '<a href="javascript:void(0);" data-route="'+brand_path(:id => 0)+'" class="btn btn-sm btn-success btn-show"><i class="fa fa-search"></i></a>&nbsp;'
    actionButton += '<a href="javascript:void(0);" data-route="'+edit_brand_path(:id => 0)+'" class="btn btn-sm btn-info btn-edit"><i class="fa fa-edit"></i></a>&nbsp;'
    actionButton += '<a href="javascript:void(0);" data-route="'+brand_path(:id => 0)+'" class="btn btn-sm btn-danger btn-delete"><i class="fa fa-trash"></i></a>&nbsp;'

     ## Read value
     draw =  params["draw"]
     row =  params["start"]
     rowperpage = params["length"]
     columnIndex =  params["order"]["0"]["column"]
     columnName =   params["columns"][columnIndex]["name"]
     columnSortOrder = params["order"]["0"]["dir"]
     searchValue =  params["search"]["value"]

      ## Total number of records without filtering
      
      getData = Brand.select(
        "brands.id",
        "brands.id as key_id", 
        "brands.name as brands_name", 
        "brands.description as brands_description", 
        "'"+actionButton+"' as action"
      )

      totalRecord = getData.count(:all)

      ## Total number of records with filtering  
      ## Search
      getFilter = getData

      if searchValue.length > 0
        getFilter = getFilter.where("brands.name LIKE ? OR brands.description LIKE ?", "%#{searchValue}%", "%#{searchValue}%")
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
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(brand_params)

    if @brand.valid?
      @brand.save
      flash[:success] = "Record created successfully"
      redirect_to brand_path(@brand)
    else
      @page_name = PAGE_NAME
      render :new
    end

  end

  def show
    @page_name = PAGE_NAME
    @brand = Brand.find(params[:id])
  end

  def edit
    @page_name = PAGE_NAME
    @brand = Brand.find(params[:id])
  end

  def update
    @brand = Brand.find(params[:id])
    @brand.update(brand_params)
    if @brand.valid?
      @brand.update_attributes!(brand_params)
      flash[:success] = "Record updated successfully"
      redirect_to brand_path(@brand)
    else
      @page_name = PAGE_NAME
      render :edit
    end
  end

  def destroy
    @brand = Brand.find(params[:id])
    @brand.destroy
    is_ajax =  params["is_ajax"]
    if is_ajax == "y"
      render :json => @brand
    else
      flash[:success] = "Record deleted successfully"
      redirect_to brands_path
    end
  end

  private
    def brand_params
      params.permit(:name, :description)
    end

end
