Tripler::Application.routes.draw do
  root "pages#home"
  get :home, to: "pages#home"
  get :jerky, to: "pages#jerky"
  get :custom_orders, to: "pages#custom_orders"
  get :contact, to: "pages#contact"
end
