Rails.application.routes.draw do
  post "/reports", to: "reports#create"
  get "/:id", to: "reports#show"
end
