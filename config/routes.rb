Tripler::Application.routes.draw do
  constraints(NoSubdomain) do
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

    post :order, to: "orders#create"
    get :order, to: "orders#edit"
    put :order, to: "orders#update"
    delete :order, to: "orders#destroy"

    post :purchase, to: "orders#purchase"
    get :purchased, to: "orders#purchased"
  end

  constraints(AdminSubdomain) do
    # Add admin paths back under namespace
  end
end
