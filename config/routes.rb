Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :merchant do
    get '/:id/dashboard', to: 'dashboard#index'

    get '/:id/items', to: 'items#index'
    get '/:id/items/new', to: 'items#new'
    post '/:id/items', to: 'items#create'
    get '/:id/items/:item_id', to: 'items#show'
    get '/:id/items/:item_id/edit', to: 'items#edit'
    patch '/:id/items/:item_id', to: 'items#update'
    patch '/:id/items', to: 'items#status_update'

    get '/:id/invoices', to: 'invoices#index'
    get '/:id/invoices/:invoice_id', to: 'invoices#show'
    post '/:id/invoices', to: 'invoices#update'
  end

  resources :admin, only: [:index]

  namespace :admin do
    resources :merchants, only: %i[index new create show edit update]
    patch '/merchants', to: 'merchants#update_status'
    resources :invoices, only: %i[index show update]
  end
end
