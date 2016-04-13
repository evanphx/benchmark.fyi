Rails.application.routes.draw do
  root "docs#index"
  post "/reports", to: "reports#create"
  get "/:id", to: "reports#show"
end
