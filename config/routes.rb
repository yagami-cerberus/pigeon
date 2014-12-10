Rails.application.routes.draw do
  root 'portable#dashboard'
  get 'my_profile' => 'portable#my_profile'
  get 'change_password' => 'portable#passwd'
  post 'change_password' => 'portable#change_passwd'
  
  match 'login' => 'portable#login', :via => [:get, :post]
  post 'logout' => 'portable#logout'
  
  resources :profiles, :format => false do
    collection do
      get 'search'
      get 'selector_tmpl'
    end
  end
  
  resources :issues, :format => false do
    collection do
      get 'bundle_tmpl'
      get 'sample_tmpl'
      get 'search_bundle'
    end

    member do
      put :update_status
    end
  end
  
  resources :issue_bundles, :path => :inspections, :only => [:index, :show, :update] do
    collection do
      get 'search'
    end
  end
  
  namespace :settings do
    resources :group, :format => false
    
    resources :inspection_bundle, :format => false

    resources :inspection_item, :path => :item, :format => false do
      resources :inspection_atom, :path => :atom, :except => [:index], :format => false
    end
    get 'inspection_type_template', :format => false, :to => 'inspection_atom#type_tmpl'

    resources :issue_statuses, :format => false
    
    resources :user, :format => false do
      member do
        get 'edit_password'
        post 'reset_password'
        post 'set_disabled'
      end
    end
  end
end
