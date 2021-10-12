Rails.application.routes.draw do

  root 'dashboard#index'
  resources :users
  resources :brands
  resources :categories
  resources :customers
  resources :suppliers
  resources :types
  resources :products
  resources :roles
  resources :users
  resources :purchases
  resources :sales
  resources :sessions, only: [:new, :create, :destroy]

  #print document
  scope :print do
    get 'purchases/:id', to: 'purchases#print', as: 'purchases_print'
    get 'sales/:id', to: 'sales#print', as: 'sales_print'
  end


  # api database only
  scope :datatable do
    match 'brands', to: 'brands#datatable', via: [:get, :post]
    match 'categories', to: 'categories#datatable', via: [:get, :post]
    match 'customers', to: 'customers#datatable', via: [:get, :post]
    match 'suppliers', to: 'suppliers#datatable', via: [:get, :post]
    match 'products', to: 'products#datatable', via: [:get, :post]
    match 'types', to: 'types#datatable', via: [:get, :post]
    match 'roles', to: 'roles#datatable', via: [:get, :post]
    match 'users', to: 'users#datatable', via: [:get, :post]
    match 'purchases', to: 'purchases#datatable', via: [:get, :post]
    match 'sales', to: 'sales#datatable', via: [:get, :post]
  end
  post 'products/select2', to: 'products#select2', as: 'products_select2'

  # reporting routes
  get 'reports', to: 'reports#index', as: 'reports'
  get 'reports/purchase_period/:first_date/:last_date', to: 'reports#purchase_period', as: 'reports_purchase_period'
  get 'reports/purchase_supplier/:first_date/:last_date', to: 'reports#purchase_supplier', as: 'reports_purchase_supplier'
  get 'reports/purchase_product/:first_date/:last_date', to: 'reports#purchase_product', as: 'reports_purchase_product'
  get 'reports/sale_period/:first_date/:last_date', to: 'reports#sale_period', as: 'reports_sale_period'
  get 'reports/sale_customer/:first_date/:last_date', to: 'reports#sale_customer', as: 'reports_sale_customer'
  get 'reports/sale_product/:first_date/:last_date', to: 'reports#sale_product', as: 'reports_sale_product'


  get 'dashboard', to: 'dashboard#index'
  match 'dashboard/summary', to: 'dashboard#summary', via: [:get, :post]


  get 'login', to: 'sessions#new', as: 'login'
  get 'signup', to: 'sessions#signup', as: 'signup'
  post 'register', to: 'sessions#register', as: 'register'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'profile', to: 'users#profile', as: 'profile'

  patch 'update_profile', to: 'users#update_profile', as: 'update_profile'

  #error
  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unacceptable"
  get "/500", to: "errors#internal_error"
  
end
