Tripler::Application.routes.draw do
  scope module: :user_app, constraints: NoSubdomain do
    root "pages#home"
    get :home, to: "pages#home"
    get :about, to: "pages#about"
    get :jerky, to: "pages#jerky"
    get :contact, to: "pages#contact"

    get :admin, to: "users#admin"
    post :registration, to: "users#registration"
    post :sign_in, to: "users#sign_in"
    delete :sign_out, to: "users#sign_out"

    post :feedback, to: "feedback#create"

    post :order, to: "order#create"
    get :order, to: "order#edit"
    put :order, to: "order#update"
    delete :order, to: "order#destroy"

    get "order/address", to: "order_address#new"
    post "order/address", to: "order_address#create"
    get "order/address/edit", to: "order_address#edit"
    put "order/address", to: "order_address#update"

    get "order/rates", to: "order_rates#index"
    post "order/rates", to: "order_rates#create"

    get "order/purchase", to: "order_purchase#new"
    post "order/purchase", to: "order_purchase#create"
    get "order/purchased", to: "order_purchase#show"
  end

  scope module: :admin_app, as: :admin, constraints: AdminSubdomain do
    get "/", to: "orders#index"
    get :orders, to: "orders#index"
    get "order/:id", to: "orders#show", as: :order
    get "order/:id/toggle_shipped", to: "orders#toggle_shipped", as: :toggle_shipped
    get :feedback, to: "feedback#index"

    get :users, to: "users#index"
    put "users/:id", to: "users#update", as: :user
    get "users/:id/toggle_admin", to: "users#toggle_admin", as: :toggle_admin

    get :products, to: "products#index"
    post :products, to: "products#create"
    put "products/:id", to: "products#update", as: :product
    delete "products/:id", to: "products#destroy"

    delete :return, to: "users#return"
  end
end
