Transcoder::Application.routes.draw do
#  resources :contents, only: [:index, :show, :new, :create, :destroy], path_names: { new: :upload }
  resources :contents, except: [:edit, :update], path_names: { new: :upload }

  root to: 'home#index'
end
