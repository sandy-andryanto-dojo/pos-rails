class SalesController < ApplicationController

    PAGE_NAME = "Sale"
    
    def datatable

        ## Action Buttons ( Addtional Buttons )
      actionButton = ''
      actionButton += '<a href="javascript:void(0);" data-route="'+sale_path(:id => 0)+'" class="btn btn-sm btn-success btn-show"><i class="fa fa-search"></i></a>&nbsp;'
      actionButton += '<a href="javascript:void(0);" data-route="'+edit_sale_path(:id => 0)+'" class="btn btn-sm btn-info btn-edit"><i class="fa fa-edit"></i></a>&nbsp;'
      actionButton += '<a href="javascript:void(0);" data-route="'+sale_path(:id => 0)+'" class="btn btn-sm btn-danger btn-delete"><i class="fa fa-trash"></i></a>&nbsp;'
  
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
          "customers.name as customers_name",
          "'"+actionButton+"' as action"
        ).joins("LEFT JOIN customers ON customers.id = transactions.customer_id")

        getData = getData.where("type_of = ? ",1)
  
        totalRecord = getData.count(:all)
  
        ## Total number of records with filtering  
        ## Search
        getFilter = getData
  
        if searchValue.length > 0
          getFilter = getFilter.where("transactions.invoice_date LIKE ? OR transactions.invoice_number LIKE ? OR customers.name LIKE ?", "%#{searchValue}%", "%#{searchValue}%", "%#{searchValue}%")
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
        invoice_number = "SALE."+Time.now.strftime("%Y%m%d")+".00001"
        today = Transaction.where("invoice_date = ? AND type_of = ? ", Time.now.strftime("%Y-%m-%d"), 1).order("id DESC").first
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
            invoice_number = "SALE."+Time.now.strftime("%Y%m%d")+"."+temp
        end
        transaction = Transaction.new
        transaction.type_of = 1
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
        redirect_to edit_sale_path(transaction)
    end

    def create
        render "errors/not_found"
    end

    def show
        @page_name = PAGE_NAME
        @sale = Transaction.find(params[:id])
        @details =  TransactionDetail.where("transaction_id = ? ", params[:id])
    end

    def edit
        @page_name = PAGE_NAME
        @sale = Transaction.find(params[:id])
    end

    def print
      @page_name = PAGE_NAME
      @sale = Transaction.find(params[:id])
      @details =  TransactionDetail.where("transaction_id = ? ", params[:id])
      render :layout => false
    end

    def update
      @sale = Transaction.find(params[:id])
      TransactionDetail.where("transaction_id = ? ", params[:id]).destroy_all

      total_items = 0
      customer_id = params["customer_id"].to_i
      grandtotal = params["grandtotal"].to_f
      subtotal = params["subtotal"].to_f
      discount = params["discount"].to_f
      tax = params["tax"].to_f
      cash = params["cash"].to_f
      change = params["change"].to_f

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
         product.stock = product.stock - qty
         product.save!

         detail = TransactionDetail.new
         detail.transaction_id = params[:id]
         detail.product = product
         detail.price = price
         detail.qty = qty
         detail.total = total
         detail.save!
         
      end

      @sale.customer = Customer.find(customer_id)
      @sale.subtotal = subtotal
      @sale.discount = discount
      @sale.tax = tax
      @sale.grandtotal = grandtotal
      @sale.cash = cash
      @sale.change = change
      @sale.total_items = total_items
      @sale.status = 1
      @sale.save!
      
      #render :json => params
      flash[:success] = "Record updated successfully"
      redirect_to sale_path(@sale)
    end

    def destroy
      @transaction = Transaction.find(params[:id])
      @transaction.destroy
      is_ajax =  params["is_ajax"]
      if is_ajax == "y"
        render :json => @transaction
      else
        flash[:success] = "Record deleted successfully"
        redirect_to sales_path
      end
    end

end