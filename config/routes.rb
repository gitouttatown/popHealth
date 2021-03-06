PopHealth::Application.routes.draw do

  apipie

  devise_for :users, :controllers => {:registrations => "registrations"}

  get "admin/users"
  post "admin/promote"
  post "admin/demote"
  post "admin/approve"
  post "admin/disable"
  post "admin/update_npi"
  get "admin/patients"
  get "admin/jobs"
  put "admin/upload_patients"
  put "admin/upload_providers"
  delete "admin/remove_patients"
  delete "admin/remove_caches"
  delete "admin/remove_providers"
  delete "admin/remove_jobs"
  post 'api/measures/finalize'
  post 'api/measures/update_metadata'
  get "logs/index"
  post 'home/set_reporting_period'
  get "admin/user_profile"
  delete "admin/delete_user"
  post 'admin/set_user_practice'
  post 'admin/set_user_practice_provider'
  post "teams/:id/update", :to => 'teams#update'
  post "teams/create"
  post "teams/create_default"
  get 'home/check_authorization'
  delete "practices/remove_patients"
  delete "practices/remove_providers"

  put 'admin/patient', :to => 'admin/patients#upload_single_patient'

  root :to => 'home#index'

  resources :practices

  resources :providers do
    resources :patients do
      collection do
        get :manage
        put :update_all
      end
    end

    get :measure_baseline

    member do
      get :merge_list
      put :merge
    end
  end

  resources :teams

  namespace :api do
    get 'reports/*qrda_cat3.xml', :to =>'reports#cat3', :format => :xml
    get 'reports/*cat1.zip', :to =>'reports#cat1_zip', :format => :zip
    get 'reports/cat1/:id/:measure_ids', :to =>'reports#cat1', :format => :xml
    get 'teams/team_providers/:id', :to => 'teams#team_providers'
    get 'reports/patients', :to => 'reports#patients'
    get 'reports/measures_spreadsheet', :to =>'reports#measures_spreadsheet'
    get 'teams/team_providers/:id', :to => 'teams#team_providers'
    get 'reports/team_report', :to => 'reports#team_report'

    # The OID may contain periods, so specify a regex to allow that
    get 'value_sets/:oid', :to => 'value_sets#show', :oid => /([^\/])+?/, :format => :json

    resources :practices do
      collection do
        get :search
      end
    end
    
    resources :measure_baselines
    resources :practices
    resources :teams
    namespace :admin do
      resource :caches do
        collection do
          get :count
        end
      end
      resource :patients do
        collection do
          get :count
        end
      end
      resource :providers do
        collection do
          get :count
        end
      end
      resources :users do
        member do
          get :enable
          get :disable
          post :promote
          post :demote
          get :approve
          get :update_npi
        end
      end
    end
    resources :providers do
      collection do
        get :search
      end
      resources :patients do
        collection do
          get :manage
          put :update_all
        end
      end
    end
    resources :patients do
      member do
        get :results
      end
    end

    resources :measures

    resources :queries do
       member do
        get :patients
        get :patient_results
        put :recalculate
        post :filter
        post :clearfilters
       end
    end
  end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
