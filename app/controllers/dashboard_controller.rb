class DashboardController < ApplicationController
    def index
    end

    def summary
        
        response = {
            :product => Product.count(:all),
            :supplier => Supplier.count(:all),
            :customer => Customer.count(:all),
            :brand => Brand.count(:all),
            :purchase => getPieChart(0),
            :sale=> getPieChart(1),
            :chartPurchase => getBarChart(0),
            :chartSale => getBarChart(1),
         }
     
         render :json => response
    end

    def getPieChart(type_of)

        n = DateTime.now
        year = Time.current.year
        firstDate = year.to_s+"-01-01"
        lastDate =  year.to_s+"-12-31"

        sql = "
            SELECT 
                products.name as name,
                SUM(qty) as total
            FROM transaction_details 
                INNER JOIN products ON products.id = transaction_details.product_id
                INNER JOIN transactions ON transactions.id = transaction_details.transaction_id
                WHERE transactions.status = 1
                AND invoice_date >= '"+firstDate+"' AND invoice_date <= '"+lastDate+"' AND transactions.type_of = "+(type_of.to_s)+"
                GROUP BY products.id, products.name, qty
                ORDER BY qty DESC 
                LIMIT 10

        "
        return ActiveRecord::Base.connection.select_all(sql)

    end


    def getBarChart(type_of)

        year = Time.current.year
        result = []
        i = 1
        temp = 0
        while(i <= 12)
            result[temp] = TransactionDetail.joins("JOIN transactions ON transactions.id = transaction_details.transaction_id")
                .where("type_of = ? AND YEAR(invoice_date) = ? AND MONTH(invoice_date) = ? ", type_of, year, i)
                .sum(:total)
            i = i + 1
            temp = temp +1
        end

        return result
    end

end
