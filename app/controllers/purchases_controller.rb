class PurchasesController < ApplicationController

    PAGE_NAME = "Purchase"
    
    def datatable

        ## Action Buttons ( Addtional Buttons )
      actionButton = ''
      actionButton += '<a href="javascript:void(0);" data-route="'+purchase_path(:id => 0)+'" class="btn btn-sm btn-success btn-show"><i class="fa fa-search"></i></a>&nbsp;'
      actionButton += '<a href="javascript:void(0);" data-route="'+edit_purchase_path(:id => 0)+'" class="btn btn-sm btn-info btn-edit"><i class="fa fa-edit"></i></a>&nbsp;'
      actionButton += '<a href="javascript:void(0);" data-route="'+purchase_path(:id => 0)+'" class="btn btn-sm btn-danger btn-delete"><i class="fa fa-trash"></i></a>&nbsp;'
  
       ## Read value
       draw =  params["draw"]
       row =  params["start"]
       rowperpage = params["length"]
       columnIndex =  params["order"]["0"]["column"]
       columnName =   params["columns"][columnIndex]["name"]
       columnSortOrder = params["order"]["0"]["dir"]
       searchValue =  params["search"]["value"]
  
        ## Total number of records without filtering
        
        getData = Transaction.select(
          "transactions.id",
          "transactions.id as key_id", 
          "transactions.invoice_date as transactions_invoice_date", 
          "transactions.invoice_number as transactions_invoice_number", 
          "transactions.grandtotal as transactions_grandtotal", 
          "transactions.status as transactions_status", 
          "suppliers.name as suppliers_name",
          "'"+actionButton+"' as action"
        ).joins("LEFT JOIN suppliers ON suppliers.id = transactions.supplier_id")
        
        getData = getData.where("type_of = ? ", 0)

        totalRecord = getData.count(:all)
  
        ## Total number of records with filtering  
        ## Search
        getFilter = getData
  
        if searchValue.length > 0
          getFilter = getFilter.where("transactions.invoice_date LIKE ? OR transactions.invoice_number LIKE ? OR suppliers.name LIKE ?", "%#{searchValue}%", "%#{searchValue}%", "%#{searchValue}%")
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
        invoice_number = "PRC."+Time.now.strftime("%Y%m%d")+".00001"
        today = Transaction.where("invoice_date = ? AND type_of = ? ", Time.now.strftime("%Y-%m-%d"), 0).order("id DESC").first
        if (today)
            arr_number = today.invoice_number.split('.')
            arr_index = arr_number.last
            next_index = arr_index.to_i + 1
            temp = next_index.to_s
            digit = 5
            i_number = temp.length 
            while (digit > i_number)
                temp = "0"+temp
                digit = digit - 1
            end
            invoice_number = "PRC."+Time.now.strftime("%Y%m%d")+"."+temp
        end
        transaction = Transaction.new
        transaction.type_of = 0
        transaction.status = 0
        transaction.invoice_number = invoice_number
        transaction.invoice_date =  Time.now.strftime("%Y-%m-%d")
        transaction.user_id = session[:user_id]
        transaction.total_items = 0
        transaction.subtotal = 0
        transaction.discount = 0
        transaction.tax = 0
        transaction.grandtotal = 0
        transaction.cash = 0
        transaction.save!
        redirect_to edit_purchase_path(transaction)
    end

    def create
        render "errors/not_found"
    end

    def show
        @page_name = PAGE_NAME
        @purchase = Transaction.find(params[:id])
        @details =  TransactionDetail.where("transaction_id = ? ", params[:id])
    end

    def edit
        @page_name = PAGE_NAME
        @purchase = Transaction.find(params[:id])
    end

    def print
      @page_name = PAGE_NAME
      @purchase = Transaction.find(params[:id])
      @details =  TransactionDetail.where("transaction_id = ? ", params[:id])
      render :layout => false
    end

    def update
      @purchase = Transaction.find(params[:id])
      TransactionDetail.where("transaction_id = ? ", params[:id]).destroy_all

      total_items = 0
      supplier_id = params["supplier_id"].to_i
      grandtotal = params["grandtotal"].to_f

      products = params["product_id"]
      _price = params["price"]
      _qty = params["qty"]
      _total = params["total"]

      products.each_with_index do |value, index|

        price = _price[index].to_f
        qty = _qty[index].to_f
        total = _total[index].to_f
        total_items = total_items + total

         product = Product.find(value)
         product.supplier_id = supplier_id
         product.stock = product.stock + qty
         product.save!

         detail = TransactionDetail.new
         detail.transaction_id = params[:id]
         detail.product = product
         detail.price = price
         detail.qty = qty
         detail.total = total
         detail.save!
         
      end

      @purchase.supplier = Supplier.find(supplier_id)
      @purchase.grandtotal = grandtotal
      @purchase.total_items = total_items
      @purchase.status = 1
      @purchase.save!
      
      #render :json => params
      flash[:success] = "Record updated successfully"
      redirect_to purchase_path(@purchase)
    end

    def destroy
      @transaction = Transaction.find(params[:id])
      @transaction.destroy
      is_ajax =  params["is_ajax"]
      if is_ajax == "y"
        render :json => @transaction
      else
        flash[:success] = "Record deleted successfully"
        redirect_to purchases_path
      end
    end

end