Tripler::Application.routes.draw do
  constraints(NoSubdomain) do
    root "pages#home"
    get :home, to: "pages#home"
    get :about, to: "pages#about"
    get :jerky, to: "pages#jerky"
    get :custom_orders, to: "pages#custom_orders"
    get :contact, to: "pages#contact"

    post :registration, to: "users#registration"
    post :sign_in, to: "users#sign_in"
    delete :sign_out, to: "users#sign_out"
  end

  constraints(AdminSubdomain) do
    resources :profile # matches if there is a subdomain
  end
end
