class ReportsController < ApplicationController

    PAGE_NAME = "Report"

    def index
        n = DateTime.now
        @page_name = PAGE_NAME
        @firstDate = n.to_date.beginning_of_month.strftime("%Y-%m-%d")
        @lastDate = n.to_date.end_of_month.strftime("%Y-%m-%d")
    end

    def purchase_period
        firstDate = params["first_date"]
        lastDate = params["last_date"]
        @data = Transaction.where("invoice_date >= ? AND invoice_date <= ? AND type_of = ? AND status = ? ", firstDate, lastDate, 0, 1).order("id DESC")
        render :layout => false
    end

    def purchase_supplier
        firstDate = params["first_date"].to_s
        lastDate = params["last_date"].to_s

        sql = "
            SELECT 
                suppliers.id as supplier_id,
                suppliers.name as supplier_name,
                IFNULL(SUM(qty), 0) as total_buy,
                IFNULL(SUM(total),0) as total_purchase
            FROM 
            suppliers
            LEFT JOIN transactions ON transactions.supplier_id = suppliers.id
            LEFT JOIN transaction_details ON transactions.id = transaction_details.transaction_id
            WHERE transactions.status = 1
            AND invoice_date >= '"+firstDate+"' AND invoice_date <= '"+lastDate+"' AND transactions.type_of = 0
            GROUP BY suppliers.id, suppliers.name ORDER BY suppliers.name
        "
        @data = ActiveRecord::Base.connection.select_all(sql)
        render :layout => false
        
    end

    def purchase_product
        firstDate = params["first_date"].to_s
        lastDate = params["last_date"].to_s

        sql = "

        SELECT 
            brands.name as brand_name,
            types.name as type_name,
            products.sku as product_sku,
            products.name as product_name,
            suppliers.name as supplier_name,
            SUM(qty) as total_buy,
            SUM(total) as total_purchase
        FROM products
            LEFT JOIN transaction_details ON transaction_details.product_id = products.id
            LEFT JOIN transactions ON transactions.id = transaction_details.transaction_id
            LEFT JOIN brands ON brands.id = products.brand_id
            LEFT JOIN types ON types.id = products.type_id
            LEFT JOIN suppliers ON suppliers.id = products.supplier_id
            WHERE transactions.status = 1
            AND invoice_date >= '"+firstDate+"' AND invoice_date <= '"+lastDate+"' AND transactions.type_of = 0
            GROUP BY brands.name, types.name, products.sku, products.name, suppliers.name ORDER BY brands.name, types.name, suppliers.name, products.sku, products.name 

        "
        @data = ActiveRecord::Base.connection.select_all(sql)
        render :layout => false
    end

    def sale_period
        firstDate = params["first_date"]
        lastDate = params["last_date"]
        @data = Transaction.where("invoice_date >= ? AND invoice_date <= ? AND type_of = ? AND status = ? ", firstDate, lastDate, 1, 1).order("id DESC")
        render :layout => false
    end

    def sale_customer
        firstDate = params["first_date"].to_s
        lastDate = params["last_date"].to_s

        sql = "
            SELECT 
                customers.id as customer_id,
                customers.name as customer_name,
                IFNULL(SUM(qty), 0) as total_sell,
                IFNULL(SUM(total),0) as total_sale
            FROM 
            customers
            LEFT JOIN transactions ON transactions.customer_id = customers.id
            LEFT JOIN transaction_details ON transactions.id = transaction_details.transaction_id
            WHERE transactions.status = 1
            AND invoice_date >= '"+firstDate+"' AND invoice_date <= '"+lastDate+"' AND transactions.type_of = 1
            GROUP BY customers.id, customers.name ORDER BY customers.name
        "
        @data = ActiveRecord::Base.connection.select_all(sql)
        render :layout => false
    end

    def sale_product
        firstDate = params["first_date"].to_s
        lastDate = params["last_date"].to_s

        sql = "

        SELECT 
            brands.name as brand_name,
            types.name as type_name,
            products.sku as product_sku,
            products.name as product_name,
            customers.name as customer_name,
            SUM(qty) as total_buy,
            SUM(total) as total_sale
        FROM products
            LEFT JOIN transaction_details ON transaction_details.product_id = products.id
            LEFT JOIN transactions ON transactions.id = transaction_details.transaction_id
            LEFT JOIN brands ON brands.id = products.brand_id
            LEFT JOIN types ON types.id = products.type_id
            LEFT JOIN customers ON customers.id = transactions.customer_id
            WHERE transactions.status = 1
            AND invoice_date >= '"+firstDate+"' AND invoice_date <= '"+lastDate+"' AND transactions.type_of = 1
            GROUP BY brands.name, types.name, products.sku, products.name, customers.name ORDER BY brands.name, types.name, customers.name, products.sku, products.name 

        "
        @data = ActiveRecord::Base.connection.select_all(sql)
        render :layout => false
    end

end