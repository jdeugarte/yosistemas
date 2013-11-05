Yosistemas::Application.routes.draw do

  get "comment_tasks/create"
  get "comment_tasks/delete"
  get "comment_tasks/edit"
  get "temas/index"
  post 'temas/edit/:id' => 'temas#edit', :as => 'edit_tema'
  post 'sessions/create' => 'sessions#create', :as => 'loguear'
  get 'sessions/destroy' => 'sessions#destroy', :as => 'desloguear'
  get "usuarios/confirm/:pass" => "usuarios#confirm", :as => 'confirm'
  #get "log_in" => "sessions#new", :as => "log_in"
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "usuarios/index"
  get "usuarios/show"
  get "usuarios/new" => "usuarios#new", :as =>"register"
  get "usuarios/update_password" => "usuarios#update_password", :as=>"update_password"
  get "usuarios/edit" => "usuarios#edit", :as=>"usuario_edit"
  post "usuarios/edit_password" => "usuarios#edit_password", :as=> "edit_password"
  get 'usuarios/password_recovered/:id_user/:id_request' => 'usuarios#recover', :as => 'recover'
  post "usuarios/password_recovered/:id_user/:id_request" => "usuarios#password_recovered", :as=> "password_recovered"
  post "usuarios/send_password_mail" => "usuarios#send_password_mail", :as => "send_password_mail"
  get "usuarios/send_password_mail" => "usuarios#forgot_password", :as => "forgot_password"
  
  get "temas/search/:grupo" => "temas#search"
  get "temas/editComment/:idcomment" => "temas#editComment"
  post "comments/editc/:id" => "comments#editc"
  get "comments/delete/:id" => "comments#delete"
  get "temas/ordertable/:themes/:id/:var" => 'temas#ordertable', :as  => 'ordertable'
  get "temas/ordertablemine/:themes/:var" => 'temas#ordertablemine' , :as => 'ordertablemine'

  get "suscripcion_temas/create/:id" => 'suscripcion_temas#create', :as => 'suscribirse_tema'
  get "suscripcion_temas/delete/:id" => 'suscripcion_temas#delete', :as => 'rechazar_tema'

  get 'temas/visible/:id' => 'temas#visible', :as => 'visible_tema'
  get 'temas/show_mine' => 'temas#show_mine', :as=>'show_mine'
  get 'temas/searchmine' => 'temas#searchmine', :as=>'searchmine'
  #get 'temas/:grupo' => 'temas#index'
  get 'grupos/subscription_group/:id' => 'grupos#subscription_group', :as=>'suscribirse'
  get "grupos/search" => "grupos#search", :as=>'search_grupo'
  get 'grupos/mis_grupos' => 'grupos#mis_grupos', :as => 'mis_grupos'
  get 'grupos/suscriptores/:id' => 'grupos#suscriptores', :as => 'suscriptores'
  get 'gruopos/detalle_usuario/:id' => 'grupos#detalle_usuario', :as => 'detalle_usuario'
  get "subscriptions/delete/:id" => "subscriptions#delete", :as => 'borrar_suscripcion'

  get "grupos/:id/temas"  => "temas#index", :as=> 'filtrar_temas'

  get 'temas/new/:id' => 'temas#new', :as => 'tema_para_grupo'
  get 'tareas/new/:id' => 'tareas#new', :as => 'tarea_para_grupo'
  get 'tareas/eliminar/:id' => 'tareas#eliminar'

  get 'grupos/:grupo/tareas' => 'tareas#index', :as => 'tareas_index'

  get 'tareas/responder_tarea/:id' => 'tareas#responder_tarea', :as =>'responder_tareas'
  post 'tareas/responder_tarea/:id' => 'tareas#responder_tarea_crear', :as =>'responder_tarea_crear'

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
