Tripler::Application.routes.draw do
  constraints(NoSubdomain) do
    root "pages#home"
    get :home, to: "pages#home"
    get :about, to: "pages#about"
    get :jerky, to: "pages#jerky"
    get :custom_orders, to: "pages#custom_orders"
    get :contact, to: "pages#contact"

    get :admin, to: "users#admin"
    post :registration, to: "users#registration"
    post :sign_in, to: "users#sign_in"
    delete :sign_out, to: "users#sign_out"

    post :feedback, to: "feedback#create"
  end

  constraints(AdminSubdomain) do
    get "/", to: "orders#index"
    get :orders, to: "orders#index"
    get :feedback, to: "feedback#index"
    get :products, to: "products#index"
    post :products, to: "products#create"
    get :users, to: "users#index"

    delete :sign_out, to: "users#sign_out"
  end
end
