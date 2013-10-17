Yosistemas::Application.routes.draw do
  get "tareas/new"
  get "temas/index"
  post 'temas/edit/:id' => 'temas#edit', :as => 'edit_tema'
  post 'sessions/create' => 'sessions#create', :as => 'loguear'
  get 'sessions/destroy' => 'sessions#destroy', :as => 'desloguear'
  get "usuarios/confirm" => "usuarios#confirm"
  get "log_in" => "sessions#new", :as => "log_in"
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "usuarios/index"
  get "usuarios/show"
  get "usuarios/new" => "usuarios#new", :as =>"register"
  get "usuarios/update_password" => "usuarios#update_password", :as=>"update_password"
  get "usuarios/edit" => "usuarios#edit", :as=>"usuario_edit"
  get 'usuarios/recover/:id' => 'usuarios#recover', :as => 'recover'
  post "usuarios/edit_password" => "usuarios#edit_password", :as=> "edit_password"
  post "usuarios/password_recovered/:id" => "usuarios#password_recovered", :as=> "password_recovered"
  get "usuarios/forgot_password" => "usuarios#forgot_password", :as => "forgot_password"
  post "usuarios/send_password_mail" => "usuarios#send_password_mail", :as => "send_password_mail"
  get "temas/search/:grupo" => "temas#search"
  get "temas/editComment/:idcomment" => "temas#editComment"
  post "comments/editc/:id" => "comments#editc"
  get "comments/delete/:id" => "comments#delete"

  get "suscripcion_temas/create/:id" => 'suscripcion_temas#create', :as => 'suscribirse_tema'
  get "suscripcion_temas/delete/:id" => 'suscripcion_temas#delete', :as => 'rechazar_tema'

  get 'temas/visible/:id' => 'temas#visible', :as => 'visible_tema'
  get 'temas/show_mine' => 'temas#show_mine', :as=>'show_mine'
  #get 'temas/:grupo' => 'temas#index'
  get 'grupos/subscription_group/:id' => 'grupos#subscription_group', :as=>'suscribirse'
  get "grupos/search" => "grupos#search", :as=>'search_grupo'

  get "grupos/:id/temas"  => "temas#index", :as=> 'filtrar_temas'

  get 'temas/new/:id' => 'temas#new', :as => 'tema_para_grupo'

  post "usuarios/update_user/:id"=>"usuarios#update"
  resources :usuarios do
    resources :comments
  end
  resources :sessions
  resources :temas do
    resources :comments
  end
  resources :comments
  resources :grupos do
    resources :subscriptions
  end
  resources :subscriptions
  resources :tareas
  #match '/register' => 'usuarios#new'
  #match '/usuarios' => 'usuarios@show'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
 root :to => 'temas#index'

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
