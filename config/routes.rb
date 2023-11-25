Rails.application.routes.draw do
  root "home#index"
  root to: "home#index"

end
