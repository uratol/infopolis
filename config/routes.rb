Rails.application.routes.draw do

  resources :users do
    member do
      get 'masters'
      post 'masters'
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :masters
  

  #match '/signup',  to: 'users#new',            via: 'get'

  match '/auth/:service/callback', to: 'services#create', via: [:get, :post]
  get 'auth/failure', to: redirect('/'), via: [:get, :post]
  resources :services, only: [:index, :create]

  scope "(:locale)", :locale => /ua|en|ru/ do
    root 'static_pages#home'


    match '/signin',  to: 'sessions#new',         via: 'get'
    match '/signout', to: 'sessions#destroy',     via: 'delete'

    match '/about', to: 'static_pages#about', via: 'get'
    match '/reports', to: 'reports#index', via: 'get'
    match '/reports/:report_name', to: 'reports#index', via: [:get, :post]
    match '/reports/:report_name/:master', to: 'reports#index', via: [:get, :post]

    match '/:page_name', to: 'static_pages#any', via: :get
  end

  #get '/reports', to: redirect('/reports/sales')


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
