# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

puts("-------------------")
puts("Seed data started at "+Time.now.strftime("%Y-%m-%d %H:%M:%S %Z"))
puts("-------------------")
puts("PLEASE WAIT...................")

if (Role.count(:all) == 0)
    roles = ["Admin", "User"]
    roles.each do |role| 
        role = Role.new(
            :name => role,
            :description => Faker::Lorem.paragraph
        )
        role.save!
    end
end

if (User.count(:all) == 0)
    role_admin = Role.where(name: "Admin")
    user = User.new(
        :username              => "admin",
        :email                 => "admin@devel.com",
        :password              =>  "secret",
        :password_confirmation =>  "secret",
        :email_confirm         => true,
        :phone_confirm         => true,
        :is_active             => true,
        :groups                => "Admin"
    )
    user.roles = role_admin
    user.save!
end

if (Brand.count(:all) == 0)
    for i in 1..100 do
        brand = Brand.new(
            :name  => Faker::Name.unique.name,
            :description => Faker::Lorem.paragraph
        )
        brand.save!
    end
end

if (Category.count(:all) == 0)
    for i in 1..100 do
        category = Category.new(
            :name  => Faker::Name.unique.name,
            :description => Faker::Lorem.paragraph
        )
        category.save!
    end
end

if (Type.count(:all) == 0)
    for i in 1..100 do
        type = Type.new(
            :name  => Faker::Name.unique.name,
            :description => Faker::Lorem.paragraph
        )
        type.save!
    end
end

if (Supplier.count(:all) == 0)
    for i in 1..100 do
        supplier = Supplier.new(
            :name  => Faker::Name.unique.name,
            :email => Faker::Internet.safe_email,
            :phone => Faker::PhoneNumber.phone_number,
            :website  => Faker::Internet.url,
            :address => Faker::Lorem.paragraph
        )
        supplier.save!
    end
end

if (Customer.count(:all) == 0)
    for i in 1..100 do
        customer = Customer.new(
            :name  => Faker::Name.unique.name,
            :email => Faker::Internet.safe_email,
            :phone => Faker::PhoneNumber.phone_number,
            :website  => Faker::Internet.url,
            :address => Faker::Lorem.paragraph
        )
        customer.save!
    end
end

if (Product.count(:all) == 0)
    for i in 1..100 do

        price_purchase = rand(1000..9999)
        price_profit = rand(1..100)
        price_sales = price_purchase + ((price_purchase * price_profit)/100)

        supplier = Supplier.order('RAND()').first
        brand = Brand.order('RAND()').first
        type = Type.order('RAND()').first
        categories = Category.order('RAND()').limit(5)

        product_name = Faker::Food.ingredient

        getByName = Product.where(name: product_name).first

        if(!getByName)

            product = Product.new(
                :sku => Faker::Bank.routing_number,
                :name  => product_name,
                :brand => brand,
                :type => type,
                :supplier=> supplier,
                :price_purchase => price_purchase,
                :price_sales=> price_sales,
                :price_profit=> price_profit,
                :date_expired=>Time.now.strftime("%Y-%m-%d"),
                :description => Faker::Lorem.paragraph,
                :notes => Faker::Lorem.paragraph,
                :stock => 0
            )
            product.categories = categories
            product.save!

        end


    end
end

userAdmin = User.first

puts("-------------------")
puts("Seed data completed at "+Time.now.strftime("%Y-%m-%d %H:%M:%S %Z"))
puts("Some data seeded.")
puts("Here is your admin details to login:")
puts("Username is "+userAdmin.username)
puts("Email is "+userAdmin.email)
puts("Password is 'secret' ")
puts("All done :)")
puts("-------------------")