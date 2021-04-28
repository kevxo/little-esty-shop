Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :merchant do
    get '/:id/dashboard', to: 'dashboard#index'

    get '/:id/items', to: 'items#index'
    get '/:id/items/:item_id', to: 'items#show'
    get '/:id/items/:item_id/edit', to: 'items#edit'
    patch '/:id/items/:item_id', to: 'items#update'
    patch '/:id/items', to: 'items#status_update'
  end
end
