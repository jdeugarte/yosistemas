Yosistemas::Application.routes.draw do
  get "welcome/index"
  get "usuarios/confirm" => "usuarios#confirm"
  get "log_in" => "sessions#new", :as => "log_in"
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "usuarios/index"
  get "usuarios/show"
  get "usuarios/new" => "usuarios#new", :as =>"register"
  get "usuarios/update_password" => "usuarios#update_password", :as=>"update_password"
  get "usuarios/edit" => "usuarios#edit", :as=>"usuario_edit"
  post "usuarios/edit_password" => "usuarios#edit_password", :as=> "edit_password"
  get "temas/search" => "temas#search"
  get "temas/editComment/:idcomment" => "temas#editComment"
  post "comments/editc/:id" => "comments#editc"
  get 'temas/visible/:id' => 'temas#visible', :as => 'visible_tema'
  resources :usuarios do
    resources :comments
  end
  resources :sessions
  resources :temas do
    resources :comments
  end
  resources :comments
  resources :grupos
  #match '/register' => 'usuarios#new'
  #match '/usuarios' => 'usuarios@show'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
 root :to => 'welcome#index'

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
