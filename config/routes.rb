Tripler::Application.routes.draw do
  constraints(NoSubdomain) do
    root "pages#home"
    get :home, to: "pages#home"
    get :about, to: "pages#about"
    get :jerky, to: "pages#jerky"
    get :locations, to: "pages#locations"
    get :contact, to: "pages#contact"

    get :admin, to: "users#admin"
    post :registration, to: "users#registration"
    post :sign_in, to: "users#sign_in"
    delete :sign_out, to: "users#sign_out"

    post :feedback, to: "feedback#create"

    post :update_cart, to: "orders#update_cart"
    delete :empty_cart, to: "orders#empty_cart"
    get :review_cart, to: "orders#review_cart"
    post :update_shipping, to: "orders#update_shipping"
    post :purchase, to: "orders#purchase"
  end

  constraints(AdminSubdomain) do
    get "/", to: "orders#index"
    get :orders, to: "orders#index"
    get :feedback, to: "feedback#index"

    get :users, to: "users#index"
    get "users/:id/toggle_admin", to: "users#toggle_admin", as: :toggle_admin

    get :products, to: "products#index"
    post :products, to: "products#create"
    put "products/:id", to: "products#update", as: :product
    delete "products/:id", to: "products#destroy"

    delete :return, to: "users#return"
  end
end
